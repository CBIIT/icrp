<?php

namespace Drupal\nice_menus\Form;

use Drupal\Core\Form\ConfigFormBase;
use Drupal\Core\Form\FormStateInterface;

/**
 * Provides a nice menus settings form.
 */
class NiceMenusSettingsForm extends ConfigFormBase {

  /**
   * Implements \Drupal\Core\Form\FormInterface::getFormID().
   */
  public function getFormID() {
    return 'nice_menus_settings';
  }

  /**
   * Gets the configuration names that will be editable.
   *
   * @return array
   *   An array of configuration object names that are editable if called in
   *   conjunction with the trait's config() method.
   */
  protected function getEditableConfigNames() {
    return [
      'nice_menus.settings',
    ];
  }

  /**
   * @param array                                $form
   * @param \Drupal\Core\Form\FormStateInterface $form_state
   *
   * @return array
   */
  public function buildForm(array $form, FormStateInterface $form_state) {
    $config = $this->config('nice_menus.settings');
    // Use JavaScript configuration setting.
    $form['nice_menus_js'] = array(
      '#type'          => 'checkbox',
      '#title'         => $this->t('Use JavaScript'),
      '#description'   => $this->t('This will add Superfish jQuery to Nice menus. This is required for Nice menus to work properly in Internet Explorer.'),
      '#default_value' => $config->get('nice_menus_js'),
    );

    $form['nice_menus_default_css'] = array(
      '#type'          => 'checkbox',
      '#title'         => $this->t('Use default css'),
      '#description'   => $this->t('This will add default nice menus style.'),
      '#default_value' => $config->get('nice_menus_default_css'),
    );

    $form['nice_menus_sf_options'] = array(
      '#type'        => 'fieldset',
      '#title'       => $this->t('Advanced: Superfish options'),
      '#description' => $this->t('You can change the default Superfish options by filling out the desired values here. These only take effect if the Use JavaScript box above is checked.'),
      '#collapsible' => TRUE,
      '#collapsed'   => TRUE,
    );

    // Mouse delay textfield for the time before the menus is closed.
    $form['nice_menus_sf_options']['nice_menus_sf_delay'] = array(
      '#type'          => 'number',
      '#title'         => $this->t('Mouse delay'),
      '#description'   => $this->t('The delay in milliseconds that the mouse can remain outside a submenu without it closing.'),
      '#default_value' => $config->get('nice_menus_sf_delay'),
      '#size'          => 5,
    );

    // Display speed of the animation for the menu to open/close.
    $form['nice_menus_sf_options']['nice_menus_sf_speed'] = array(
      '#type'          => 'select',
      '#title'         => $this->t('Animation speed'),
      '#description'   => $this->t('Speed of the menu open/close animation.'),
      '#options'       => array(
        'slow'   => $this->t('slow'),
        'normal' => $this->t('normal'),
        'fast'   => $this->t('fast'),
      ),
      '#default_value' => $config->get('nice_menus_sf_speed'),
    );
    return parent::buildForm($form, $form_state);
  }

  /**
   * @param array                                $form
   * @param \Drupal\Core\Form\FormStateInterface $form_state
   */
  public function validateForm(array &$form, FormStateInterface $form_state) {

  }

  /**
   * @param array                                $form
   * @param \Drupal\Core\Form\FormStateInterface $form_state
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {
    $this->config('nice_menus.settings')
      ->set('nice_menus_sf_delay', $form_state->getValue('nice_menus_sf_delay'))
      ->set('nice_menus_js', $form_state->getValue('nice_menus_js'))
      ->set('nice_menus_sf_speed', $form_state->getValue('nice_menus_sf_speed'))
      ->set('nice_menus_default_css', $form_state->getValue('nice_menus_default_css'))
      ->save();
    parent::submitForm($form, $form_state);
  }
}
