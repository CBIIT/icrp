<?php

namespace Drupal\library\Controller;

use Drupal\Core\Controller\ControllerBase;

class LibraryController extends ControllerBase {
  public function content() {
    return [
      '#theme' => 'library',
      '#attached' => [
        'library' => [
          'library/resources'
        ],
      ],
    ];
  }
}