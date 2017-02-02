<?php

namespace Drupal\imce\Form;

use Drupal\Core\Entity\EntityForm;
use Drupal\Core\Form\FormStateInterface;
use Drupal\imce\Imce;

/**
 * Base form for Imce Profile entities.
 */
class ImceProfileForm extends EntityForm {

  /**
   * Folder permissions.
   *
   * @var array
   */
  public $folderPermissions;

  /**
   * {@inheritdoc}
   */
  public function form(array $form, FormStateInterface $form_state) {
    $imce_profile = $this->getEntity();
    // Check duplication
    if ($this->getOperation() === 'duplicate') {
      $imce_profile = $imce_profile->createDuplicate();
      $imce_profile->set('label', $this->t('Duplicate of @label', array('@label' => $imce_profile->label())));
      $this->setEntity($imce_profile);
    }
    // Label
    $form['label'] = array(
      '#type' => 'textfield',
      '#title' => $this->t('Name'),
      '#default_value' => $imce_profile->label(),
      '#maxlength' => 64,
      '#required' => TRUE,
      '#weight' => -20,
    );
    // Id
    $form['id'] = array(
      '#type' => 'machine_name',
      '#machine_name' => array(
        'exists' => array(get_class($imce_profile), 'load'),
        'source' => array('label'),
      ),
      '#default_value' => $imce_profile->id(),
      '#maxlength' => 32,
      '#required' => TRUE,
      '#weight' => -20,
    );
    // Description
    $form['description'] = array(
      '#type' => 'textfield',
      '#title' => $this->t('Description'),
      '#default_value' => $imce_profile->get('description'),
      '#weight' => -10,
    );
    // Conf
    $conf = array(
      '#tree' => TRUE,
    );
    // Extensions
    $conf['extensions'] = array(
      '#type' => 'textfield',
      '#title' => $this->t('Allowed file extensions'),
      '#default_value' => $imce_profile->getConf('extensions'),
      '#maxlength' => 255,
      '#description' => $this->t('Separate extensions with a space, and do not include the leading dot.') . ' ' . $this->t('Set to * to allow all extensions.'),
      '#weight' => -9,
    );
    // File size
    $maxsize = file_upload_max_size();
    $conf['maxsize'] = array(
      '#type' => 'number',
      '#min' => 0,
      '#max' => ceil($maxsize/1024/1024),
      '#step' => 'any',
      '#size' => 8,
      '#title' => $this->t('Maximum file size'),
      '#default_value' => $imce_profile->getConf('maxsize'),
      '#description' => $this->t('Maximum allowed file size per upload.') . ' ' . t('Your PHP settings limit the upload size to %size.', array('%size' => format_size($maxsize))),
      '#field_suffix' => $this->t('MB'),
      '#weight' => -8,
    );
    // Quota
    $conf['quota'] = array(
      '#type' => 'number',
      '#min' => 0,
      '#step' => 'any',
      '#size' => 8,
      '#title' => $this->t('Disk quota'),
      '#default_value' => $imce_profile->getConf('quota'),
      '#description' => $this->t('Maximum disk space that can be allocated by a user.'),
      '#field_suffix' => $this->t('MB'),
      '#weight' => -7,
    );
    // Image dimensions
    $conf['dimensions'] = array(
      '#type' => 'container',
      '#attributes' => array('class' => array('dimensions-wrapper form-item')),
      '#weight' => -6,
    );
    $conf['dimensions']['label'] = array(
      '#markup' => '<label>' . $this->t('Maximum image dimensions') . '</label>',
    );
    $conf['dimensions']['maxwidth'] = array(
      '#type' => 'number',
      '#default_value' => $imce_profile->getConf('maxwidth'),
      '#maxlength' => 5,
      '#min' => 0,
      '#size' => 8,
      '#placeholder' => $this->t('Width'),
      '#field_suffix' => ' x ',
      '#parents' => array('conf', 'maxwidth'),
    );
    $conf['dimensions']['maxheight'] = array(
      '#type' => 'number',
      '#default_value' => $imce_profile->getConf('maxheight'),
      '#maxlength' => 5,
      '#min' => 0,
      '#size' => 8,
      '#placeholder' => $this->t('Height'),
      '#field_suffix' => $this->t('pixels'),
      '#parents' => array('conf', 'maxheight'),
    );
    $conf['dimensions']['description'] = array(
      '#markup' => '<div class="description">' . $this->t('Images exceeding the limit will be scaled down.') . '</div>',
    );
    // Replace method
    $conf['replace'] = array(
      '#type' => 'radios',
      '#title' => $this->t('Upload replace method'),
      '#default_value' => $imce_profile->getConf('replace', FILE_EXISTS_RENAME),
      '#options' => array(
        FILE_EXISTS_RENAME => t('Keep the existing file renaming the new one'),
        FILE_EXISTS_REPLACE => t('Replace the existing file with the new one'),
        FILE_EXISTS_ERROR => t('Keep the existing file rejecting the new one'),
      ),
      '#description' => $this->t('Select the replace method for existing files during uploads.'),
      '#weight' => -5,
    );
    // Folders
    $conf['folders'] = array(
      '#type' => 'fieldset',
      '#title' => $this->t('Folders'),
      'description' => array('#markup' => '<div class="description">' . $this->t('You can use user tokens in folder paths, e.g. @tokens.', array('@tokens' => '[user:uid], [user:name]' )) . ' ' . $this->t('Subfolders inherit parent permissions when subfolder browsing is enabled.') . '</div>'),
      '#weight' => 10,
    );
    $folders = $imce_profile->getConf('folders', array());
    $index = 0;
    foreach ($folders as $folder) {
      $conf['folders'][] = $this->folderForm($index++, $folder);
    }
    $conf['folders'][] = $this->folderForm($index++);
    $conf['folders'][] = $this->folderForm($index);
    $form['conf'] = $conf;
    // Add library
    $form['#attached']['library'][] = 'imce/drupal.imce.admin';
    // Call plugin form alterers
    \Drupal::service('plugin.manager.imce.plugin')->alterProfileForm($form, $form_state, $imce_profile);
    return parent::form($form, $form_state);
  }

