<?php

namespace Drupal\icrp\Controller;

use Drupal\Core\Controller\ControllerBase;

class IcrpController extends ControllerBase {

    public function sayhello() {
        return array(
            '#markup' => hello_hello_world(),
        );
    }

}