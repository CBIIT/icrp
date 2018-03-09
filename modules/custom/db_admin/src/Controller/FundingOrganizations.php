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
              FROM Country'
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

  public static function add(PDO $pdo, array $parameters): boolean {
    return $pdo->prepare(
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
        @Longitude = :longitude"
      )->execute($parameters);
  }

  public static function update(PDO $pdo, array $parameters): boolean {
    return $pdo->prepare(
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
        @Longitude = :longitude"
    )->execute($parameters);
  }
}
