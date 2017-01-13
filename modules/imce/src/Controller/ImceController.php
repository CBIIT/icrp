<?php

namespace Drupal\imce\Controller;

use Symfony\Component\HttpFoundation\Request;
use Drupal\Core\Controller\ControllerBase;
use Drupal\Core\Access\AccessResult;
use Drupal\imce\Imce;

/**
 * Controller routines for imce routes.
 */
class ImceController extends ControllerBase {

  /**
   * Returns an administrative overview of Imce Profiles.
   */
  public function adminOverview(Request $request) {
    // Build the settings form first.(may redirect)
    $output['settings_form'] = \Drupal::formBuilder()->getForm('Drupal\imce\Form\ImceSettingsForm') + array('#weight' => 10);
    // Buld profile list.
    $output['profile_list'] = array(
      '#type' => 'container',
      '#attributes' => array('class' => array('imce-profile-list')),
      'title' => array('#markup' => '<h2>' . $this->t('Configuration Profiles') . '</h2>'),
      'list' => $this->entityTypeManager()->getListBuilder('imce_profile')->render(),
    );
    return $output;
  }

  /**
   * Handles requests to /imce/{scheme} path.
   */
  public function page($scheme, Request $request) {
    return Imce::response($request, $this->currentUser(), $scheme);
  }

  /**
   * Checks access to /imce/{scheme} path.
   */
  public function checkAccess($scheme) {
    return AccessResult::allowedIf(Imce::access($this->currentUser(), $scheme));
  }

}
