<?php

namespace Drupal\db_admin\Controller;
use PDO;

class OrganizationNames {

  public static function compareByKey($key) {
    return function($a, $b) use ($key) {
      return strcmp($a[$key], $b[$key]);
    };
  }

  public static function getFields(PDO $pdo) {
    $fundingOrganizations = $pdo->query(
      'EXECUTE GetFundingOrgs'
    )->fetchAll();

    $partners = $pdo->query(
      'EXECUTE GetPartners'
    )->fetchAll();

    usort($fundingOrganizations, self::compareByKey('name'));
    usort($partners, self::compareByKey('name'));

    return [
      'fundingOrganizations' => $fundingOrganizations,
      'partners' => $partners,
    ];
  }

  public static function updateFundingOrganizationName(PDO $pdo, array $parameters) {
    error_log(json_encode($parameters));
    $stmt = $pdo->prepare(
      "EXECUTE UpdateFundingOrgName
        @FundingOrgID = :fundingOrgId,
        @Name = :name,
        @Abbreviation = :abbreviation",
    );
    $stmt->bindValue(':fundingOrgId', $parameters['fundingOrgId']);
    $stmt->bindValue(':name', $parameters['name']);
    $stmt->bindValue(':abbreviation', $parameters['abbreviation']);
    return $stmt->execute();
  }

  public static function updatePartnerName(PDO $pdo, array $parameters) {
    $stmt = $pdo->prepare(
      "EXECUTE UpdatePartnerOrgName
        @PartnerID = :partnerId,
        @Name = :name,
        @SponsorCode = :sponsorCode",
    );
    $stmt->bindValue(':partnerId', $parameters['partnerId']);
    $stmt->bindValue(':name', $parameters['name']);
    $stmt->bindValue(':sponsorCode', $parameters['sponsorCode']);
    return $stmt->execute();
  }
}
