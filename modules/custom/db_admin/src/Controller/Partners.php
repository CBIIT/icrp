<?php

namespace Drupal\db_admin\Controller;
use PDO;

class Partners {

  public static function getFields(PDO $pdo) {
    return [
      'partnerApplications' => $pdo->query(
          "SELECT * FROM PartnerApplication where status = 'NEW'"
        )->fetchAll(),

      'partners' => $pdo->query(
        'EXECUTE GetPartners'
        )->fetchAll(),

      'countries' => $pdo->query(
          'SELECT
              RTRIM(abbreviation) as abbreviation,
              name,
              currency
              FROM Country
              ORDER BY name'
        )->fetchAll(),

      'currencies' =>
        $pdo->query(
          'SELECT
            code,
            description
          FROM Currency'
        )->fetchAll(),
    ];
  }

  public static function add(PDO $pdo, array $parameters) {
    $partnerId = PDOBuilder::executePreparedStatement(
      $pdo,
      "EXECUTE AddPartner
        @Name = :name
        @Description = :description
        @SponsorCode = :sponsorCode
        @Email = :email
        @IsDSASigned = :isDSASigned
        @Country = :country
        @Website = :website
        @LogoFile = :logoFile
        @Note = :note
        @JoinedDate = :joinedDate
        @Longitude = :longitude
        @Latitude = :latitude
        @Status = :status;
      SELECT @@IDENTITY;",
      $parameters
    )->fetch(PDO::FETCH_COLUMN);

    if ($parameters['isFundingOrganization']) {
      FundingOrganizations::add(
        $pdo,
        $parameters + [
          'partnerId' => $partnerId,
          'memberType' => 'Partner',
          'memberStatus' => 'Current',
        ]
      );
    }

    PDOBuilder::executePreparedStatement(
      $pdo,
      "UPDATE PartnerApplication
        SET STATUS = 'COMPLETED'
        WHERE PartnerApplicationID = :partnerApplicationId",
      $parameters
    );
  }

  public static function update(PDO $pdo, array $parameters) {
    return $pdo->prepare(
      "EXECUTE UpdatePartner
        @PartnerID = :partnerID
        @Name = :name
        @Description = :description
        @SponsorCode = :sponsorCode
        @Email = :email
        @IsDSASigned = :isDSASigned
        @Country = :country
        @Website = :website
        @LogoFile = :logoFile
        @Note = :note
        @JoinedDate = :joinedDate
        @Longitude = :longitude
        @Latitude = :latitude
        @Status = :status"
    )->execute();
  }
}
