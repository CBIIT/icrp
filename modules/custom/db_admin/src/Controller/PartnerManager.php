<?php

namespace Drupal\db_admin\Controller;
use Drupal\db_admin\Helpers\PDOBuilder;
use PDO;

class PartnerManager {

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

  const PARTNER_PARAMETERS = [
    'partner_name'              => NULL,
    'joined_date'               => NULL,
    'country'                   => NULL,
    'email'                     => NULL,
    'description'               => NULL,
    'sponsor_code'              => NULL,
    'website'                   => NULL,
    'map_coordinates'           => NULL,
    'logo_file'                 => NULL,
    'note'                      => NULL,
    'agree_to_terms'            => NULL,
    'is_funding_organization'   => NULL,
    'organization_type'         => NULL,
    'is_annualized'             => NULL,
    'currency'                  => NULL,
  ];


  public static function getFields(PDO $pdo) {
    $fields = [];
    $queries = [
      'partners'    =>  "SELECT
                          PartnerApplicationID as partner_application_id,
                          OrgName as partner_name, 
                          OrgCountry as country, 
                          OrgEmail as email, 
                          MissionDesc as description, 
                          CAST(CreatedDate AS DATE) as joined_date 
                          FROM PartnerApplication
                          WHERE STATUS = 'NEW'",

      'countries'   =>  "SELECT 
                          LTRIM(RTRIM(Abbreviation)) AS value, 
                          Name AS label,
                          Currency as currency
                          FROM Country
                          ORDER BY label ASC",

      'currencies'  =>  'SELECT
                          LTRIM(RTRIM(Code)) AS value, 
                          Description AS label 
                          FROM Currency
                          ORDER BY label ASC',
    ];

    // map query results to field values
    foreach ($queries as $key => $value) {
      $fields[$key] = $pdo->query($value)->fetchAll(PDO::FETCH_ASSOC);
    }

    return $fields;
  }

  public static function validate(PDO $pdo, array $parameters) {
    $required_keys = array_keys(self::PARTNER_PARAMETERS);
    $errors = [];

    foreach($required_keys as $key) {
      if (!array_key_exists($key, $parameters)) {
        array_push($errors, ['ERROR' => "Parameter [$key] not found."]);
      }
    }

    $stmt = $pdo->prepare("SELECT * FROM Partner WHERE Name = :partner_name OR SponsorCode = :sponsor_code");
    $stmt->bindParam(':partner_name', $parameters['partner_name']);
    $stmt->bindParam(':sponsor_code', $parameters['sponsor_code']);

    if ($stmt->execute()) {
      if (!empty($stmt->fetch())) {
        array_push($errors, ['ERROR' => 'A partner with the same name or sponsor code already exists in the database. No changes have been made.']);
      }
    }

    // check for funding organization
    if ($parameters['is_funding_organization'] === 'true')
      $errors = FundingOrganizationManager::validate($pdo, [
        'sponsor_code'              => $parameters['sponsor_code'],
        'member_type'               => 'Partner',
        'organization_name'         => $parameters['partner_name'],
        'organization_abbreviation' => $parameters['sponsor_code'],
        'organization_type'         => $parameters['organization_type'],
        'is_annualized'             => $parameters['is_annualized'],
        'country'                   => $parameters['country'],
        'currency'                  => $parameters['currency'],
        'note'                      => $parameters['note'],
      ]);

    return $errors;
  }

  public static function addPartner(PDO $pdo, array $parameters) {
    $validation_errors = self::validate($pdo, $parameters);

    if (!empty($validation_errors)) {
      return $validation_errors;
    }
    
    try {

      $stmt = PDOBuilder::createPreparedStatement(
        $pdo, 
        "INSERT INTO Partner (
          Name,
          JoinedDate,
          Country,
          Email,
          Description,
          SponsorCode,
          Website,
          MapCoords,
          LogoFile,
          Note,
          IsDSASigned
        ) VALUES (
          :partner_name, 
          :joined_date,
          :country,
          :email,
          :description,
          :sponsor_code,
          :website,
          :map_coordinates,
          :logo_file,
          :note,
          :agree_to_terms
        )",
      $parameters);

      if ($stmt->execute()) {
        self::markApplicationAsDone($pdo, $parameters['partner_application_id']);
        $currency = $parameters['currency'] ? $parameters['currency'] : 'USD';
        
        if ($parameters['is_funding_organization'] === 'true')
          FundingOrganizationManager::addFundingOrganization($pdo, [
            'organization_name'         => $parameters['partner_name'],
            'organization_abbreviation' => $parameters['sponsor_code'],
            'organization_type'         => $parameters['organization_type'],
            'map_coordinates'           => $parameters['map_coordinates'],
            'country'                   => $parameters['country'],
            'currency'                  => $currency,
            'sponsor_code'              => $parameters['sponsor_code'],
            'member_type'               => 'Partner',
            'is_annualized'             => $parameters['is_annualized'],
            'note'                      => $parameters['note'],
          ]);
          
        return [
          ['SUCCESS' => 'The partner has been added to the database.']
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

  private static function markApplicationAsDone($pdo, $partner_application_id) {

    try {
      $stmt = PDOBuilder::createPreparedStatement(
        $pdo,     
        "UPDATE PartnerApplication
          SET STATUS = 'COMPLETED'
          WHERE PartnerApplicationID = :partner_application_id",
        [
          'partner_application_id' => $partner_application_id,
        ]
      );

      if ($stmt->execute())
        return true;
    }

    catch (Exception $e) {
      return false;
    }
  }
}

