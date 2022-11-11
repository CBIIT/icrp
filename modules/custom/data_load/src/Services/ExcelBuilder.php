<?php

namespace Drupal\data_load\Services;

use Drupal;
use PhpOffice\PhpSpreadsheet\IOFactory;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

class ExcelBuilder {
  public static function create(string $filename, array $sheets = null)
  {
      $exportsFolder = Drupal::config('icrp-tmp')->get('exports') ?? 'data/tmp/exports';

      if (!file_exists($exportsFolder))
          mkdir($exportsFolder, 0744, true);

      $filePath = "$exportsFolder/$filename";

      if ($sheets) {
          $spreadsheet = new Spreadsheet();
          $worksheet = $spreadsheet->getActiveSheet();

          // write sheet data to each sheet
          foreach ($sheets as $index => $sheetData) {
              $title = substr($sheetData['title'], 0, 31);
              $data = $sheetData['rows'];

              $worksheet->setTitle($title);
              $worksheet->fromArray($data);

              if ($index < count($sheets) - 1) {
                  $worksheet = $spreadsheet->createSheet();
              }
          }

          $xlsx = new Xlsx($spreadsheet);
          $xlsx->save($filePath);
          return $filePath;
      }
      return ['ERROR' => 'No data specified.'];
  }  
}
