<?php

/**
 * @file
 * Contains \Drupal\icrp_data_tables\Controller\PageController.
 */

namespace Drupal\icrp_data_tables\Controller;

use Drupal\Core\Controller\ControllerBase;
use PDO;

class PageController extends ControllerBase {

    function uploadStatus(): array {
        $records = $this->getConnection()
            ->query('SET NOCOUNT ON; EXECUTE GetDataUploadStatus')
            ->fetchAll();

        return [
            '#theme' => 'upload_status',
            '#records' => $records,
            '#attached' => [
                'library' => [
                    'icrp_data_tables/default'
                ],
            ],
        ];
    }

    function cancerTypes(): array {
        $records = $this->getConnection()
            ->query('SET NOCOUNT ON; SELECT * FROM CancerType ORDER BY SortOrder, Name')
            ->fetchAll();

        return [
            '#theme' => 'cancer_types',
            '#records' => $records,
            '#attached' => [
                'library' => [
                    'icrp_data_tables/default'
                ],
            ],
        ];
    }

    function getConnection(string $database = 'icrp_database') {
        $cfg = \Drupal::config($database)->get();

        $cfg['dsn'] = $cfg['driver'] .
            ":Server=$cfg[host],$cfg[port]" .
            ";Database=$cfg[database]";

        $cfg['options'] = [
            PDO::SQLSRV_ATTR_ENCODING               => PDO::SQLSRV_ENCODING_UTF8,
            PDO::ATTR_ERRMODE                       => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE            => PDO::FETCH_ASSOC,
            PDO::ATTR_CASE                          => PDO::CASE_LOWER,
            PDO::SQLSRV_ATTR_FETCHES_NUMERIC_TYPE   => TRUE,
        ];

        return new PDO(
            $cfg['dsn'],
            $cfg['username'],
            $cfg['password'],
            $cfg['options']
        );
    }
}