<?php

namespace Drupal\icrp_partners\Controller;

use Box\Spout\Writer\WriterFactory;
use Box\Spout\Common\Type;
use Box\Spout\Writer\Style\StyleBuilder;

class ExcelBuilder {
  public static function export(string $filename, array $sheets = null) {
    if ($sheets)
        return function() use ($filename, $sheets) {
            $writer = WriterFactory::create(Type::XLSX);
            $writer->openToBrowser($filename);
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
        };
    }

    /**
     * Sample array of queries:
     * [[
     *      'title' => 'Sheet A',
     *      'query' => 'Select * from table',
     *      'columns' => [
     *          'A' => 'Mapped Column Name A'
     *          'B' => 'Mapped Column Name B'
     *      ];
     * ]]
     *
     *
     */
    public static function exportQueries(PDO $pdo, array $queries, string $filename) {


    }
}