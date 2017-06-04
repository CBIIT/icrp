<?php

require __DIR__ . '/Header.php';
$spreadsheet = require __DIR__ . '/templates/sampleSpreadsheet.php';

$filename = $helper->getFilename(__FILE__, 'xls');
$writer = \PhpOffice\PhpSpreadsheet\IOFactory::createWriter($spreadsheet, 'Excel5');

$callStartTime = microtime(true);
$writer->save($filename);
$helper->logWrite($writer, $filename, $callStartTime);
