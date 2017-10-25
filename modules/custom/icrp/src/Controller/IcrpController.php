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
        /*
        $my_modal =  [
          '#type' => 'link',
          '#title' => $this->t('Some text'),
          '#url' => Url::fromRoute('/events/581', [], ['query' => $this->getDestinationArray()]),
          '#options' => ['attributes' => [
            'class' => ['use-ajax'],
            'data-dialog-type' => 'modal',
            'data-dialog-options' => Json::encode([
              'width' => 700,
            ]),
          ]],
          '#attached' => ['library' => ['core/drupal.dialog.ajax']],
        ];
        */
/*  TESTING */
/*
      $content = array(
        'content' => array(
          '#markup' => 'My return',
        ),
      );
      $response = new AjaxResponse();
      $main_content['#attached']['library'][] = 'core/drupal.dialog.ajax';
      $response->setAttachments($main_content['#attached']);

      $html = drupal_render($content);

      $response->addCommand(new OpenModalDialogCommand('Hi', $html));
      $options = $request->request->get('dialogOptions', array());

      $response->addCommand(new OpenModalDialogCommand($title, $content, $options));
*/
/* WORKING */
        //dump($nid);
        $node = Node::load($nid);
        $view = node_view($node,'full');
        //dump($view);
        $html = render($view);
        //$html = "<b>Hello there.</b>  Are you bold?";
        //$response = new AjaxResponse();
        //dump($response);

        //$main_content['#attached']['library'][] = 'core/drupal.dialog.ajax';
        //$response->setAttachments($main_content['#attached']);

        //dump($response);
        //$response->addCommand(new OpenModalDialogCommand(t('Modal Title'), $html));
        //$response->addCommand(new HtmlCommand('#dialog-form','html'));
        //dump($response);
        //dump($response);
        $response = new JsonResponse($html);

        return $response;

    }
}