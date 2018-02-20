<?php

/**
 * @file
 * Contains \Drupal\icrp_partners\Controller\PageController.
 */

namespace Drupal\icrp_partners\Controller;

use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\StreamedResponse;
use PDO;

class PageController extends ControllerBase {
    public static function content(): array {

        $connection = PDOBuilder::getConnection();


        return [
            '#theme' => 'icrp_partners',
            '#partners' => PDOBuilder::executePreparedStatement(
                $connection,
                'GetPartners'
            )->fetchAll(),
            '#fundingOrganizations' => PDOBuilder::executePreparedStatement(
                $connection,
                'EXECUTE GetFundingOrgs @type=funding'
            )->fetchAll(),
            '#attached' => [
                'library' => [
                    'icrp_partners/content'
                ],
            ],
        ];
    }

    public static function export(): StreamedResponse {
        return new StreamedResponse(
            ExcelBuilder::create('ICRP Partners.xlsx', [
                [
                    'title' => 'ICRP Partners',
                    'rows' => [
                        ['1', '2', '3'],
                        ['a', 'b', 'c']
                    ],
                ],

                [
                    'title' => 'ICRP Funding Organizations',
                    'rows' => [
                        ['1', '2', '3'],
                        ['a', 'b', 'c']
                    ],
                ],

                [
                    'title' => 'Non-Partners',
                    'rows' => [
                        ['1', '2', '3'],
                        ['a', 'b', 'c']
                    ],
                ],
            ])
        );
    }
}