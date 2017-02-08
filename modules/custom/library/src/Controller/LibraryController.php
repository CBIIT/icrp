<?php

namespace Drupal\library\Controller;

use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\JsonResponse;
use PDO;

class LibraryController extends ControllerBase {
  private static $folderQuery = array(
    "public" => "SELECT * FROM LibraryFolder WHERE IsPublic=1 AND archivedDate IS NULL;",
    "partner" => "SELECT * FROM LibraryFolder WHERE archivedDate IS NULL;",
    "admin" => "SELECT * FROM LibraryFolder WHERE archivedDate IS NULL ORDER BY ParentFolderID;"
  );

  public function content() {
    return [
      '#theme' => 'library',
      '#attached' => [
        'library' => [
          'library/resources'
        ],
      ],
    ];
  }

  public function onLoad() {
    $returnValue = array(
      "role" => "public",
      "initial" => array(),
      "folders" => [],
      "files" => []
    );
    $authenticated = parent::currentUser()->isAuthenticated();
    if ($authenticated) {
      $returnValue["role"] = "partner";
      foreach (parent::currentUser()->getRoles() as $value) {
        if ($value == "administrator") {
          $returnValue["role"] = "admin";
          break;
        }
      }
    }
    $connection = self::get_connection();
    $stmt = $connection->prepare(self::$folderQuery[$returnValue["role"]]);
    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $row_output = array();
        foreach ($row as $key=>$value) {
          $row_output[$key] = $value;
        }
        array_push($returnValue["folders"],$row_output);
      }
      $returnValue["initial"] = $returnValue["folders"][0];
      $stmt = $connection->prepare("SELECT * FROM Library WHERE LibraryFolderID=:lfid");
      $stmt->bindParam(":lfid",$returnValue["initial"]["LibraryFolderID"]);
      if ($stmt->execute()) {
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
          $row_output = array();
          foreach ($row as $key=>$value) {
            $row_output[$key] = $value;
          }
          array_push($returnValue["files"],$row_output);
        }
      }
    }
    return new JsonResponse($returnValue);
  }

  /**
   * Returns a PDO connection to a database
   * @param $cfg - An associative array containing connection parameters 
   *   driver:    DB Driver
   *   server:    Server Name
   *   database:  Database
   *   user:      Username
   *   password:  Password
   *
   * @return A PDO connection
   * @throws PDOException
   */
  function get_connection() {
    $cfg = [];
    $icrp_database = \Drupal::config('icrp_database');
    foreach(['driver', 'host', 'port', 'database', 'username', 'password'] as $key) {
       $cfg[$key] = $icrp_database->get($key);
    }
    // connection string
    $cfg['dsn'] =
      $cfg['driver'] .
      ":Server={$cfg['host']},{$cfg['port']}" .
      ";Database={$cfg['database']};ConnectionPooling=0";
    // default configuration options
    $cfg['options'] = [
      PDO::SQLSRV_ATTR_ENCODING    => PDO::SQLSRV_ENCODING_UTF8,
      PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
      PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
  //  PDO::ATTR_EMULATE_PREPARES   => false,
    ];
    // create new PDO object
    return new PDO(
      $cfg['dsn'],
      $cfg['username'],
      $cfg['password'],
      $cfg['options']
    );
  }
}