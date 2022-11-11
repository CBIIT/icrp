<?php

namespace Drupal\db_export_results\Controller;

use Drupal;
use PDO;
use PhpOffice\PhpSpreadsheet\IOFactory;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;


class ExcelBuilder
{
    public static function export(string $filename, array $sheets = null)
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
    public static function exportQueries(string $filename, array $sheets)
    {
        if (!$sheets)
            return;
        $time = -microtime(TRUE);
        $spreadsheet = new Spreadsheet();
        $worksheet = $spreadsheet->getActiveSheet();

        foreach ($sheets as $index => $sheet) {

            $title = substr($sheet['title'], 0, 31);
            $query = $sheet['query'];
            $columns = $sheet['columns'] ?? [];
            $data = [];
            $query->execute();

            if (empty($columns)) {

                foreach (range(0, $query->columnCount() - 1) as $i) {
                    $meta = $query->getColumnMeta($i);
                    $columns[] = $meta['name'];
                }
                $data[] = $columns;

                while ($row = $query->fetch(PDO::FETCH_NUM)) {
                    $data[] = $row;
                }
            } else {
                $headers = array_map(
                    function ($column) {
                        return is_array($column)
                            ? $column['name']
                            : $column;
                    },
                    array_values($columns)
                );

                $data[] = $headers;
                $columnDefs = array_keys($columns);

                foreach ($query as $row) {
                    $rowValues = [];
                    foreach ($columns as $columnKey => $columnDef) {
                        if (is_array($columnDef)) {
                            $formatter = $columnDef['formatter'];
                            $rowValues[] = $formatter($row[$columnKey], $row);
                        } else {
                            $rowValues[] = $row[$columnKey];
                        }
                    }

                    $data[] = $rowValues;
                }
            }

            $worksheet->setTitle($title);
            $worksheet->fromArray($data);

            if ($index < count($sheets) - 1) {
                $worksheet = $spreadsheet->createSheet();
            }
        }

        $time += microtime(TRUE);
        error_log("$filename created in $time seconds");

        $writer = IOFactory::createWriter($spreadsheet, 'Xlsx');
        header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        header('Content-Disposition: attachment;filename="' . $filename);
        $writer->save('php://output');
    }
}