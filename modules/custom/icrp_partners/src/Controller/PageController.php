<?php

/**
 * @file
 * Contains \Drupal\icrp_partners\Controller\PageController.
 */

namespace Drupal\icrp_partners\Controller;

use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use PDO;

class PageController extends ControllerBase {
    public static function content(): array {
        return [
            '#theme' => 'icrp_partners',
            '#attached' => [
                'library' => [
                    'icrp_partners.content'
                ],
            ],
        ];
    }

    public static function export(): Response {
        return new Response("export");
    }
}