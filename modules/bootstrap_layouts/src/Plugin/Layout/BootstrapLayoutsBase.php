<?php

namespace Drupal\bootstrap_layouts\Plugin\Layout;

use Drupal\Component\Utility\Html;
use Drupal\Component\Utility\NestedArray;
use Drupal\Component\Utility\Xss;
use Drupal\Core\Form\FormStateInterface;
use Drupal\layout_plugin\Plugin\Layout\LayoutBase;

/**
 * Layout class for all bootstrap layouts.
 */
class BootstrapLayoutsBase extends LayoutBase {

  /**
   * {@inheritdoc}
   */
  public function __construct(array $configuration, $plugin_id, $plugin_definition) {
    parent::__construct($configuration, $plugin_id, $plugin_definition);
  }

  /**
   * Provides a default region definition.
   *
   * @return array
   *   Default region array.
   */
  protected function getRegionDefaults() {
    return [
      'wrapper' => 'div',
      'classes' => [],
      'attributes' => '',
      'add_region_classes' => TRUE,
    ];
  }

  /**
   * {@inheritdoc}
   */
  public function defaultConfiguration() {
    $configuration = parent::defaultConfiguration();
    $configuration += [
      'layout' => [
        'wrapper' => 'div',
        'classes' => ['row'],
        'attributes' => '',
        'add_layout_class' => TRUE,
      ],
      'regions' => [],
    ];
    foreach ($this->getRegionDefinitions() as $region => $info) {
      $region_configuration = [];
      foreach (['wrapper', 'classes', 'attributes'] as $key) {
        if (isset($info[$key])) {
          $region_configuration[$key] = $info[$key];
        }
      }
      $configuration['regions'][$region] = $region_configuration + $this->getRegionDefaults();
    }
    return $configuration;
  }

  /**
   * {@inheritdoc}
   */
  public function getConfiguration() {
    $configuration = $this->defaultConfiguration();

    // Can't use parent::getConfiguration() here because array_merge() only
    // merges the top levels. Nor can NestedArray::mergeDeep be used since it
    // will add multiple classes (from default + config). Instead, the two
    // top levels "layout" and "regions" must be merged using array_merge().
    if (isset($this->configuration['layout'])) {
      $configuration['layout'] = array_merge($configuration['layout'], $this->configuration['layout']);
    }
    if (isset($this->configuration['regions'])) {
      $configuration['regions'] = array_merge($configuration['regions'], $this->configuration['regions']);
    }

    // Remove any region configuration that doesn't apply to current layout.
    $regions = $this->getRegionNames();
    foreach (array_keys($configuration['regions']) as $region) {
      if (!isset($regions[$region])) {
        unset($configuration['regions'][$region]);
      }
    }

    return $configuration;
  }

