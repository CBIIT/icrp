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

  private static function error(string $message): JsonResponse {
    return new JsonResponse(['error' => $message], 400);
  }

}
