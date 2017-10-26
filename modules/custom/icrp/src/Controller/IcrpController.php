<?php

namespace Drupal\icrp\Controller;

use Drupal\Core\Ajax\AjaxResponse;
use Drupal\Core\Ajax\OpenDialogCommand;
use Drupal\Core\Ajax\OpenModalDialogCommand;
use Drupal\Core\Controller\ControllerBase;
use Drupal\Core\Ajax\HtmlCommand;
use Drupal\node\Entity\Node;
use Symfony\Component\HttpFoundation\JsonResponse;

class IcrpController extends ControllerBase {

    public function partnerApplicationAdministrationTool() {
        //drupal_set_message("We hit the TOOL.");
        return array(
            '#markup' => partnerApplicationSubmissionsTable(),
        );
    }

    public function userEdit() {
        drupal_set_message("User Edit was hit");
        return array(
            '#markup' => editContent(),
        );
    }

    public function newsletter() {
        return array(
            '#markup' => newsletter2(),
        );
    }

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
    /**
    * @return JsonResponse
    */
    public function getNodeAsModal($nid) {
        //dump($nid);
        $node = Node::load($nid);
        $view = node_view($node,'full');
        $html = render($view);
        $response = new JsonResponse($html);

        return $response;

    }
}