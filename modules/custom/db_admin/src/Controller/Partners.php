<?php

namespace Drupal\db_admin\Controller;
use PDO;

class Partners {

  public static function getFields(PDO $pdo) {
    return [
      'partnerApplications' => $pdo->query(
          "SELECT
            partnerApplicationID,
            orgName as name,
            orgCountry as country,
            orgEmail as email,
            missionDesc as description,
            incomeBand as applicationIncomeBand
          FROM PartnerApplication where status = 'NEW'
          ORDER BY name"
        )->fetchAll(),

      'partners' => $pdo->query(
        'EXECUTE GetPartners'
        )->fetchAll(),

      'nonPartners' => $pdo->query(
        'EXECUTE GetNonPartners'
        )->fetchAll(),

      'countries' => $pdo->query(
          'SELECT
              RTRIM(abbreviation) as abbreviation,
              name,
              currency,
              incomeBand
              FROM Country
              ORDER BY name'
        )->fetchAll(),

      'incomeBands' => [
        ['value' => 'H', 'label' => 'High Income'],
        ['value' => 'MU', 'label' => 'Upper Middle Income'],
        ['value' => 'ML', 'label' => 'Lower Middle Income'],
        ['value' => 'L', 'label' => 'Low Income'],
      ],

      'currencies' =>
        $pdo->query(
          'SELECT
            code,
            description
          FROM Currency
          ORDER BY code'
        )->fetchAll(),
    ];
  }

  public static function add(PDO $pdo, array $parameters) {

    $partnerId = PDOBuilder::executePreparedStatement(
      $pdo,
      "DECLARE @partnerId INT;
      EXECUTE AddPartner
        @Name = :name,
        @Description = :description,
        @SponsorCode = :sponsorCode,
        @Email = :email,
        @IsDSASigned = :isDsaSigned,
        @Country = :country,
        @ApplicationIncomeBand = :applicationIncomeBand,
        @Website = :website,
        @LogoFile = :logoFile,
        @Note = :note,
        @JoinedDate = :joinedDate,
        @Longitude = :longitude,
        @Latitude = :latitude,
        @Status = :status,
        @PartnerID = @partnerId OUTPUT;
      SELECT @partnerId;",
      $parameters
    )->fetchColumn();

    PDOBuilder::executePreparedStatement(
      $pdo,
      "UPDATE PartnerApplication
        SET STATUS = 'COMPLETED'
        WHERE PartnerApplicationID = :partnerApplicationId",
      $parameters
    );

    if ($parameters['isFundingOrganization']) {
      FundingOrganizations::add(
        $pdo,
        array_merge($parameters, [
          'partnerId' => $partnerId,
          'memberType' => 'Partner',
          'memberStatus' => 'Current',
          'isDataCompletenessExcluded' => false,
          'abbreviation' => $parameters['sponsorCode'],
        ])
      );
    }
  }

  public static function update(PDO $pdo, array $parameters) {
    return PDOBuilder::createPreparedStatement(
      $pdo,
      "EXECUTE UpdatePartner
        @PartnerID = :partnerId,
        @Name = :name,
        @Description = :description,
        @SponsorCode = :sponsorCode,
        @Email = :email,
        @IsDSASigned = :isDsaSigned,
        @Country = :country,
        @Website = :website,
        @LogoFile = :logoFile,
        @Note = :note,
        @JoinedDate = :joinedDate,
        @Longitude = :longitude,
        @Latitude = :latitude,
        @Status = :status",
      $parameters
    )->execute();
  }
}
