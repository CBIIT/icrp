<?php

namespace Drupal\db_admin\Controller;
use Drupal\db_admin\Helpers\PDOBuilder;
use PDO;

class FundingOrganizationManager {

  public static function getFields(PDO $pdo) {
    $fields = [];
    $queries = [
      'partners'    =>  'SELECT p.SponsorCode AS value, p.Name AS label, p.Country AS country, c.Currency AS currency FROM Partner p
                          LEFT JOIN Country c ON p.Country = c.Abbreviation
                          ORDER BY label ASC',
      'countries'   =>  'SELECT Abbreviation AS value, name AS label, Currency AS currency FROM icrp_data.dbo.Country
                          ORDER BY label ASC',
      'currencies'  =>  'SELECT Code AS value, Description AS label FROM Currency
                          ORDER BY label ASC',
    ];

    // map query results to field values
    foreach ($queries as $key => $value) {
      $fields[$key] = $pdo->query($value)->fetchAll(PDO::FETCH_ASSOC);
    }

    return $fields;
  }

  public static function addFundingOrganization(PDO $pdo, array $parameters) {
    return [];
  }
}