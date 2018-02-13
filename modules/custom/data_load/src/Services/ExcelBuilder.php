<?php

namespace Drupal\data_load\Services;

use Box\Spout\Writer\WriterFactory;
use Box\Spout\Common\Type;
use Box\Spout\Writer\Style\StyleBuilder;

class ExcelBuilder {
  public static function create(string $filename, array $sheets = null) {

    $exportsFolder = \Drupal::config('exports')->get('data_load') ?? 'data/exports/data_load';

    if (!file_exists($exportsFolder))
      mkdir($exportsFolder, 0744, true);

    $filePath = "$exportsFolder/$filename";

    if ($sheets) {
      $writer = WriterFactory::create(Type::XLSX);
      $writer->openToFile($filePath);
      $writer->setDefaultRowStyle(
        (new StyleBuilder())
          ->setShouldWrapText(false)
          ->build()
      );

      // write sheet data to each sheet
      foreach ($sheets as $index => $sheet) {
        $title = substr($sheet['title'], 0, 31);
        $writer->getCurrentSheet()->setName($title);
        $writer->addRows($sheet['rows']);

        if ($index < count($sheets) - 1)
          $writer->addNewSheetAndMakeItCurrent();
      }

      $writer->close();
      return $filePath;
    }
    return ['ERROR' => 'No data specified.'];
  }
}