<?php

namespace Drupal\icrp\Controller;

use Drupal\Core\Ajax\AjaxResponse;
use Drupal\Core\Ajax\OpenDialogCommand;
use Drupal\Core\Ajax\OpenModalDialogCommand;
use Drupal\Core\Controller\ControllerBase;
use Drupal\Core\Ajax\HtmlCommand;
use Drupal\node\Entity\Node;
use Symfony\Component\HttpFoundation\JsonResponse;
use Drupal\db_search_api\Controller\PDOBuilder;
use PDO;

class IcrpController extends ControllerBase {

    public function partnerApplicationAdministrationTool() {
        //drupal_set_message("We hit the TOOL.");
        return array(
            '#markup' => partnerApplicationSubmissionsTable(),
        );
    }

    public function userEdit() {
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
        $view = \Drupal::entityTypeManager()->getViewBuilder('node')->view($node,'full');
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
        \Drupal\core\Database\Database::getConnection();
        $query = "SELECT count(*) as count FROM node_field_data where nid = $nid and uid = $uid;";
        $result = \Drupal::database()->query($query);

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
        $view = \Drupal::entityTypeManager()->getViewBuilder('node')->view($node, 'teaser');
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

    public function getEvents() {

        $renderable = [
            '#theme' => 'icrp_events',
            '#test_var' => 'My test variable',
        ];
        return $renderable;
    }

    public function getResources() {
        $renderable = [
            '#theme' => 'resources',
            '#test_var' => 'My test variable',
        ];
        return $renderable;
    }

    public function getSurveyResults() {
        \Drupal::service('page_cache_kill_switch')->trigger();
        return array(
            '#markup' => getSurveyResultsHTML(),
            '#cache' => ['max-age' => 0,],    //Set cache for 0 seconds.
        );
    }
    public function getSurveyConfig() {
	    $webform = "webform.webform.icrp_website_survey";
        $status = isSurveyOpen($webform);
        $data = json_encode(array('isSurveyOpen'=> $status), true);
        $response = new JsonResponse($data);

        return $response;

    }
 
    function getCovidSurveyConfig() {
	    $webform = "webform.webform.covid_survey";
        $status = isSurveyOpen($webform);
        $data = json_encode(array('isSurveyOpen'=> $status), true);
        $response = new JsonResponse($data);

        return $response;

    }

    
    function getCountryIncomeBands() {
        $pdo = PDOBuilder::getConnection("icrp_database");
        $sql = "
            SELECT 
                CountryID as id,
                RTRIM(Abbreviation) as abbreviation,
                Name as name,
                IncomeBand as incomeBand
            from Country";
        $data = $pdo->query($sql)->fetchAll(PDO::FETCH_ASSOC);
        $response = new JsonResponse($data);
        return $response;
    }
}
