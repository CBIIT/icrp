<?php

include 'getDBConnection.php';

function getProjectCancerTypes($projectID) {
  $pdo = getDBConnection(parse_ini_file("config.ini"));
  $stmt = $pdo->prepare("CALL GetProjectCancerTypes(?)");
  $stmt->bindParam(1, $projectID, PDO::PARAM_INT, 1000000); 

  $stmt->execute();
  return $stmt->fetchAll();
}

function getProjectCSOCodes($projectID) {
  $pdo = getDBConnection(parse_ini_file("config.ini"));
  $stmt = $pdo->prepare("CALL GetProjectCSOCodes(?)");
  $stmt->bindParam(1, $projectID, PDO::PARAM_INT, 1000000); 

  $stmt->execute();
  return $stmt->fetchAll();
}

function getProjectInfo($projectID) {
  $pdo = getDBConnection(parse_ini_file("config.ini"));
  $stmt = $pdo->prepare("CALL GetProjectInfo(?)");
  $stmt->bindParam(1, $projectID, PDO::PARAM_INT, 1000000); 

  $results = array();
  
  if ($stmt->execute()) {
    while ($row = $stmt->fetch()) {
      foreach (array_keys($row) as $key) {

        if (!isset($results[$key])) {
          $results[$key] = array();
        }

        array_push($results[$key], $row[$key]);
      }
    }
  }

  $results['cancer_types'] = getProjectCancerTypes($projectID);
  $results['cso_areas'] = getProjectCSOCodes($projectID);

  return $results;
}