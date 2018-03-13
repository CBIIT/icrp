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


    public function content(): array {
        \Drupal::service('page_cache_kill_switch')->trigger();

        $pdo = PDOBuilder::getConnection();

        $partners = PDOBuilder::executePreparedStatement(
            $pdo, 'EXECUTE GetPartners'
        )->fetchAll();

        $fundingOrganizations = PDOBuilder::executePreparedStatement(
            $pdo, 'EXECUTE GetFundingOrgs @type=funding'
        )->fetchAll();

        $nonPartners = PDOBuilder::executePreparedStatement(
            $pdo, 'EXECUTE GetNonPartners'
        )->fetchAll();

        usort($partners, function($a, $b) {
            return strcmp($a['name'], $b['name']);
        });

        // do not show partner emails on public site
        if ($this->currentUser()->isAnonymous())
            foreach($partners as &$record)
                unset($record['email']);

        foreach($nonPartners as &$record) {
            // ensure all websites have a protocol
            if (!preg_match('/^http(s?):\/\//', $record['website'])) {
                $record['website'] = 'http://' . $record['website'];
            }

            // do not include emails if 'Do Not Contact' has been flagged
            if ($record['donotcontact'])
                unset($record['email']);
        }

        return [
            '#theme' => 'icrp_partners',
            '#partners' => $partners,
            '#fundingOrganizations' => $fundingOrganizations,
            '#nonPartners' => $nonPartners,
            '#attached' => [
                'library' => [
                    'icrp_partners/content'
                ],
            ],
        ];
    }

    public function export(): StreamedResponse {
        return new StreamedResponse(function() {
            $pdo = PDOBuilder::getConnection();
            ExcelBuilder::exportQueries('ICRP Partners and Funding Orgs.xlsx', [
                [
                    'title' => 'ICRP Partners',
                    'query' => $pdo->prepare('EXECUTE GetPartners'),
                    'columns' => [
                        'name' => 'Partner Name',
                        'sponsorcode' => 'Sponsor Code',
                        'country' => 'Country',
                        'joindate' => 'Join Date',
                        'status' => 'Status',
                        'description' => 'Mission',
                    ],
                ],

                [
                    'title' => 'ICRP Funding Organizations',
                    'query' => $pdo->prepare('EXECUTE GetFundingOrgs @type=funding'),
                    'columns' => [
                       'name' => 'Name',
                       'type' => 'Type',
                       'memberstatus' => 'Status',
                       'abbreviation' => 'Abbreviation',
                       'sponsorcode' => 'Sponsor Code',
                       'country' => 'Country',
                       'currency' => 'Currency',
                       'isannualized' => [
                           'name' => 'Annualized Funding',
                           'formatter' => function($value) {
                                return $value ? 'YES' : 'NO';
                           }],
                       'lastimportdate' => 'Last Import Date',
                       'lastimportdesc' => 'Import Description',
                    ],
                ],
            ]);
        });
    }


    public function authenticatedExport(): StreamedResponse {
        return new StreamedResponse(function() {
            $pdo = PDOBuilder::getConnection();
            ExcelBuilder::exportQueries('ICRP Partners and Funding Orgs.xlsx', [
                [
                    'title' => 'ICRP Partners',
                    'query' => $pdo->prepare('EXECUTE GetPartners'),
                    'columns' => [
                        'name' => 'Partner Name',
                        'sponsorcode' => 'Sponsor Code',
                        'country' => 'Country',
                        'joindate' => 'Join Date',
                        'status' => 'Status',
                        'description' => 'Mission',
                    ],
                ],

                [
                    'title' => 'ICRP Funding Organizations',
                    'query' => $pdo->prepare('EXECUTE GetFundingOrgs @type=funding'),
                    'columns' => [
                       'name' => 'Name',
                       'type' => 'Type',
                       'memberstatus' => 'Status',
                       'abbreviation' => 'Abbreviation',
                       'sponsorcode' => 'Sponsor Code',
                       'country' => 'Country',
                       'currency' => 'Currency',
                       'isannualized' => [
                           'name' => 'Annualized Funding',
                           'formatter' => function($value, $record) {
                                return $value ? 'YES' : 'NO';
                           }],
                       'lastimportdate' => 'Last Import Date',
                       'lastimportdesc' => 'Import Description',
                    ],
                ],

                [
                    'title' => 'Non-Partners',
                    'query' => $pdo->prepare('EXECUTE GetNonPartners'),
                    'columns' => [
                        'name' => 'Name',
                        'abbreviation' => 'Abbreviation',
                        'description' => 'Description',
                        'estimatedinvest' => 'Est. Investment',
                        'country' => 'Country',
                        'email' => [
                            'name' => 'Email',
                            'formatter' => function($value, $record) {
                                 return $record['donotcontact'] ? '' : $value;
                            }],
                        'website' => 'Website',
                        'contactperson' => 'Contact Person',
                        'position' => 'Position',
                        'donotcontact' => [
                            'name' => 'Do Not Contact?',
                            'formatter' => function($value, $record) {
                                 return $value ? 'YES' : 'NO';
                            }],
                        'canceronly' => [
                            'name' => 'Cancer Only?',
                            'formatter' => function($value, $record) {
                                 return $value ? 'YES' : 'NO';
                            }],
                        'researchfunder' => [
                            'name' => 'Research Funder?',
                            'formatter' => function($value, $record) {
                                 return $value ? 'YES' : 'NO';
                            }],
                        'note' => 'Notes',
                    ],
                ],
            ]);
        });
    }
}