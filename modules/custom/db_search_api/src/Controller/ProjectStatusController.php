<?php

namespace Drupal\db_search_api\Controller;

use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;

use PDO;

/**
 * Sets the Active/Inactive status of projects (ICRP Managers only).
 *
 * Inactive projects are hidden from everyone except ICRP Managers (epic
 * NCIATWP-11791). Access is limited to the "manager" role by the routes in
 * db_search_api.routing.yml, which also require Drupal's X-CSRF-Token header
 * (GET /session/token). The name recorded as "changed by" always comes from the
 * logged-in Drupal account, never from the request.
 *
 * Request body (JSON):
 *   POST /api/database/project_status          {"project_ids": [101, 102], "active": false}
 *   POST /api/database/project_funding_status  {"project_funding_ids": [5001], "active": true}
 *
 * Response (JSON): {"projects_updated": 2, "sub_projects_updated": 7}
 *
 * Before a bulk change the Search page asks for a preview (NCIATWP-11800):
 *   GET /api/database/project_status/preview?project_ids=101,102
 *   -> [{"project_id": 101, "award_code": "CA1", "sub_projects": 3, "is_active": true}, ...]
 */
class ProjectStatusController extends ControllerBase {

  /** Most IDs accepted in one request. */
  const MAX_IDS = 1000;

  /**
   * Sets base/parent projects and all of their sub-projects Active or Inactive.
   */
  public static function setProjectStatus(Request $request): JsonResponse {
    return self::setStatus($request, 'project_ids', 'SetProjectStatus', '@ProjectIDs');
  }

  /**
   * Sets individual sub-projects (ProjectFunding rows) Active or Inactive.
   */
  public static function setProjectFundingStatus(Request $request): JsonResponse {
    return self::setStatus($request, 'project_funding_ids', 'SetProjectFundingStatus', '@ProjectFundingIDs');
  }

  /**
   * Validates the request body and calls the status procedure.
   */
  private static function setStatus(Request $request, string $idsKey, string $procedure, string $idsParameter): JsonResponse {
    $body = json_decode($request->getContent(), TRUE);
    if (!is_array($body)) {
      return self::error('The request body must be a JSON object.');
    }

    $ids = $body[$idsKey] ?? NULL;
    if (!is_array($ids) || count($ids) === 0) {
      return self::error("'$idsKey' must be a non-empty list of IDs.");
    }
    if (count($ids) > self::MAX_IDS) {
      return self::error("Send at most " . self::MAX_IDS . " IDs per request.");
    }
    foreach ($ids as $id) {
      if (!is_int($id) || $id < 1) {
        return self::error("'$idsKey' may only contain positive whole numbers.");
      }
    }

    $active = $body['active'] ?? NULL;
    if (!is_bool($active)) {
      return self::error("'active' must be true or false.");
    }

    $changedBy = mb_substr(\Drupal::currentUser()->getAccountName(), 0, 100);
    $idList = implode(',', array_unique($ids));
    $isActive = $active ? 1 : 0;

    try {
      $pdo = PDOBuilder::getConnection('icrp_database');
      $stmt = $pdo->prepare("SET NOCOUNT ON; EXECUTE $procedure $idsParameter = :ids, @IsActive = :is_active, @ChangedBy = :changed_by");
      $stmt->bindValue(':ids', $idList, PDO::PARAM_STR);
      $stmt->bindValue(':is_active', $isActive, PDO::PARAM_INT);
      $stmt->bindValue(':changed_by', $changedBy, PDO::PARAM_STR);
      $stmt->execute();
      $row = $stmt->fetch(PDO::FETCH_ASSOC) ?: [];
    }
    catch (\PDOException $e) {
      error_log("$procedure failed: " . $e->getMessage());
      return new JsonResponse(['error' => 'The status could not be changed.'], 500);
    }

    return new JsonResponse([
      'projects_updated' => (int) ($row['ProjectsUpdated'] ?? 0),
      'sub_projects_updated' => (int) ($row['SubProjectsUpdated'] ?? 0),
    ]);
  }

  /**
   * Award code, sub-project count and status of each selected project, so the
   * Search page can warn before changing projects that have sub-projects.
   */
  public static function previewProjects(Request $request): JsonResponse {
    $raw = (string) $request->query->get('project_ids', '');
    if (!preg_match('/^\d+(,\d+)*$/', $raw)) {
      return self::error("'project_ids' must be a comma-separated list of positive whole numbers.");
    }
    $ids = array_values(array_unique(array_map('intval', explode(',', $raw))));
    if (count($ids) > self::MAX_IDS) {
      return self::error("Send at most " . self::MAX_IDS . " IDs per request.");
    }
    if (in_array(0, $ids, TRUE)) {
      return self::error("'project_ids' may only contain positive whole numbers.");
    }

    try {
      $pdo = PDOBuilder::getConnection('icrp_database');
      $stmt = $pdo->prepare("SET NOCOUNT ON;
        SELECT p.ProjectID, p.AwardCode, p.IsActive, COUNT(f.ProjectFundingID) AS SubProjects
        FROM Project p
          LEFT JOIN ProjectFunding f ON f.ProjectID = p.ProjectID
        WHERE p.ProjectID IN (SELECT [VALUE] FROM dbo.ToIntTable(:ids))
        GROUP BY p.ProjectID, p.AwardCode, p.IsActive
        ORDER BY p.AwardCode");
      $stmt->bindValue(':ids', implode(',', $ids), PDO::PARAM_STR);
      $stmt->execute();
      $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    catch (\PDOException $e) {
      error_log("Project status preview failed: " . $e->getMessage());
      return new JsonResponse(['error' => 'The projects could not be read.'], 500);
    }

    return new JsonResponse(array_map(function ($row) {
      return [
        'project_id' => (int) $row['ProjectID'],
        'award_code' => $row['AwardCode'],
        'sub_projects' => (int) $row['SubProjects'],
        'is_active' => (bool) $row['IsActive'],
      ];
    }, $rows));
  }

  private static function error(string $message): JsonResponse {
    return new JsonResponse(['error' => $message], 400);
  }

}
