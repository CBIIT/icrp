<?php

include 'getDBConnection.php';

function getProjectInfo($projectID) {
  $pdo = getDBConnection(parse_ini_file("config.ini"));

  $projectInfo = array();
  $projectCancerTypes = array();
  $projectCSOAreas = array();

  $stmtInfo = $pdo->prepare("CALL GetProjectInfo(?)");
  $stmtInfo->bindParam(1, $projectID, PDO::PARAM_INT, 1000000); 

  $stmtCancerType = $pdo->prepare("CALL GetProjectCancerType(?)");
  $stmtCancerType->bindParam(1, $projectID, PDO::PARAM_INT, 100000); 

  $stmtProjectCSO = $pdo->prepare("CALL GetProjectCSO(?)");
  $stmtProjectCSO->bindParam(1, $projectID, PDO::PARAM_INT, 100000); 


  if ($stmtInfo->execute()) {
    while ($row = $stmtInfo->fetch()) {
      array_push($projectInfo, $row);
    }
  }

/*


  if ($stmtCancerType->execute()) {
    while ($row2 = $stmtCancerType->fetch()) {
      array_push($projectCancerTypes, 'abc');
    }
  }

  if ($stmtProjectCSO->execute()) {
    while ($row = $stmtProjectCSO->fetch()) {
      array_push($projectCSOAreas, $row);
    }
  }

*/
  $pdo = null;

  if (!empty($projectInfo)) {
    $result = $projectInfo[0];

    $result['CancerTypes'] = json_encode($projectCancerTypes);
    $result['CsoAreas'] = json_encode($projectCSOAreas);

    return $result;
    
  }
  
  return null;
}