<?php

namespace Drupal\toolbar_themes\Form;

use Drupal\Core\Form\ConfigFormBase;
use Drupal\Core\Form\FormStateInterface;

/**
 * Toobar themes settings form.
 */
class ToolbarThemesSettingsForm extends ConfigFormBase {

  /**
   * {@inheritDoc}
   */
  public function getFormId() {
    return 'toolbar_themes_form';
  }

  /**
   * {@inheritdoc}
   */
  protected function getEditableConfigNames() {
    return [
      'toolbar_themes.settings',
    ];
  }

  /**
   * {@inheritdoc}
   */
  public function buildForm(array $form, FormStateInterface $form_state) {
    $config = $this->config('toolbar_themes.settings');
    $admin_theme = $this->config('system.theme')->get('admin');

    $form['settings'] = array(
      '#type' => 'container',
      '#tree' => TRUE,
      '#title' => t('Toolbar Themes'),
    );

    $form['settings']['info'] = array(
      '#type' => 'markup',
      '#prefix' => '<p class="toolbar-themes form-info">',
      '#suffix' => '</p>',
      '#markup' => t('Select options to style the Toolbar.'),
    );

    // Table
    $header = array(
      'theme' => t('Theme'),
      'screen_shot' => t('Screen Shots'),
      'meta' => t('Meta'),
    );

    $definitions = toolbar_themes_get_theme_definitions();
    $theme_handler = \Drupal::service('theme_handler');
    $options = array();

    foreach ($definitions as $provider => $values) {
      if ($theme_handler->themeExists($provider)) {
        $provider_path = drupal_get_path('theme', $provider);
      }
      else {
        $provider_path = drupal_get_path('module', $provider);
      }
      foreach ($values as $theme => $data) {
        if (!isset($data['hidden']) || $data['hidden'] !== TRUE) {
          // Label
          $label[$theme] = ucfirst(t($data['label']));
          // Description
          $description[$theme] = $data['description'] ? t($data['description']) : t('No description provided');
          // Dependencies
          $dependency[$theme] = isset($data['libraries']['dependencies']) ? $data['libraries']['dependencies'][0] : NULL;
          $screen_shot = [];
          if ((isset($data['path']) && !empty($data['path'])) && (isset($data['screen_shot']) && !empty($data['screen_shot']))) {
            $screen_shot[$theme] = array(
              '#theme' => 'image',
              '#uri' => $provider_path . '/' . $data['path'] . '/' . $data['screen_shot'],
              '#alt' => $description[$theme],
              '#attributes' => array('class' => array('toolbar-theme-screen-shot')),
            );
          }
          else {
            $screen_shot[$theme] = array(
              '#markup' => '<em>' . t('No screen shot provided') . '</em>',
            );
          }
          // Meta
          $meta[$theme]['version'] = $data['version'] ? $data['version'] : NULL;
          $meta[$theme]['meta'] = array(
            '#markup' => '<dl class="toolbar-themes-meta"><dt>' . t('Version') .'</dt><dd>' . $meta[$theme]['version'] .'</dd><dt>' . t('Provider') .'</dt><dd>' . $provider . '</dd></dl>',
          );
          // Table options
          $options[$theme] = array(
            'theme' => $label[$theme],
            'screen_shot' => \Drupal::service('renderer')->render($screen_shot[$theme]),
            'meta' => \Drupal::service('renderer')->render($meta[$theme]['meta']),
          );
          // Radios default value is a key, not an array.
          if ($config->get('default_theme') === $theme) {
            $default = $theme;
          }
        }
      }
    }

    if (!empty($options)) {
      $form['settings']['default_theme'] = array(
        '#type' => 'tableselect',
        '#title' => t('Select toolbar theme'),
        '#header' => $header,
        '#options' => $options,
        '#multiple' => FALSE,
        '#js_select' => FALSE,
        '#default_value' => $default,
        '#empty' => t('No toolbar themes found'),
      );
    }

    $form['settings']['font_size'] = array(
      '#type' => 'number',
      '#title' => t('Set font size'),
      '#max-length' => 2,
      '#step' => 1,
      '#default_value' => $config->get('font_size'),
      '#attributes' => array(
        'min' => 10,
        'max' => 99,
        'step' => 1,
        'class' => array('font-size'),
      ),
      '#field_suffix' => 'px',
    );

    // Adminimal warnings etc.
    if ($admin_theme == 'adminimal_theme') {
      $form['settings']['font_disabled'] = array(
        '#type' => 'markup',
        '#prefix' => '<div class="messages messages--warning">',
        '#suffix' => '</div>',
        '#markup' => t('For Adminmal the font size will only apply to the front end theme.'),
      );
    }

    $form['settings']['tabs'] = array(
      '#type' => 'checkbox',
      '#title' => t('Show toolbar tabs'),
      '#default_value' => $config->get('tabs'),
      '#description' => t('Unchecked this will remove tabs except for the Manage tab which is replaced by an icon.'),
    );

    $form['settings']['icons'] = array(
      '#type' => 'checkbox',
      '#title' => t('Show icons'),
      '#default_value' => $config->get('icons'),
      '#description' => t('Unchecked this will remove icons from tab and menu items, while orientation toggle icons and sub-menu arrows remain.'),
    );

    $form['settings']['actions']['#type'] = 'actions';
    $form['settings']['actions']['submit'] = array(
      '#type' => 'submit',
      '#value' => $this->t('Submit'),
      '#button_type' => 'primary',
    );

    return $form;
  }

  /**
   * {@inheritDoc}
   */
  public function validateForm(array &$form, FormStateInterface $form_state) {}

  /**
   * {@inheritdoc}
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {
    $values = $form_state->getValues();
    $config = \Drupal::service('config.factory')->getEditable('toolbar_themes.settings');
    foreach ($values['settings'] as $key => $setting) {
      $config->set($key, $setting);
    }
    $config->save();
    parent::submitForm($form, $form_state);
    drupal_flush_all_caches();
  }
}
