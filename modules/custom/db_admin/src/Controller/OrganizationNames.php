<?php

namespace Drupal\db_admin\Controller;
use PDO;

class OrganizationNames {

  public static function getFields(PDO $pdo) {
    return [
      'fundingOrganizations' => $pdo->query(
          'EXECUTE GetFundingOrgs'
        )->fetchAll(),

      'partners' => $pdo->query(
        'EXECUTE GetPartners'
        )->fetchAll(),
    ];
  }

  public static function updateFundingOrganizationName(PDO $pdo, array $parameters): bool {
    return PDOBuilder::createPreparedStatement(
      $pdo,
      "EXECUTE UpdateFundingOrgName
        @FundingOrgID = :fundingOrgId,
        @Name = :name,
        @Abbreviation :abbreviation"
      $parameters)->execute();
  }

  public static function updatePartnerName(PDO $pdo, array $parameters): bool {
    return PDOBuilder::createPreparedStatement(
      $pdo,
      "EXECUTE UpdatePartnerName
        @PartnerID = :partnerId,
        @Name = :name,
        @SponsorCode  :sponsorCode"
      $parameters)->execute();
  }
}
