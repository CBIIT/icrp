<?php

namespace Drupal\db_export_results\Controller;

use PDO;
use Box\Spout\Writer\WriterFactory;
use Box\Spout\Common\Type;
use Box\Spout\Writer\Style\StyleBuilder;

class ExcelBuilder {
    public static function export(string $filename, array $sheets = null) {
        if(!sheets) return;
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
            $writer->addRows($sheet['rows'] ?? []);

            if ($index < count($sheets) - 1)
                $writer->addNewSheetAndMakeItCurrent();
        }

        $writer->close();
    }

    /**
     * Sample array of sheets:
     * [[
     *      'title' => 'Sheet A',
     *      'query' => PDOStatement - eg: $pdo->prepare('Select * from table'),
     *      'columns' => [ // if an empty array is provided, export all columns as-is
     *          'A' => 'Mapped Column Name A'
     *          'B' => 'Mapped Column Name B'
     *      ];
     * ]]
     *
     *
     */
    public static function exportQueries(string $filename, array $sheets) {
        if(!$sheets) return;
        $time = -microtime(TRUE);

        $writer = WriterFactory::create(Type::XLSX);
        $writer->openToBrowser($filename);
        $writer->setDefaultRowStyle(
            (new StyleBuilder())
            ->setShouldWrapText(false)
            ->build()
        );

        foreach($sheets as $index => $sheet) {

            $title = substr($sheet['title'], 0, 31);
            $writer->getCurrentSheet()->setName($title);
            $query = $sheet['query'];
            $columns = $sheet['columns'] ?? [];
            $query->execute();

            if (empty($columns)) {

                foreach(range(0, $query->columnCount() - 1) as $i) {
                    $meta = $query->getColumnMeta($i);
                    $columns[] = $meta['name'];
                }

                $writer->addRow($columns);

                while ($row = $query->fetch(PDO::FETCH_NUM)) {
                    $writer->addRow($row);
                }
            }

            else {
                $headers = array_map(function($column) {
                    return is_array($column)
                        ? $column['name']
                        : $column;
                }, array_values($columns));

                $writer->addRow($headers);
                $columnDefs = array_keys($columns);

                foreach ($query as $row) {
                    $rowValues = [];
                    foreach($columns as $columnKey => $columnDef) {
                        if (is_array($columnDef)) {
                            $formatter = $columnDef['formatter'];
                            $rowValues[] = $formatter($row[$columnKey], $row);
                        }

                        else {
                            $rowValues[] = $row[$columnKey];
                        }
                    }

                    $writer->addRow($rowValues);
                }
            }

            if ($index < count($sheets) - 1)
                $writer->addNewSheetAndMakeItCurrent();
        }

        $time += microtime(TRUE);
        error_log("$filename created in $time seconds");

        $writer->close();
    }
}