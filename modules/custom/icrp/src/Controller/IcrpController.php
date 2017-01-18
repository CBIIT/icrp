<?php

namespace Drupal\icrp\Controller;

use Drupal\Core\Controller\ControllerBase;

class IcrpController extends ControllerBase {

    public function sayhello() {
        return array(
            '#markup' => hello_hello_world(),
        );
    }
    public function userReview($uuid) {
        return array(
            '#markup' => reviewUserForm($uuid),
        );
    }

  public function dbSearch() {
    return array(
      '#type' => 'markup',
      '#markup' => t('<app-root>Loading...</app-root>'),
      '#attached' => array(
        'library' => array(
          'hello_world/custom'
        ),
      ),
    );
  }
}