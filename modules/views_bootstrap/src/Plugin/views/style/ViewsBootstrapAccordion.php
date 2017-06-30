<?php

/**
 * @file
 * Definition of Drupal\views_bootstrap\Plugin\views\style\ViewsBootstrapAccordion.
 */

namespace Drupal\views_bootstrap\Plugin\views\style;

use Drupal\Core\Form\FormStateInterface;
use Drupal\views\Plugin\views\style\StylePluginBase;

/**
 * Style plugin to render each item as a row in a Bootstrap Accordion.
 *
 * @ingroup views_style_plugins
 *
 * @ViewsStyle(
 *   id = "views_bootstrap_accordion",
 *   title = @Translation("Bootstrap Accordion"),
 *   help = @Translation("Displays rows in a Bootstrap Accordion."),
 *   theme = "views_bootstrap_accordion",
 *   display_types = {"normal"}
 * )
 */
class ViewsBootstrapAccordion extends StylePluginBase {
  /**
   * Does the style plugin for itself support to add fields to it's output.
   *
   * @var bool
   */
  protected $usesFields = TRUE;

  /**
   * Does the style plugin allows to use style plugins.
   *
   * @var bool
   */
  protected $usesRowPlugin = TRUE;

  /**
   * Definition.
   */
  protected function defineOptions() {
    $options = parent::defineOptions();
    
    $options['title_field'] = array('default' => array());

    return $options;
  }

  /**
   * Render the given style.
   */
  public function buildOptionsForm(&$form, FormStateInterface $form_state) {
    parent::buildOptionsForm($form, $form_state);
    
    $form['title_field'] = array(
      '#type' => 'select',
      '#title' => $this->t('Title field'),
      '#options' => $this->displayHandler->getFieldLabels(TRUE),
      '#required' => TRUE,
      '#default_value' => $this->options['title_field'],
      '#description' => $this->t('Select the field that will be used as the title.'),
    );
  }
}
