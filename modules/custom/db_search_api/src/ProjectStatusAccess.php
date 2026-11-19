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
    return self::isManager() || !self::isInactiveSearch($pdo, $search_id);
  }

  /**
   * Whether a saved search was built in Inactive mode (a Manager's search).
   *
   * @param \PDO $pdo
   *   A connection to icrp_data (not icrp_dataload, which has no such column).
   * @param mixed $search_id
   *   The saved search ID.
   */
  public static function isInactiveSearch(PDO $pdo, $search_id): bool {
    $search_id = intval($search_id);
    if ($search_id <= 0) {
      return FALSE;
    }
    $stmt = $pdo->prepare('SELECT ProjectStatus FROM SearchCriteria WHERE SearchCriteriaID = :search_id');
    $stmt->bindValue(':search_id', $search_id, PDO::PARAM_INT);
    $stmt->execute();
    return $stmt->fetchColumn() === self::INACTIVE;
  }

  /**
   * Cleans a list of IDs typed by a Manager (NCIATWP-11892): keeps whole
   * numbers only, removes duplicates and returns them comma-separated, or NULL
   * when there are none. Accepts commas, spaces or line breaks between IDs.
   *
   * @param mixed $raw
   *   The text from the request.
   * @param int $max
   *   Most IDs kept.
   */
  public static function sanitizeIdList($raw, int $max = 1000): ?string {
    if (!is_string($raw) || trim($raw) === '') {
      return NULL;
    }
    preg_match_all('/\d+/', $raw, $matches);
    $kept = [];
    $length = 0;
    foreach (array_unique($matches[0]) as $digits) {
      $id = ltrim($digits, '0');
      // Whole numbers that fit SQL Server's INT, and a list that fits the 4000-character column
      if ($id === '' || strlen($id) > 10 || (int) $id > 2147483647) {
        continue;
      }
      if (count($kept) >= $max || $length + strlen($id) + 1 > 4000) {
        break;
      }
      $kept[] = $id;
      $length += strlen($id) + 1;
    }
    return $kept ? implode(',', $kept) : NULL;
  }

  /**
   * The response for a non-manager asking for a Manager's inactive search.
   */
  public static function forbiddenResponse(): JsonResponse {
    return new JsonResponse(['error' => 'This search is not available.'], 403);
  }

}
