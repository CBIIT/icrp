<?php

namespace Drupal\icrp_partners\Controller;

use Box\Spout\Writer\WriterFactory;
use Box\Spout\Common\Type;
use Box\Spout\Writer\Style\StyleBuilder;

class ExcelBuilder {
  public static function create(string $filename, array $sheets = null) {
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
}