<?php

namespace Drupal\data_load\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
use Drupal\Core\Controller\ControllerBase;
use Drupal\data_load\Services\ExcelBuilder;

class ExportController extends ControllerBase {

  /**
   * Creates an arbitrary excel report based on the supplied json object.
   *
   * For example:
   * [
   *    {title: 'Sheet one', rows: ['A', 'B', 'C']},
   *    {title: 'Sheet two', rows: ['D', 'E', 'F']},
   * ];
   *
   * @param Request $request Contains a json body that will be converted to an excel document
   * @return JSONResponse
   */
  public static function getExcelExport(Request $request, string $prefix = 'Data_Export'): JSONResponse {
    $sheets = json_decode($request->getContent(), true);
    $filename = sprintf("%s_%s.xlsx", $prefix, uniqid());
    $uri = ExcelBuilder::create($filename, $sheets);
    return self::createResponse($uri);
  }

}