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

    public function getDataCaveats() {
        return array(
            '#markup' => getDataCaveatsHTML(),
        );
    }

    public function getDataCaveatsCCRA() {
        return array(
            '#markup' => getDataCaveatsCCRAHTML(),
        );
    }

    /**
    * @return JsonResponse
    */
    public function getNodeAsJson($nid) {
        //dump($nid);
        $node = Node::load($nid);
        $view = node_view($node,'full');
        //dump($view);
        $html = render($view);
        $response = new JsonResponse($html);

        return $response;

    }
    public function getNodePermissionsAsJson($nid) {
        //dump($nid);
        $editable = false;
        //$node = Node::load($nid);
        //$view = node_view($node,'full');
        //dump($view);
        //$html = render($view);
        //If Admin or Manager or IsOwner then return true
        $uid = \Drupal::currentUser()->id();
        $user = \Drupal::service('entity_type.manager')->getStorage('user')->load($uid);
        $roles = array();
        if($user->hasRole('administrator')){
            $roles[] = "administrator";
        }
        if($user->hasRole('manager')){
            $roles[] = "manager";
        }
        if($user->hasRole('partner')){
            $roles[] = "partner";
        }
        $isOwner = false;
        $query = "SELECT count(*) as count FROM node_field_data where nid = $nid and uid = $uid;";
        $result = db_query($query);
        $row = $result->fetchObject();
        if(isset($row->count) && $row->count == 1) {
            $isOwner = true;
        }        
        if($user->hasRole('administrator') || $user->hasRole('manager') || $isOwner) {
            $editable = true;
        }

        $data = json_encode(array('editable'=> $editable), true);
        //dump($data);
        $response = new JsonResponse($data);

        return $response;

    }
    /**
    * @return JsonResponse
    */
    public function getNodeAsModal($nid) {
        //dump($nid);
        $node = Node::load($nid);
        $view = node_view($node, 'teaser');
        $html = render($view);
        $response = new AjaxResponse();
        $response->addCommand(new OpenModalDialogCommand(t('Modal Title'), $html));

        return $response;

    }
    /**
    * @return JsonResponse
    */
    public function getUserRoles() {
        $uid = \Drupal::currentUser()->id();
        $user = \Drupal::service('entity_type.manager')->getStorage('user')->load($uid);
        $roles = array();
        if($user->hasRole('administrator')){
            $roles[] = "administrator";
        }
        if($user->hasRole('manager')){
            $roles[] = "manager";
        }
        if($user->hasRole('partner')){
            $roles[] = "partner";
        }
        $html = json_encode($roles, true);

        $response = new JsonResponse($html);

        return $response;

    }

    public function getEventsAndResources() {
        \Drupal::service('page_cache_kill_switch')->trigger();
        return array(
            '#markup' => getEventsAndResourcesHTML(),
            '#cache' => ['max-age' => 0],
        );
    }

}