<?php

namespace Drupal\db_admin\Controller;
use Drupal\db_admin\Helpers\PDOBuilder;
use PDO;

class FundingOrganizationManager {

  const FUNDING_ORGANIZATION_PARAMETERS = [
    'sponsor_code'              => NULL,
    'member_type'               => NULL,
    'organization_name'         => NULL,
    'organization_abbreviation' => NULL,
    'organization_type'         => NULL,
    'is_annualized'             => NULL,
    'country'                   => NULL,
    'currency'                  => NULL,
    'note'                      => NULL,
  ];

  public static function getFields(PDO $pdo) {
    $queries = [
      'partners'    =>  'SELECT 
                          p.SponsorCode AS value, 
                          p.Name AS label, 
                          p.Country AS country, 
                          c.Currency AS currency 
                          FROM Partner p
                          LEFT JOIN Country c ON p.Country = c.Abbreviation
                          ORDER BY label ASC',
      'countries'   =>  'SELECT
                          LTRIM(RTRIM(Abbreviation)) AS value, 
                          name AS label, 
                          Currency AS currency 
                          FROM icrp_data.dbo.Country
                          ORDER BY label ASC',
      'currencies'  =>  'SELECT
                          LTRIM(RTRIM(Code)) AS value, 
                          Description AS label 
                          FROM Currency
                          ORDER BY label ASC',
    ]; 

    // map query results to field values
    $fields = [];
    foreach ($queries as $key => $value)
      $fields[$key] = $pdo->query($value)->fetchAll(PDO::FETCH_ASSOC);

    return $fields;
  }

  public static function validate(PDO $pdo, array $parameters) {
    $required_keys = array_keys(self::FUNDING_ORGANIZATION_PARAMETERS);
    $errors = [];

    foreach($required_keys as $key) {
      if (!array_key_exists($key, $parameters)) {
        array_push($errors, ['ERROR' => "Parameter [$key] not found."]);
      }
    }

    $stmt = $pdo->prepare("
      SELECT * FROM FundingOrg 
      WHERE (Name = :organization_name OR Abbreviation = :abbreviation) 
      AND SponsorCode = :sponsor_code
    ");

    if ($stmt->execute([
      ':organization_name'  => $parameters['organization_name'],
      ':abbreviation'       => $parameters['organization_abbreviation'],
      ':sponsor_code'       => $parameters['sponsor_code'],
    ])) {
      if (!empty($stmt->fetch())) {
        array_push($errors, [
          'ERROR' => 'A funding organization with the same name and sponsor code already exists in the database. '
            . 'No changes have been made.'
          ]);
      }
    }

    return $errors;
  }

  public static function addFundingOrganization(PDO $pdo, array $parameters) {
    $validation_errors = self::validate($pdo, $parameters);

    if (!empty($validation_errors)) {
      return $validation_errors;
    }
    
    try {

      $stmt = PDOBuilder::createPreparedStatement(
        $pdo, 
        "INSERT INTO FundingOrg (
          Name, 
          Abbreviation, 
          Type, 
          MapCoords,
          Country, 
          Currency, 
          SponsorCode, 
          MemberType, 
          MemberStatus, 
          IsAnnualized, 
          Note
        ) VALUES (
          :organization_name, 
          :organization_abbreviation,
          :organization_type,
          :map_coordinates,
          :country,
          :currency,
          :sponsor_code,
          :member_type,
          'Current',
          :is_annualized,
          :note
        )",
      $parameters);

      if ($stmt->execute()) {
        return [
          ['SUCCESS' => 'The funding organization has been added to the database.']
        ];
      }
    }

    catch (Exception $e) {
      return [
        ['ERROR' => $e->getMessage()]
      ];
    }

    return [false];
  }
}