  /**
   * Returns folder form elements.
   */
  public function folderForm($index, array $folder = array()) {
    $folder += array('path' => '', 'permissions' => array());
    $form = array(
      '#type' => 'container',
      '#attributes' => array('class' => array('folder-container')),
    );
    $form['path'] = array(
      '#type' => 'textfield',
      '#default_value' => $folder['path'],
      '#field_prefix' => '&lt;' . $this->t('root') . '&gt;' . '/',
    );
    $form['permissions'] = array(
      '#type' => 'fieldset',
      '#title' => $this->t('Permissions'),
      '#attributes' => array('class' => array('folder-permissions')),
    );
    $perms = $this->permissionInfo();
    $form['permissions']['all'] = array(
      '#type' => 'checkbox',
      '#title' => $this->t('All permissions'),
      '#default_value' => isset($folder['permissions']['all']) ? $folder['permissions']['all'] : 0,
    );
    foreach ($perms as $perm => $title) {
      $form['permissions'][$perm] = array(
        '#type' => 'checkbox',
        '#title' => $title,
        '#default_value' => isset($folder['permissions'][$perm]) ? $folder['permissions'][$perm] : 0,
        '#states' => array(
          'disabled' => array('input[name="conf[folders][' . $index . '][permissions][all]"]' => array('checked' => TRUE)),
        ),
      );
    }
    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function validateForm(array &$form, FormStateInterface $form_state) {
    // Check folders
    $folders = array();
    foreach ($form_state->getValue(array('conf', 'folders')) as $i => $folder) {
      $path = trim($folder['path']);
      // Empty path
      if ($path === '') {
        continue;
      }
      // Validate path
      if (!Imce::regularPath($path)) {
        return $form_state->setError($form['conf']['folders'][$i]['path'], $this->t('Invalid folder path.'));
      }
      // Remove empty permissions
      $folder['permissions'] = array_filter($folder['permissions']);
      $folder['path'] = $path;
      $folders[$path] = $folder;
    }
    // No valid folders
    if (!$folders) {
      return $form_state->setError($form['conf']['folders'][0]['path'], $this->t('You must define a folder.'));
    }
    $form_state->setValue(array('conf', 'folders'), array_values($folders));
    // Call plugin validators
    \Drupal::service('plugin.manager.imce.plugin')->validateProfileForm($form, $form_state, $this->getEntity());
    return parent::validateForm($form, $form_state);
  }

  /**
   * {@inheritdoc}
   */
  public function save(array $form, FormStateInterface $form_state) {
    $imce_profile = $this->getEntity();
    $status = $imce_profile->save();
    if ($status == SAVED_NEW) {
      drupal_set_message($this->t('Profile %name has been added.', array('%name' => $imce_profile->label())));
    }
    elseif ($status == SAVED_UPDATED) {
      drupal_set_message($this->t('The changes have been saved.'));
    }
    $form_state->setRedirect('entity.imce_profile.edit_form', array('imce_profile' => $imce_profile->id()));
  }

  /**
   * Returns folder permission definitions.
   */
  public function permissionInfo() {
    if (!isset($this->folderPermissions)) {
      $this->folderPermissions = \Drupal::service('plugin.manager.imce.plugin')->permissionInfo();
    }
    return $this->folderPermissions;
  }

}
