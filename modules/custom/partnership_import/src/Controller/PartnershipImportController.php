<?php
/**
 * @file
 * contains \Drupal\partnership_import\Controller\UserImportController.
 */

namespace Drupal\partnership_import\Controller;

use \Drupal\user\Entity\User;
use \Drupal\file\Entity\File;
use \Drupal\Core\Entity\EntityStorageException;

class PartnershipImportController {

  public static function importPage() {
    $form = \Drupal::formBuilder()->getForm('Drupal\partnership_import\Form\PartnershipImportForm');
    return $form;
  }

  /**
   * Processes an uploaded CSV file, creating a new user for each row of values.
   *
   * @param \Drupal\file\Entity\File $file
   *   The File entity to process.
   *
   * @param array $config
   *   An array of configuration containing:
   *   - roles: an array of role ids to assign to the user
   *
   * @return array
   *   An associative array of values from the filename keyed by new uid.
   */
  public static function processUpload(File $file, array $config) {
    $file = fopen($file->destination, 'r');
    $created = 0;
     $memory_size = 1024; //1 Meg
    \Drupal::logger('user import')->notice('processUpload()');
      while(! feof($file)) {
          $row = fgetcsv($file, $memory_size, "|");
          // \Drupal::logger('user import')->notice(print_r($row, true));
          drupal_set_message("$created: ".print_r($row, true));
          if($created > 0) {
              $values = self::prepareRow($row, $config);
                  //if ($uid = self::createUser($values)) {
                  if ($uid = self::createUserDrupal8($values)) {
                      \Drupal::logger('user import')->notice("$created");
                      //$created[$uid] = $values;
                  }

          }
          $created++;
      }

      fclose($file);
/*
 *
    while ($row = fgetcsv($handle, 2000, "|")) {
       \Drupal::logger('user import')->notice('row: '.print_r($row));
      if ($values = self::prepareRow($row, $config)) {
        if ($uid = self::createUser($values)) {
            $created++;
          //$created[$uid] = $values;
        }
      }
    }
*/

    return $created-1;
  }

  /**
   * Prepares a new user from an upload row and current config.
   *
   * @param $row
   *   A row from the currently uploaded file.
   *
   * @param $config
   *   An array of configuration containing:
   *   - roles: an array of role ids to assign to the user
   *
   * @return array
   *   New user values suitable for User::create().
   */
  public static function prepareRow(array $row, array $config) {
      /* USERNAME */
    $preferred_username = (strtolower($row[0] .".". $row[1]));
    $i = 0;
    while (self::usernameExists($i ? $preferred_username . $i : $preferred_username)) {
      $i++;
    }
    $username = $i ? $preferred_username . $i : $preferred_username;
      //ROW:          0    |    1   |  2  |     3      | 4  |   5
      //csv file: FirstName|LastName|EMAIL|Organization|Role|Access

    //Add either Partner or Manager role.  Or if NULL then no role
    $roles = array();
    if(strlen($row[4]) > 0  && strcmp($row[4], "NULL") !=0) {
        $roles = array(strtolower($row[4]));
    }

    //Change row 5 to Active if Approved
    if($row[5] == "Approved") {
        $row[5] = "Active";
    }
    if($row[5] == "Block") {
      $row[5] = "Blocked";
    }

    //STATUS - Drupal status is either Active or Blocked
    $status = ($row[5] == "Active") ? 1 :0;
    $organization = $row[3];
    $user = [
      'uid' => NULL,
      'name' => mb_convert_encoding($username, "UTF-8", "auto"),
      'field_first_name' =>  mb_convert_encoding($row[0], "UTF-8", "auto"),
      'field_last_name' => $row[1],
      'pass' => NULL,
      'mail' => $row[2],
      'status' => $status,
      'created' => REQUEST_TIME,
      'roles' => array_values($roles),
      'field_membership_status' => $row[5],
       'field_organization' => $row[3]
    ];

    return $user;
  }

  /**
   * Returns user whose name matches $username.
   *
   * @param string $username
   *   Username to check.
   *
   * @return array
   *   Users whose names match username.
   */
  private static function usernameExists($username) {
    return \Drupal::entityQuery('user')->condition('name', $username)->execute();
  }

  /**
   * Creates a new user from prepared values.
   *
   * @param $values
   *   Values prepared from prepareRow().
   *
   * @return \Drupal\user\Entity\User
   *
   */
  private static function createUserDrupal8($values) {
      // http://drupal8.ovh/en/tutoriels/13/create-a-user-account-programmatically-drupal-8
      ini_set('memory_limit', '256M');
      $language = \Drupal::languageManager()->getCurrentLanguage()->getId();
      $user = \Drupal\user\Entity\User::create();

      //Mandatory settings
      $user->setPassword('');
      $user->enforceIsNew();
      $user->setEmail($values['mail']);
      $user->setUsername($values['name']);//This username must be unique and accept only a-Z,0-9, - _ @ .

//Optional settings
//      $user->set("init", 'email');
      $user->set("langcode", $language);
      $user->set("preferred_langcode", $language);
      $user->set("preferred_admin_langcode", $language);
      //$user->set("setting_name", 'setting_value');
      if($values['status'] ==1 ) {
          $user->activate();
      }
      $user->set("field_first_name", $values['field_first_name']);
      $user->set("field_last_name", $values['field_last_name']);
      $user->set("field_membership_status", $values['field_membership_status']);
      foreach ($values['roles'] as $assign_role) {
          if($assign_role === "manager") {
              $user->addRole("manager");
          }
          if($assign_role === "partner") {
              $user->addRole("partner");
          }
      }
    //Look up Organization $nid
      \Drupal::logger('user import')->notice("Looking for: ".$values['field_organization']);

      $query = \Drupal::entityQuery('node')
          ->condition('status', 1, '=')
          ->condition('type', 'organization', '=')
          ->condition('title', $values['field_organization'], '=');

      $nids = $query->execute();
      //drupal_set_message("nids = ".print_r($nids, true));
      $nid = 0;
      foreach($nids as $key => $value) {
          //drupal_set_message($key." => ".$value);
          $nid = $value;
      }
      if($nid != 0) {
          //drupal_set_message("Winner: ".$nid);
          $user->set("field_organization", $nid);
      } else {
          \Drupal::logger('user import')->warning("ORGANIZATION Not found: " . $values['field_organization']);
          drupal_set_message("ORGANIZATION Not found: " . $values['field_organization'], 'warning');
      }

      //$user->set("field_organization", $values['field_organization']);   foreach ($nids as $nid) {
/*      foreach ($node_links[$nid] as $mlid => $link) {
          $node_links[$nid][$mlid]['access'] = TRUE;
      }
*/

//Save user

      $res = $user->save();
      unset($user);

  }
  private function createUser($values) {
    $user = User::create($values);

    $organization = $values['organization_raw'];

    try {
      if ($user->save()) {
          $uid = $user->id();
          addOrganization($uid, $organization);
          unset($user);
        return $uid;
      }
    }
    catch (EntityStorageException $e) {
      drupal_set_message(t('Could not create user %fname %lname (username: %uname) (email: %email); exception: %e', [
        '%e' => $e->getMessage(),
        '%fname' => $values['field_name_first'],
        '%lname' => $values['field_name_last'],
        '%uname' => $values['name'],
        '%email' => $values['mail'],
      ]), 'error');
    }
    return FALSE;
  }

    private function addOrganization($uid, $organization) {

    }
}
