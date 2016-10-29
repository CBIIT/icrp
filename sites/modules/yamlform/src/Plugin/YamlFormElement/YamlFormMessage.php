<?php

namespace Drupal\yamlform\Plugin\YamlFormElement;

use Drupal\Core\Form\FormStateInterface;

/**
 * Provides a 'yamlform_message' element.
 *
 * @YamlFormElement(
 *   id = "yamlform_message",
 *   label = @Translation("Message"),
 *   category = @Translation("Containers"),
 * )
 */
class YamlFormMessage extends ContainerBase {

  /**
   * {@inheritdoc}
   */
  public function getDefaultProperties() {
    return [
      'attributes__class' => '',
      'attributes__style' => '',

      'admin_title' => '',
      'private' => FALSE,

      'flex' => 1,
      'states' => [],
      'display_on' => 'form',

      'message_type' => 'status',
      'message_message' => '',
    ];
  }

  /**
   * {@inheritdoc}
   */
  public function form(array $form, FormStateInterface $form_state) {
    $form = parent::form($form, $form_state);
    $form['message'] = [
      '#type' => 'details',
      '#title' => $this->t('Message settings'),
      '#open' => FALSE,
    ];
    $form['message']['message_type'] = [
      '#type' => 'select',
      '#title' => $this->t('Message type'),
      '#options' => [
        'status' => t('Status'),
        'error' => t('Error'),
        'warning' => t('Warning'),
        'info' => t('Info'),
      ],
    ];
    $form['message']['message_message'] = [
      '#type' => 'yamlform_html_editor',
      '#title' => $this->t('Message content'),
    ];
    return $form;
  }

}