  /**
   * {@inheritdoc}
   */
  public function buildConfigurationForm(array $form, FormStateInterface $form_state) {
    $form = parent::buildConfigurationForm($form, $form_state);
    $configuration = $this->getConfiguration();

    /** @var \Drupal\bootstrap_layouts\BootstrapLayoutsManager $bootstrap_layouts_manager */
    $manager = \Drupal::getContainer()->get('plugin.manager.bootstrap_layouts');
    $classes = $manager->getClassOptions();

    $tokens = FALSE;
    if (\Drupal::moduleHandler()->moduleExists('token')) {
      $tokens = [
        '#title' => $this->t('Tokens'),
        '#type' => 'container',
      ];
      $tokens['help'] = [
        '#theme' => 'token_tree_link',
        '#token_types' => 'all',
        '#global_types' => FALSE,
        '#dialog' => TRUE,
      ];
    }

    // Add wrappers.
    $wrapper_options = [
      'div' => 'Div',
      'span' => 'Span',
      'section' => 'Section',
      'article' => 'Article',
      'header' => 'Header',
      'footer' => 'Footer',
      'aside' => 'Aside',
      'figure' => 'Figure',
    ];

    $form['layout'] = [
      '#type' => 'container',
      '#tree' => TRUE,
    ];

    $form['layout']['wrapper'] = [
      '#type' => 'select',
      '#title' => $this->t('Wrapper'),
      '#options' => $wrapper_options,
      '#default_value' => $form_state->getValue(['layout', 'wrapper'], $configuration['layout']['wrapper']),
    ];

    $form['layout']['classes'] = [
      '#type' => 'select',
      '#title' => $this->t('Classes'),
      '#options' => $classes,
      '#default_value' => $form_state->getValue(['layout', 'classes'], $configuration['layout']['classes']) ?: [],
      '#multiple' => TRUE,
    ];

    $form['layout']['add_layout_class'] = [
      '#type' => 'checkbox',
      '#title' => $this->t('Add layout specific class: <code>@class</code>', ['@class' => Html::cleanCssIdentifier($this->getPluginId())]),
      '#default_value' => (int) $form_state->getValue(['layout', 'add_layout_class'], $configuration['layout']['add_layout_class']),
    ];

    $form['layout']['attributes'] = [
      '#type' => 'textfield',
      '#title' => $this->t('Additional attributes'),
      '#description' => 'E.g. id|custom-id,role|navigation,data-something|some value',
      '#default_value' => $form_state->getValue(['layout', 'attributes'], $configuration['layout']['attributes']),
    ];

    if ($tokens) {
      $form['layout']['tokens'] = $tokens;
    }

    // Add each region's settings.
    foreach ($this->getRegionNames() as $region => $region_label) {
      $default_values = NestedArray::mergeDeep(
        $this->getRegionDefaults(),
        isset($configuration['regions'][$region]) ? $configuration['regions'][$region] : [],
        $form_state->getValue(['regions', $region], [])
      );

      $form[$region] = [
        '#group' => 'additional_settings',
        '#type' => 'details',
        '#open' => TRUE,
        '#title' => $this->t('Region: @region', ['@region' => $region_label]),
        '#weight' => 20,
      ];

      $form[$region]['wrapper'] = [
        '#type' => 'select',
        '#title' => $this->t('Wrapper'),
        '#options' => $wrapper_options,
        '#default_value' => $default_values['wrapper'],
      ];

      $form[$region]['classes'] = [
        '#type' => 'select',
        '#title' => $this->t('Classes'),
        '#options' => $classes,
        '#default_value' => $default_values['classes'],
        '#multiple' => TRUE,
      ];

      $form[$region]['add_region_classes'] = [
        '#type' => 'checkbox',
        '#title' => $this->t('Add region specific classes: <code>bs-region</code> and <code>bs-region--@region</code>', ['@region' => $region]),
        '#default_value' => (int) $default_values['add_region_classes'],
      ];

      $form[$region]['attributes'] = [
        '#type' => 'textfield',
        '#title' => $this->t('Additional attributes'),
        '#description' => 'E.g. id|custom-id,role|navigation,data-something|some value',
        '#default_value' => $default_values['attributes'],
      ];

      if ($tokens) {
        $form[$region]['tokens'] = $tokens;
      }
    }

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function submitConfigurationForm(array &$form, FormStateInterface $form_state) {
    $defaults = $this->getRegionDefaults();
    if ($layout = $form_state->getValue('layout', $defaults)) {
      // Apply Xss::filter to attributes.
      $layout['attributes'] = Xss::filter($layout['attributes']);
      $this->configuration['layout'] = $layout;
    }


    $regions = [];
    foreach (array_keys($this->getRegionNames()) as $name) {
      if ($region = $form_state->getValue($name, $defaults)) {
        // Apply Xss::filter to attributes.
        $region['attributes'] = Xss::filter($region['attributes']);
        $regions[$name] = $region;
      }
    }
    $this->configuration['regions'] = $regions;
  }

}
