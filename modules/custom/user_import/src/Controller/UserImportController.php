<?php
/**
 * @file
 * contains \Drupal\user_import\Controller\UserImportController.
 */

namespace Drupal\user_import\Controller;

use \Drupal\user\Entity\User;
use \Drupal\file\Entity\File;
use \Drupal\Core\Entity\EntityStorageException;

class UserImportController {

  public static function importPage() {
    $form = \Drupal::formBuilder()->getForm('Drupal\user_import\Form\UserImportForm');
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
    $handle = fopen($file->destination, 'r');
    $created = 0;

    while ($row = fgetcsv($handle, 2000, "|")) {
      drupal_set_message(print_r($row, true));
      if ($values = self::prepareRow($row, $config)) {
        if ($uid = self::createUser($values)) {
            $created++;
          //$created[$uid] = $values;
        }
      }
    }

    return $created;
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
  public static function prepareRow(array $row, array $config, &$organization) {
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
    if($row[4] != "NULL") {
        $roles = array($row[4]);
    }

    //Change row 5 to Active if Approved
    if($row[5] == "Approved") {
        $row[5] = "Active";
    }

    //STATUS - Drupal status is either Active or Blocked
    $status = ($row[5] == "Active") ? 1 :0;
    $organization = row[3];
    return [
      'uid' => NULL,
      'name' => $username,
      'field_first_name' => $row[0],
      'field_last_name' => $row[1],
      'pass' => NULL,
      'mail' => "INVALID.".$row[2],
      'status' => $status,
      'created' => REQUEST_TIME,
      'roles' => array_values($roles),
      'membership_status' => $row[5]
    ];
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
  private function createUser($values) {
    $user = User::create($values);

    $organization = $values['organization_raw'];

    try {
      if ($user->save()) {
          $uid = $user->id();
          addOrganization($uid, $organization);
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
