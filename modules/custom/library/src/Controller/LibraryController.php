<?php

namespace Drupal\library\Controller;

use Drupal\Core\Controller\ControllerBase;
use Ds\Set;
use Symfony\Component\HttpFoundation\BinaryFileResponse;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use PDO;

class LibraryController extends ControllerBase {
  public function testQuery() {
    $return = array();
    $connection = self::get_connection();
    $stmt = $connection->prepare(
      "SELECT CASE WHEN ArchivedDate IS NULL THEN NULL ELSE GETDATE() END AS x FROM LibraryFolder WHERE LibraryFolderID=3082"
    );
    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $row_output = array();
        foreach ($row as $key=>$value) {
          $row_output[$key] = $value;
        }
        array_push($return,$row_output);
      }
    }
    return new JsonResponse($return);
  }

  private static $initFolderQuery = array(
    "public" => "SELECT * FROM LibraryFolder WHERE IsPublic=1 AND archivedDate IS NULL AND ParentFolderID > 0 ORDER BY Name;",
    "private" => "SELECT * FROM LibraryFolder WHERE archivedDate IS NULL AND ParentFolderID > 0 ORDER BY Name;",
    "partner" => "SELECT * FROM LibraryFolder WHERE archivedDate IS NULL AND ParentFolderID > 0 ORDER BY Name;",
    "admin" => "SELECT ".
          "a.*, ".
          "COUNT(b.ArchivedDate) AS ArchivedCount, ".
          "SUM(CASE WHEN b.ArchivedDate IS NULL THEN 1 ELSE 0 END)-SUM(CASE WHEN b.LibraryID IS NULL THEN 1 ELSE 0 END) AS UnarchivedCount ".
        "FROM LibraryFolder a ".
        "LEFT OUTER JOIN Library b ON a.LibraryFolderID = b.LibraryFolderID ".
        "WHERE a.ParentFolderID > 0 ".
        "GROUP BY a.Name, a.LibraryFolderID, a.ParentFolderID, a.IsPublic, a.ArchivedDate, a.CreatedDate, a.UpdatedDate ".
        "ORDER BY a.Name;"
  );
  private static $folderQuery = array(
    "public" => "SELECT * FROM LibraryFolder WHERE IsPublic=1 AND archivedDate IS NULL AND LibraryFolderID=:lfid;",
    "private" => "SELECT * FROM LibraryFolder WHERE archivedDate IS NULL AND LibraryFolderID=:lfid;",
    "partner" => "SELECT * FROM LibraryFolder WHERE archivedDate IS NULL AND LibraryFolderID=:lfid;",
    "admin" => "SELECT * FROM LibraryFolder WHERE archivedDate IS NULL AND LibraryFolderID=:lfid;"
  );
  private static $fileQuery = array(
    "public" => "SELECT * FROM Library WHERE IsPublic=1 AND archivedDate IS NULL AND LibraryFolderID=:lfid ORDER BY Title;",
    "private" => "SELECT * FROM Library WHERE archivedDate IS NULL AND LibraryFolderID=:lfid ORDER BY Title;",
    "partner" => "SELECT * FROM Library WHERE archivedDate IS NULL AND LibraryFolderID=:lfid ORDER BY Title;",
    "admin" => "SELECT * FROM Library WHERE LibraryFolderID=:lfid ORDER BY Title;"
  );
  private static $fileSearch = array(
    "public" => "SELECT * FROM Library WHERE IsPublic=1 AND archivedDate IS NULL AND LOWER(Filename) LIKE :keywords ORDER BY Title;",
    "private" => "SELECT * FROM Library WHERE archivedDate IS NULL AND LOWER(Filename) LIKE :keywords ORDER BY Title;",
    "partner" => "SELECT * FROM Library WHERE archivedDate IS NULL AND LOWER(Filename) LIKE :keywords ORDER BY Title;",
    "admin" => "SELECT * FROM Library WHERE LOWER(Filename) LIKE :keywords ORDER BY Title;"
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
      "folders" => []
    );
    $returnValue["role"] = self::getRole();
    $connection = self::get_connection();
    $stmt = $connection->prepare(self::$initFolderQuery[$returnValue["role"]]);
    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $row_output = array();
        foreach ($row as $key=>$value) {
          $row_output[$key] = $value;
        }
        array_push($returnValue["folders"],$row_output);
      }
      $returnValue["initial"] = $returnValue["folders"][0];
    }
    return new JsonResponse($returnValue);
  }

  public function getArchivedFolders() {
    $connection = self::get_connection();
    $stmt = $connection->prepare(
      "SELECT DISTINCT a.* FROM LibraryFolder a ".
          "LEFT OUTER JOIN Library b ON a.LibraryFolderID = b.LibraryFolderID ".
          "WHERE a.ParentFolderID > 0 AND (a.ArchivedDate IS NOT NULL or b.ArchivedDate IS NOT NULL) ".
          "ORDER BY Name"
    );
    if ($stmt->execute()) {
      $folders = array();
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $row_output = array();
        foreach ($row as $key=>$value) {
          $row_output[$key] = $value;
        }
        array_push($folders,$row_output);
      }
      return new JsonResponse(array(
        "success"=>true,
        "folders"=>$folders
      ));
    }
    return new JsonResponse(array(
      "success"=>false
    ), Response::HTTP_INTERNAL_SERVER_ERROR);
  }

  public function getArchivedFiles($id) {
    $connection = self::get_connection();
    $stmt = $connection->prepare("SELECT * FROM Library WHERE ArchivedDate IS NOT NULL AND LibraryFolderID=:lfid ORDER BY Title");
    $stmt->bindParam(":lfid",$id);
    if ($stmt->execute()) {
      $files = array();
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $row_output = array();
        foreach ($row as $key=>$value) {
          $row_output[$key] = $value;
        }
        array_push($files,$row_output);
      }
      return new JsonResponse(array(
        "success"=>true,
        "files"=>$files
      ));
    }
    return new JsonResponse(array(
      "success"=>false
    ), Response::HTTP_INTERNAL_SERVER_ERROR);
  }

  public function searchFiles() {
    $role = self::getRole();
    $keywords = \Drupal::request()->request->get('keywords');
    $keywords = '%'.$keywords.'%';
    $result = array();
    $connection = self::get_connection();
    $stmt = $connection->prepare(self::$fileSearch[$role]);
    $stmt->bindParam(":keywords",$keywords);
    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $row_output = array();
        foreach ($row as $key=>$value) {
          $row_output[$key] = $value;
        }
        array_push($result,$row_output);
      }
    }
    return new JsonResponse($result);
  }

  public function fileRest($id) {
    $method = \Drupal::request()->getMethod();
    switch ($method) {
      case "GET":
        return self::fileDownload($id);
        break;
      case "DELETE":
        if (self::getRole() == "admin") {
          return new JsonResponse(self::archiveFile($id));
        } else {
          return new JsonResponse(array(
            "success"=>false
          ), Response::HTTP_FORBIDDEN);
        }
        break;
      case "PUT":
        if (self::getRole() == "admin") {
          return new JsonResponse(self::unarchiveFile($id));
        } else {
          return new JsonResponse(array(
            "success"=>false
          ), Response::HTTP_FORBIDDEN);
        }
        break;
    }
  }

  public function folderRest($id) {
    $method = \Drupal::request()->getMethod();
    switch ($method) {
      case "GET":
        return self::getFolder($id);
        break;
      case "DELETE":
        if (self::getRole() == "admin") {
          return new JsonResponse(self::archiveFolder($id));
        } else {
          return new JsonResponse(array(
            "success"=>false
          ), Response::HTTP_FORBIDDEN);
        }
        break;
      case "PUT":
        if (self::getRole() == "admin") {
          return new JsonResponse(self::unarchiveFolder($id));
        } else {
          return new JsonResponse(array(
            "success"=>false
          ), Response::HTTP_FORBIDDEN);
        }
        break;
    }
  }

  public function postFolder() {
    $params = \Drupal::request()->request->all();
    if (!isset($params['is_public'])) {
      $params['is_public'] = "0";
    }
    if (!isset($params["title"]) || empty($params["title"]) ||
        !isset($params["parent"]) || !is_numeric($params["parent"])) {
      return new JsonResponse(array(
          "success"=>false
      ));
    }
    $connection = self::get_connection();
    $stmt = $connection->prepare("SELECT CASE WHEN ArchivedDate IS NULL THEN NULL ELSE GETDATE() END AS ArchivedDate FROM LibraryFolder WHERE LibraryFolderID=:pfid");
    $stmt->bindParam(":pfid",$params["parent"]);
    if ($stmt->execute()) {
      $row_output = array();
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        foreach ($row as $key=>$value) {
          $row_output[$key] = $value;
        }
        break;
      }
      $stmt = $connection->prepare("INSERT INTO LibraryFolder (Name,ParentFolderID,IsPublic,ArchivedDate) OUTPUT INSERTED.* VALUES (:name,:pfid,:ip,:ad);");
      $stmt->bindParam(":name",$params["title"]);
      $stmt->bindParam(":pfid",$params["parent"]);
      $stmt->bindParam(":ip",$params["is_public"]);
      $stmt->bindParam(":ad",$row_output["ArchivedDate"]);
      if ($stmt->execute()) {
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
          $row_output = array();
          foreach ($row as $key=>$value) {
            $row_output[$key] = $value;
          }
          return new JsonResponse(array(
            "success"=>true,
            "row"=>$row_output
          ));
        }
      }
    }
  }

  public function postFile() {
    $role = self::getRole();
    if ($role == "public" || $role == "private") {
      return new JsonResponse(array(
          "success"=>false
      ),Response::HTTP_FORBIDDEN);
    }
    $params = \Drupal::request()->request->all();
    if (!isset($params['is_public'])) {
      $params['is_public'] = "0";
    }
    $upload = \Drupal::request()->files->get('upload');
    $thumb = \Drupal::request()->files->get('thumbnail');
    if (!isset($params["title"]) || empty($params["title"]) ||
        !isset($params["parent"]) || !is_numeric($params["parent"]) ||
        !$upload->isValid() ||
          ($params['is_public'] != "0" &&
            (!$thumb->isValid() || !isset($params["description"]) || empty($params["description"]))
        )) {
      return new JsonResponse(array(
          "success"=>false
      ),Response::HTTP_BAD_REQUEST);
    }
    $upload->move("public://library/uploads",$upload->getClientOriginalName());
    $thumb->move("public://library/uploads/thumbs",$thumb->getClientOriginalName());
    $connection = self::get_connection();
    $stmt = $connection->prepare("INSERT INTO Library (Title,LibraryFolderID,Filename,ThumbnailFilename,Description,IsPublic) OUTPUT INSERTED.* VALUES (:title,:lfid,:file,:thumb,:desc,:ip);");
    $stmt->bindParam(":title",$params["title"]);
    $stmt->bindParam(":lfid",$params["parent"]);
    $stmt->bindParam(":file",$upload->getClientOriginalName());
    $stmt->bindParam(":thumb",$thumb->getClientOriginalName());
    $stmt->bindParam(":desc",$params["description"]);
    $stmt->bindParam(":ip",$params["is_public"]);
    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $row_output = array();
        foreach ($row as $key=>$value) {
          $row_output[$key] = $value;
        }
        return new JsonResponse(array(
          "success"=>true,
          "row"=>$row_output
        ));
      }
    }
    return new JsonResponse(array(
        "success"=>false
    ),Response::HTTP_INTERNAL_SERVER_ERROR);
  }

  public function thumbsDownload($file) {
    if (self::getRole() == "public") {
      $connection = self::get_connection();
      $stmt = $connection->prepare("SELECT IsPublic FROM Library WHERE IsPublic=1 AND ThumbnailFilename=:file");
      $stmt->bindParam(":file",$file);
      if (!$stmt->execute() || $stmt->rowCount() == 0) {
        return new JsonResponse($stmt->rowCount(),$status=Response::HTTP_FORBIDDEN);
      }
    }
    return self::getFile(join('/',array("thumbs",$file)));
  }

  private function archiveFile($id) {
    $connection = self::get_connection();
    $stmt = $connection->prepare("UPDATE Library SET ArchivedDate=GETDATE() WHERE LibraryID=:lid");
    $stmt->bindParam(":lid",$id);
    if ($stmt->execute()) {
      return array(
        "success"=>true
      );
    }
    return array(
      "success"=>false,
      Response::HTTP_INTERNAL_SERVER_ERROR
    );
  }

  private function unarchiveFile($id) {
    $returnValue = array(
      "success"=>false
    );
    $connection = self::get_connection();
    $stmt1 = $connection->prepare("UPDATE Library SET ArchivedDate=NULL WHERE LibraryID=:lid");
    $stmt1->bindParam(":lid",$id);
    $stmt2 = $connection->prepare("SELECT * FROM Library WHERE LibraryID=:lid");
    $stmt2->bindParam(":lid",$id);
    if ($stmt1->execute() && $stmt2->execute()) {
      $returnValue['success'] = true;
      while ($row = $stmt2->fetch(PDO::FETCH_ASSOC)) {
        $row_output = array();
        foreach ($row as $key=>$value) {
          $row_output[$key] = $value;
        }
        $result = self::unarchiveFolder($row_output['LibraryFolderID']);
        if ($result["success"]) {
          $returnValue['ids'] = $result['ids'];
        } else {
          $returnValue['success'] = false;
        }
      }
    }
    return $returnValue;
  }

  private function archiveFolder($id) {
    $connection = self::get_connection();
    $stmt1 = $connection->prepare("UPDATE LibraryFolder SET ArchivedDate=GETDATE() WHERE ArchivedDate IS NULL AND LibraryFolderID=:lfid;");
    $stmt1->bindParam(":lfid",$id);
    $stmt2 = $connection->prepare("UPDATE Library SET ArchivedDate=GETDATE() WHERE ArchivedDate IS NULL AND LibraryFolderID=:lfid;");
    $stmt2->bindParam(":lfid",$id);
    if ($stmt1->execute() && $stmt2->execute()) {
      $success = true;
      $stmt = $connection->prepare("SELECT LibraryFolderID FROM LibraryFolder WHERE ArchivedDate IS NULL AND ParentFolderID=:pfid;");
      $stmt->bindParam(":pfid",$id);
      if ($stmt->execute()) {
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
          $row_output = array();
          foreach ($row as $key=>$value) {
            $row_output[$key] = $value;
          }
          $id = $row_output['LibraryFolderID'];
          $result = self::archiveFolder($id);
          if (!$result["success"]) $success = false;
        }
      }
      return array(
        "success"=>$success
      );
    }
    return array(
      "success"=>false
    );
  }

  private function unarchiveFolder($id) {
    $returnValue = array(
      "success"=>false,
      "ids"=>array($id)
    );
    $connection = self::get_connection();
    $stmt1 = $connection->prepare("SELECT ParentFolderID FROM LibraryFolder WHERE ArchivedDate IS NOT NULL AND ParentFolderID > 0 AND LibraryFolderID=:lfid;");
    $stmt1->bindParam(":lfid",$id);
    $stmt2 = $connection->prepare("UPDATE LibraryFolder SET ArchivedDate=NULL WHERE ArchivedDate IS NOT NULL AND LibraryFolderID=:lfid");
    $stmt2->bindParam(":lfid",$id);
    if ($stmt1->execute() && $stmt2->execute()) {
      $returnValue['success'] = true;
      while ($row = $stmt1->fetch(PDO::FETCH_ASSOC)) {
        $row_output = array();
        foreach ($row as $key=>$value) {
          $row_output[$key] = $value;
        }
        $id = $row_output['ParentFolderID'];
        $result = self::unarchiveFolder($id);
        if (!$result["success"]) $returnValue['success'] = false;
        $returnValue['ids'] = array_merge($returnValue['ids'],$result['ids']);
      }
    }
    return $returnValue;
  }

  private function fileDownload($file) {
    if (self::getRole() == "public") {
      $connection = self::get_connection();
      $stmt = $connection->prepare("SELECT IsPublic FROM Library WHERE IsPublic=1 AND Filename=:file");
      $stmt->bindParam(":file",$file);
      if (!$stmt->execute() || $stmt->rowCount() == 0) {
        return new JsonResponse($stmt->rowCount(),$status=Response::HTTP_FORBIDDEN);
      }
    }
    return self::getFile($file);
  }

  private function getFile($location) {
    return new BinaryFileResponse(join('/',array(drupal_realpath('public://library/uploads'),$location)));
  }

  private function getFolder($id) {
    $returnValue = array(
      "isPublic" => false,
      "files" => []
    );
    $role = self::getRole();
    $connection = self::get_connection();
    $stmt = $connection->prepare(self::$folderQuery[$role]);
    $stmt->bindParam(":lfid",$id);
    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $returnValue["isPublic"] = $row["IsPublic"]=="1";
        break;
      }
      $stmt = $connection->prepare(self::$fileQuery[$role]);
      $stmt->bindParam(":lfid",$id);
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

  private function getRole() {
    $role = "public";
    $authenticated = parent::currentUser()->isAuthenticated();
    if ($authenticated) {
      if (parent::currentUser()->hasPermission('field_can_upload_library_files')) {
        $role = "partner";
      } else {
        $role = "private";
      }
      foreach (parent::currentUser()->getRoles() as $value) {
        if ($value == "administrator" || $value == "manager") {
          $role = "admin";
          break;
        }
      }
    }
    return $role;
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
  private function get_connection() {
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