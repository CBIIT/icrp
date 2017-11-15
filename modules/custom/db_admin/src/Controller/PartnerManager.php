<?php

namespace Drupal\db_admin\Controller;
use Drupal\db_admin\Helpers\PDOBuilder;
use Symfony\Component\HttpFoundation\JsonResponse;
use PDO;
use PDOException;

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
    'latitude'                  => NULL,
    'longitude'                 => NULL,
  ];

  const PARTNER_PARAMETERS = [
    'partner_name'              => NULL,
    'joined_date'               => NULL,
    'country'                   => NULL,
    'email'                     => NULL,
    'description'               => NULL,
    'sponsor_code'              => NULL,
    'website'                   => NULL,
    'latitude'                  => NULL,
    'longitude'                 => NULL,
    'logo_file'                 => NULL,
    'note'                      => NULL,
    'agree_to_terms'            => NULL,
    'is_funding_organization'   => NULL,
    'organization_type'         => NULL,
    'is_annualized'             => NULL,
    'currency'                  => NULL,
  ];

  public static function getFields(PDO $pdo, bool $isNew) {
    $queries = [
      'partners'    =>  null,
      'countries'   =>  'SELECT
                          LTRIM(RTRIM(Abbreviation)) AS value,
                          Name AS label,
                          Currency as currency
                          FROM Country
                          ORDER BY label ASC',

      'currencies'  =>  'SELECT
                          LTRIM(RTRIM(Code)) AS value,
                          Description AS label
                          FROM Currency
                          ORDER BY value ASC',
    ];
    if ($isNew) {
      $queries['partners'] = "SELECT
        PartnerApplicationID as partner_application_id,
        OrgName as partner_name,
        OrgCountry as country,
        OrgEmail as email,
        MissionDesc as description,
        CAST(CreatedDate AS DATE) as joined_date,
        '' as sponsor_code,
        'http://' as website,
        '' as latitude,
        '' as longitude,
        '' as logo_file,
        '' as note,
        0 as agree_to_terms
        FROM PartnerApplication
        WHERE STATUS = 'NEW'";
    } else {
      $queries['partners'] = "SELECT
        PartnerID as partner_application_id,
        Name as partner_name,
        ISNULL(Country,'') as country,
        ISNULL(Email,'') as email,
        Description as description,
        CAST(JoinedDate AS DATE) as joined_date,
        SponsorCode as sponsor_code,
        ISNULL(Website,'http://') as website,
        Latitude as latitude,
        Longitude as longitude,
        LogoFile as logo_file,
        ISNULL(Note,'') as note,
        ISNULL(IsDSASigned,0) as agree_to_terms
        FROM Partner";
  }

    // map query results to field values
    $fields = [];
    foreach ($queries as $key => $value) {
      $fields[$key] = $pdo->query($value)->fetchAll(PDO::FETCH_ASSOC);
    }

    $getValueLabelPair = function ($str) {
      return [
        'value' => $str,
        'label' => $str,
      ];
    };

    $fields['organizationTypes'] = array_map($getValueLabelPair, [
      'Government',
      'Non-profit',
      'Other'
    ]);

    $fields['urlProtocols'] = array_map($getValueLabelPair, [
      'https://',
      'http://',
    ]);

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

    if ($parameters['operation_type'] == 'new' && $stmt->execute()) {
      if (!empty($stmt->fetch())) {
        array_push($errors, ['ERROR' => 'A partner with the same name or sponsor code already exists in the database. No changes have been made.']);
      }
    }

    // check for funding organization
    if ($parameters['is_funding_organization'] === 'true') {
      $errors += FundingOrganizationManager::validate($pdo, [
        'partner_id'                => null,
        'sponsor_code'              => $parameters['sponsor_code'],
        'member_type'               => 'Partner',
        'member_status'             => null,
        'organization_name'         => $parameters['partner_name'],
        'organization_abbreviation' => $parameters['sponsor_code'],
        'organization_type'         => $parameters['organization_type'],
        'is_annualized'             => $parameters['is_annualized'],
        'country'                   => $parameters['country'],
        'currency'                  => $parameters['currency'],
        'note'                      => $parameters['note'],
        'website'                   => $parameters['website'],
        'latitude'                  => $parameters['latitude'],
        'longitude'                 => $parameters['longitude'],
      ]);
    }

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
        "EXECUTE AddPartner
          :partner_name,
          :description,
          :sponsor_code,
          :email,
          :agree_to_terms,
          :country,
          :website,
          :logo_file,
          :note,
          :joined_date,
          :longitude,
          :latitude;
        SELECT @@IDENTITY AS partner_id;",
        $parameters);

        if ($stmt->execute()) {
          $row = $stmt->fetch(PDO::FETCH_ASSOC);
          $parameters['partner_id'] = $row['partner_id'];
          
          self::markApplicationAsDone($pdo, $parameters['partner_application_id']);

          $returnValues = [
            ['SUCCESS' => 'The partner has been added to the database.']
          ];
          if ($parameters['is_funding_organization'] === 'true') {
            $returnValues = array_merge($returnValues, FundingOrganizationManager::addFundingOrganization($pdo, [
              'partner_id'                => $parameters['partner_id'],
              'organization_name'         => $parameters['partner_name'],
              'organization_abbreviation' => $parameters['sponsor_code'],
              'organization_type'         => $parameters['organization_type'],
              'country'                   => $parameters['country'],
              'currency'                  => $parameters['currency'],
              'member_type'               => 'Partner',
              'member_status'             => null,
              'is_annualized'             => $parameters['is_annualized'],
              'note'                      => $parameters['note'],
              'website'                   => $parameters['website'],
              'latitude'                  => $parameters['latitude'],
              'longitude'                 => $parameters['longitude']
            ]));
          }

        return $returnValues;
      }
    }

    catch (PDOException $e) {
      $errorMessage = $e->getMessage();
      $errorMessage = preg_replace('/^SQLSTATE\[\d+\]: ?(\[[^\]]*\])*/','',$errorMessage);
      return [
        ['ERROR' => $errorMessage]
      ];
    }

    catch (Exception $e) {
      return [
        ['ERROR' => $e->getMessage()]
      ];
    }

    return [false];
  }

  public static function updatePartner(PDO $pdo, array $parameters) {
    $validation_errors = self::validate($pdo, $parameters);
    
    if (!empty($validation_errors)) {
      return $validation_errors;
    }

    try {

      $stmt = PDOBuilder::createPreparedStatement(
        $pdo,
        "EXECUTE UpdatePartner
          :partner_application_id,
          :partner_name,
          :description,
          :sponsor_code,
          :email,
          :agree_to_terms,
          :country,
          :website,
          :logo_file,
          :note,
          :joined_date,
          :latitude,
          :longitude",
      $parameters);

      if ($stmt->execute()) {
        return [
          ['SUCCESS' => 'The partner has been updated in the database.']
        ];
      }
    }

    catch (PDOException $e) {
      $errorMessage = $e->getMessage();
      $errorMessage = preg_replace('/^SQLSTATE\[\d+\]: ?(\[[^\]]*\])*/','',$errorMessage);
      return [
        ['ERROR' => $errorMessage]
      ];
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

