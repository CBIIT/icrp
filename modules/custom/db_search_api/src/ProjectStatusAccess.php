<?php

namespace Drupal\db_search_api;

use PDO;
use Symfony\Component\HttpFoundation\JsonResponse;

/**
 * Who may see inactive projects in Search and Analyze (NCIATWP-11796).
 *
 * The visibility mode is always decided here, on the server, from the current
 * user's roles: only the ICRP Manager role may search for inactive projects.
 * Everyone else (anonymous users, Partners and administrators) always gets
 * Active, whatever the request asks for.
 */
class ProjectStatusAccess {

  const ACTIVE = 'Active';
  const INACTIVE = 'Inactive';

  /**
   * Whether the current user has the ICRP Manager role.
   */
  public static function isManager(): bool {
    return in_array('manager', \Drupal::currentUser()->getRoles(), TRUE);
  }

  /**
   * The mode to search in: Inactive only when a Manager asks for it.
   *
   * @param mixed $requested
   *   The project_status value from the request ('active' or 'inactive').
   */
  public static function resolveSearchMode($requested): string {
    return self::isManager() && strcasecmp(trim((string) $requested), self::INACTIVE) === 0
      ? self::INACTIVE
      : self::ACTIVE;
  }

  /**
   * Whether the current user may open a saved search.
   *
   * Search IDs are sequential, so a non-manager must not be able to open a
   * Manager's search for inactive projects by guessing its ID.
   *
   * @param \PDO $pdo
   *   A connection to icrp_data.
   * @param mixed $search_id
   *   The saved search ID; 0 or less is the default (unfiltered, active) search.
   */
  public static function canViewSearch(PDO $pdo, $search_id): bool {
    $search_id = intval($search_id);
    if ($search_id <= 0 || self::isManager()) {
      return TRUE;
    }
    $stmt = $pdo->prepare('SELECT ProjectStatus FROM SearchCriteria WHERE SearchCriteriaID = :search_id');
    $stmt->bindValue(':search_id', $search_id, PDO::PARAM_INT);
    $stmt->execute();
    return $stmt->fetchColumn() !== self::INACTIVE;
  }

  /**
   * The response for a non-manager asking for a Manager's inactive search.
   */
  public static function forbiddenResponse(): JsonResponse {
    return new JsonResponse(['error' => 'This search is not available.'], 403);
  }

}
