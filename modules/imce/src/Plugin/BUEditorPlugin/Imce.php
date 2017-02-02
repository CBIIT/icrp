<?php

namespace Drupal\imce\Plugin\BUEditorPlugin;

use Drupal\Core\Form\FormStateInterface;
use Drupal\editor\Entity\Editor;
use Drupal\bueditor\BUEditorPluginBase;
use Drupal\bueditor\Entity\BUEditorEditor;
use Drupal\imce\Imce as ImceMain;

/**
 * Defines Imce as a BUEditor plugin.
 *
 * @BUEditorPlugin(
 *   id = "imce",
 *   label = "Imce File Manager"
 * )
 */
class Imce extends BUEditorPluginBase {

  /**
   * {@inheritdoc}
   */
  public function alterEditorJS(array &$js, BUEditorEditor $bueditor_editor, Editor $editor = NULL) {
    // Check selected file browser.
    if (isset($js['settings']['fileBrowser']) && $js['settings']['fileBrowser'] === 'imce') {
      // Check access
      if (ImceMain::access()) {
        $js['libraries'][] = 'imce/drupal.imce.bueditor';
      }
      else {
        unset($js['settings']['fileBrowser']);
      }
    }
  }

  /**
   * {@inheritdoc}
   */
  public function alterEditorForm(array &$form, FormStateInterface $form_state, BUEditorEditor $bueditor_editor) {
    // Add imce option to file browser field.
    $fb = &$form['settings']['fileBrowser'];
    $fb['#options']['imce'] = $this->t('Imce File Manager');
    // Add configuration link
    $form['settings']['imce'] = array(
      '#type' => 'container',
      '#states' => array(
        'visible' => array(':input[name="settings[fileBrowser]"]' => array('value' => 'imce')),
      ),
      '#attributes' => array(
        'class' => array('description'),
      ),
      'content' => array(
        '#markup' => $this->t('Configure <a href=":url">Imce File Manager</a>.', array(':url' => \Drupal::url('imce.admin')))
      ),
    );
    // Set weight
    if (isset($fb['#weight'])) {
      $form['settings']['imce']['#weight'] = $fb['#weight'] + 0.1;
    }
  }

}
