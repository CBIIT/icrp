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
        $pdo = PDOBuilder::getConnection();
        return [
            '#theme' => 'icrp_partners',

            '#partners' => PDOBuilder::executePreparedStatement(
                $pdo, 'EXECUTE GetPartners'
            )->fetchAll(),

            '#fundingOrganizations' => PDOBuilder::executePreparedStatement(
                $pdo, 'EXECUTE GetFundingOrgs @type=funding'
            )->fetchAll(),

            '#attached' => [
                'library' => [
                    'icrp_partners/content'
                ],
            ],
        ];
    }

    public static function export(): StreamedResponse {
        return new StreamedResponse(function() {
            $pdo = PDOBuilder::getConnection();
            ExcelBuilder::exportQueries('ICRP Partners.xlsx', [
                [
                    'title' => 'ICRP Partners',
                    'query' => $pdo->prepare('EXECUTE GetPartners'),
                    'columns' => [
                        'Name' => 'Partner Name',
                        'SponsorCode' => 'Sponsor Code',
                        'Country' => 'Country',
                        'JoinDate' => 'Join Date',
                        'Status' => 'Status',
                        'Description' => 'Mission',
                    ],
                ],

                [
                    'title' => 'ICRP Funding Organizations',
                    'query' => $pdo->prepare('EXECUTE GetFundingOrgs @type=funding'),
                    'columns' => [
                       'Name' => 'Name',
                       'Type' => 'Type',
                       'MemberStatus' => 'Status',
                       'Abbreviation' => 'Abbreviation',
                       'SponsorCode' => 'Sponsor Code',
                       'Country' => 'Country',
                       'Currency' => 'Currency',
                       'IsAnnualized' => [
                           'name' => 'Annualized Funding',
                           'formatter' => function($value) {
                                return $value ? 'YES' : 'NO';
                           }],
                       'LastImportDate' => 'Last Import Date',
                       'LastImportDesc' => 'Import Description',
                    ],
                ],
            ]);
        });
    }

    public static function authenticatedExport(): StreamedResponse {
        return new StreamedResponse(function() {
            $pdo = PDOBuilder::getConnection();
            ExcelBuilder::exportQueries('ICRP Partners.xlsx', [
                [
                    'title' => 'ICRP Partners',
                    'query' => $pdo->prepare('EXECUTE GetPartners'),
                    'columns' => [
                        'Name' => 'Partner Name',
                        'SponsorCode' => 'Sponsor Code',
                        'Country' => 'Country',
                        'JoinDate' => 'Join Date',
                        'Status' => 'Status',
                        'Description' => 'Mission',
                    ],
                ],

                [
                    'title' => 'ICRP Funding Organizations',
                    'query' => $pdo->prepare('EXECUTE GetFundingOrgs @type=funding'),
                    'columns' => [
                       'Name' => 'Name',
                       'Type' => 'Type',
                       'MemberStatus' => 'Status',
                       'Abbreviation' => 'Abbreviation',
                       'SponsorCode' => 'Sponsor Code',
                       'Country' => 'Country',
                       'Currency' => 'Currency',
                       'IsAnnualized' => [
                           'name' => 'Annualized Funding',
                           'formatter' => function($value) {
                                return $value ? 'YES' : 'NO';
                           }],
                       'LastImportDate' => 'Last Import Date',
                       'LastImportDesc' => 'Import Description',
                    ],
                ],


            ]);
        });
    }
}