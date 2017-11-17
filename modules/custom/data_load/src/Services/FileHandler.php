<?php

namespace Drupal\data_load\Services;

use Drupal;
use PDO;
use SplFileInfo;

class FileHandler {

    /**
     * Returns the absolute path to the modules folder
     *
     * @return string
     */
    public static function getModulePath(): string {
        // get the relative path of this module
        $relativePath = str_replace('/', DIRECTORY_SEPARATOR, drupal_get_path('module', 'data_load'));

        // get the absolute path to the module folder
        return join(DIRECTORY_SEPARATOR, [getcwd(), $relativePath]);
    }

    /**
     * Moves an uploaded file to the /db_load/uploads/ directory
     *
     * @param SplFileInfo $file
     * @return string - The absolute path to the uploaded file
     */
    public static function moveUploadedFile(SplFileInfo $file): string {
        // get the absolute path to the uploads folder
        $uploadsFolder = join(DIRECTORY_SEPARATOR, [self::getModulePath(), 'uploads']);

        // ensure the uploads folder exists
        if (!file_exists($uploadsFolder)) {
            mkdir($uploadsFolder, 0744, true);
        }

        // ensure that files with the same names but different
        // contents do not overwrite each other
        $fileName = sha1_file($file->getRealPath());

        // attempt to move file to uploads folder
        $file = move_uploaded_file(
          $file->getFilename(),
          join(DIRECTORY_SEPARATOR, [$uploadsFolder, $fileName])
        );

        // returns the absolute path to the file
        return $file->getRealPath();
    }


    /**
     * Converts a file from UTF-16 to UTF-8
     * Requires the iconv binary to be in the system path
     *
     * @todo To avoid bash injection, ensure the filePath has been sanitized
     * @param string $filePath The path to the input file
     * @return void
     */
    public static function convertFile(
      string $filePath,
      string $fromEncoding = 'UTF-16',
      string $toEncoding = 'UTF-8'): void {

        // escape shell arguments to prevent injection
        $filePath = escapeshellarg($filePath);
        $outputFilePath = escapeshellarg("${filePath}.utf8");
        $fromEncoding = escapeshellarg($fromEncoding);
        $toEncoding = escapeshellarg($toEncoding);

        // generate a file with the proper encoding
        exec("iconv -f $fromEncoding -t $toEncoding $filePath -o $outputFilePath");

        // remove original file
        unlink($filePath);

        // rename generated file to replace original
        rename($outputFilePath, $filePath);

        // exec("sed -i 's/\r/|\r/g' " . $filePath);
    }
}