<?php

/**
 * @file
 * Contains \Drupal\db_export_results\Controller\DatabaseExportController
 */

namespace Drupal\db_export_results\Controller;

use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\BinaryFileResponse;
use Symfony\Component\HttpFoundation\ResponseHeaderBag;
use PDO;

class DatabaseExportController extends ControllerBase {

  public static function createPath($components) {
    return join(DIRECTORY_SEPARATOR, $components);
  }

  function __construct() {

    // get the relative path of this module
    $module_path = drupal_get_path('module', 'db_export_results');

    // set the output directory
    $this->output_directory = join('/', [$module_path, 'output']);

    // create the output directory if it does not exist
    if (!file_exists($this->output_directory)) {
      mkdir($this->output_directory);
    }
  }

  function __destruct() {
      // clear the contents of the output directory and delete it
      if (file_exists($this->output_directory)) {
//        array_map('unlink', glob($this->output_directory . '/*'));
//        rmdir($this->output_directory);
      }
  }

  function getAbsolutePath($path) {
    $system_path = join(
      DIRECTORY_SEPARATOR,
      explode('/', $path)
    );

    return join(
      DIRECTORY_SEPARATOR,
      [getcwd(), $system_path]
    );
  }



  function exportSearchResults(Request $request) {
    $filename = 'file.bag';
    $filepath = join('/', [$this->output_directory, $filename]);
    $absolute_filepath = self::getAbsolutePath($filepath);
    $uri = join('/', [$request->getHost(), $filepath]);

    $file = fopen($absolute_filepath, 'w');
    fwrite($file, 'Response!');
    fclose($file);

    return new Response($uri);
  }
}
