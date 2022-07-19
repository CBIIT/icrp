<?php

/**
 * @file
 * Contains \Drupal\icrp_data_tables\Controller\PageController.
 */

namespace Drupal\icrp_data_tables\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
use Drupal\Core\Controller\ControllerBase;
use PDO;

class PageController extends ControllerBase {

    function uploadCompleteness(): array {

        \Drupal::service('page_cache_kill_switch')->trigger();

        $rows = $this->getConnection()
            ->query('SET NOCOUNT ON; EXECUTE GetDataUploadCompletenessDetails')
            ->fetchAll();

        $years = array_unique(array_column($rows, 'year'));
        rsort($years);

        $columns = array_merge([
            [
                'key' => 'abbreviation',
                'label' => 'Funding Organization',
            ],

            [
                'key' => 'sponsorCode',
                'label' => 'Sponsor Code',
            ],
        ], array_map(function($value) {
            return [
                'key' => $value,
                'label' => $value
            ];
        }, $years));

        $records = [];
        $previousId = null;
        foreach ($rows as $row) {
            $currentId = $row['fundingorgid'];
            if ($currentId != $previousId) {
                $records[] = [
                    'id' => $row['fundingorgid'],
                    'sponsorCode' => $row['sponsorcode'],
                    'abbreviation' => $row['fundingorgabbrev'],
                    'name' => $row['fundingorgname'],
                ];
                $previousId = $currentId;
            }

            $last = &$records[count($records) - 1];
            $last[$row['year']] = $row['status'];
        }

        return [
            '#theme' => 'upload_completeness',
            '#records' => $records,
            '#columns' => $columns,
            '#base_path' => '/' . drupal_get_path('module', 'icrp_data_tables'),
            '#attached' => [
                'library' => [
                    'icrp_data_tables/default'
                ],
                'drupalSettings' => [
                    'basePath' => '/' . drupal_get_path('module', 'icrp_data_tables'),
                    'isManager' => in_array('manager', \Drupal::currentUser()->getRoles()),
                    'fundingOrganizations' => $records,
                ],
            ],
        ];
    }

    public function updateUploadCompleteness(Request $request): JsonResponse {
        try {
            $parameters = json_decode($request->getContent(), true);
            return new JsonResponse(
                $this->getConnection()->prepare(
                    'EXECUTE UpdateDataUploadCompleteness
                        @FundingOrgId = :fundingOrgId,
                        @CompletedYears = :completedYears,
                        @PartialUploadYears = :partialUploadYears,
                        @DataNotAvailable = :dataNotAvailableYears;'
                )->execute($parameters)
            );
        } catch (\Exception $e) {
            $message = preg_replace('/^SQLSTATE\[.*\]/', '', $e->getMessage());
            return new JsonResponse($message, 500);
        }
    }

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

    function redirectToUploadStatus() {
        return $this->redirect('uploadStatus');
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

    static function getDsn($cfg): string {
        $dsn = [
          'Server' => "$cfg[host],$cfg[port]",
          'Database' => $cfg['database'],
        ];
    
        if ($cfg['options']) {
          $dsn += $cfg['options'];
        }
    
        $dsnString = join(';', array_map(
          fn($k, $v) => "$k=$v", 
          array_keys($dsn), 
          array_values($dsn)
        ));
    
        return "$cfg[driver]:$dsnString";
    }

    function getConnection(string $database = 'icrp_database') {
        $cfg = \Drupal::config($database)->get();

        $cfg['options'] = [
            PDO::SQLSRV_ATTR_ENCODING               => PDO::SQLSRV_ENCODING_UTF8,
            PDO::ATTR_ERRMODE                       => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE            => PDO::FETCH_ASSOC,
            PDO::ATTR_CASE                          => PDO::CASE_LOWER,
            PDO::SQLSRV_ATTR_FETCHES_NUMERIC_TYPE   => TRUE,
        ];

        return new PDO(
            self::getDsn($cfg),
            $cfg['username'],
            $cfg['password'],
            $cfg['options']
        );
    }
}