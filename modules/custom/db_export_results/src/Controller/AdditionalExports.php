<?php

namespace Drupal\db_export_results\Controller;

use DateTime;
use PDO;
use PDOStatement;

use Box\Spout\Writer\WriterFactory;
use Box\Spout\Common\Type;
use Box\Spout\Writer\Style\StyleBuilder;

class AdditionalExports {

  public static function exportUploadStatus(PDO $pdo) {
    exportQueries(
      $pdo,
      [
        'CSO Codes'             => 'SET NOCOUNT ON; EXECUTE GetCSOLookup',
        'Disease Site Codes'    => 'SET NOCOUNT ON; EXECUTE GetCancerTypeLookUp',
        'Country Codes'         => 'SET NOCOUNT ON; EXECUTE GetCountryCodeLookup',
        'Currency Conversions'  => 'SET NOCOUNT ON; EXECUTE GetCurrencyRateLookup',
        'Institutions'          => 'SET NOCOUNT ON; EXECUTE GetInstitutionLookup',
      ],
      'UploadStatusReport.xlsx'
    );
  }

  public static function exportLookupTables(PDO $pdo) {
    exportQueries(
      $pdo,
      [
        'Data Upload Status Report' => 'SET NOCOUNT ON; EXECUTE GetDataUploadStatus'
      ],
      'LookupTables.xlsx'
    );
  }

  public static function exportQueries(PDO $pdo, string $filename) {


  }
}
