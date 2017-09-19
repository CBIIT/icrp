<?php

namespace Drupal\db_map\Controller;

require_once __DIR__ . '/../../vendor/autoload.php';

use Box\Spout\Writer\WriterFactory;
use Box\Spout\Common\Type;
use Box\Spout\Writer\Style\StyleBuilder;

class ExcelBuilder {
  public static function create(string $filename, array $sheets = null) {
    $filePath = drupal_get_path('module', 'db_map') . "/output/$filename";
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