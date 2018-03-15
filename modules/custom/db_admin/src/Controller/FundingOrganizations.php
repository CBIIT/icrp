<?php

namespace Drupal\db_admin\Controller;
use PDO;

class FundingOrganizations {

  public static function getFields(PDO $pdo) {
    return [
      'fundingOrganizations' => $pdo->query(
          'EXECUTE GetFundingOrgs'
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
          FROM Currency
          ORDER BY code'
        )->fetchAll(),
    ];
  }

  public static function add(PDO $pdo, array $parameters): bool {
    return PDOBuilder::createPreparedStatement(
      $pdo,
      "EXECUTE AddFundingOrg
        @PartnerID = :partnerId,
        @Name = :name,
        @Abbreviation = :abbreviation,
        @Type = :type,
        @Country = :country,
        @Currency = :currency,
        @MemberType = :memberType,
        @MemberStatus = :memberStatus,
        @IsAnnualized = :isAnnualized,
        @Note = :note,
        @Website = :website,
        @Latitude = :latitude,
        @Longitude = :longitude",
      $parameters)->execute();
  }

  public static function update(PDO $pdo, array $parameters): bool {
    return PDOBuilder::createPreparedStatement(
      $pdo,
      "EXECUTE UpdateFundingOrg
        @FundingOrgId = :fundingOrganizationId,
        @Name = :name,
        @Abbreviation = :abbreviation,
        @Type = :type,
        @Country = :country,
        @Currency = :currency,
        @MemberType = :memberType,
        @MemberStatus = :memberStatus,
        @IsAnnualized = :isAnnualized,
        @Note = :note,
        @Website = :website,
        @Latitude = :latitude,
        @Longitude = :longitude",
    $parameters)->execute();
  }
}
