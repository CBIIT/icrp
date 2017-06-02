<?php

require __DIR__ . '/Header.php';

$helper->log('Load MergeBook1 from Excel2007 file');
$filename1 = __DIR__ . '/templates/43mergeBook1.xlsx';
$callStartTime = microtime(true);
$spreadsheet1 = \PhpOffice\PhpSpreadsheet\IOFactory::load($filename1);
$helper->logRead('Excel2007', $filename1, $callStartTime);

$helper->log('Load MergeBook2 from Excel2007 file');
$filename2 = __DIR__ . '/templates/43mergeBook2.xlsx';
$callStartTime = microtime(true);
$spreadsheet2 = \PhpOffice\PhpSpreadsheet\IOFactory::load($filename2);
$helper->logRead('Excel2007', $filename2, $callStartTime);

foreach ($spreadsheet2->getSheetNames() as $sheetName) {
    $sheet = $spreadsheet2->getSheetByName($sheetName);
    $sheet->setTitle($sheet->getTitle() . ' copied');
    $spreadsheet1->addExternalSheet($sheet);
}

// Save
$helper->write($spreadsheet1, __FILE__);
