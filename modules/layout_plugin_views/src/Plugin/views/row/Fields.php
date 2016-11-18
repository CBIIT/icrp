<?php

/**
 * @file
 * Contains \Drupal\panels\Plugin\views\row\Fields.
 */

namespace Drupal\layout_plugin_views\Plugin\views\row;

use Drupal\Component\Render\MarkupInterface;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Render\RenderContext;
use Drupal\layout_plugin\Plugin\Layout\LayoutPluginManagerInterface;
use Drupal\layout_plugin_views\Exceptions\NoMarkupGeneratedException;
use Drupal\layout_plugin_views\FieldsPluginOptions;
use Drupal\layout_plugin_views\RegionMap;
use Drupal\views\ResultRow;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * The layout_plugin_views 'fields' row plugin
 *
 * This displays fields in a panel.
 *
 * @ingroup views_row_plugins
 *
 * @ViewsRow(
 *   id = "layout_plugin_views_fields",
 *   title = @Translation("Layout fields"),
 *   help = @Translation("Displays the fields in a layout rather than using a simple row template."),
 *   theme = "views_view_fields",
 *   display_types = {"normal"}
 * )
 */
class Fields extends \Drupal\views\Plugin\views\row\Fields {
  /**
   * @var \Drupal\layout_plugin_views\RegionMap
   */
  private $regionMap;

  /**
   * @var \Drupal\layout_plugin\Plugin\Layout\LayoutPluginManagerInterface
   */
  private $layoutPluginManager;

  /**
   * @var \Drupal\layout_plugin_views\FieldsPluginOptions
   */
  private $pluginOptions;

  /**
   * {@inheritdoc}
   */
  public function __construct(array $configuration, $plugin_id, $plugin_definition, LayoutPluginManagerInterface $layout_plugin_manager) {
    parent::__construct($configuration, $plugin_id, $plugin_definition);
    $this->layoutPluginManager = $layout_plugin_manager;
    $this->pluginOptions = FieldsPluginOptions::fromFieldsPlugin($layout_plugin_manager, $this);
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container, array $configuration, $plugin_id, $plugin_definition) {
    return new static($configuration, $plugin_id, $plugin_definition, $container->get('plugin.manager.layout_plugin'));
  }

  /**
   * {@inheritdoc}
   */
  protected function defineOptions() {
    $options = parent::defineOptions();

    $options['layout']['default'] = '';
    $options['default_region']['default'] = '';

    $options['assigned_regions']['default'] = [];

    return $options;
  }

  /**
   * {@inheritdoc}
   */
  public function buildOptionsForm(&$form, FormStateInterface $form_state) {
    parent::buildOptionsForm($form, $form_state);

    if ($this->pluginOptions->hasValidSelectedLayout()) {
      $layout_definition = $this->pluginOptions->getSelectedLayoutDefinition();
    }
    elseif ($this->pluginOptions->layoutFallbackIsPossible()) {
      $layout_definition = $this->pluginOptions->getFallbackLayoutDefinition();
    }

    if (!empty($layout_definition)) {
      $form['layout'] = [
        '#type' => 'select',
        '#title' => $this->t('Panel layout'),
        '#options' => $this->layoutPluginManager->getLayoutOptions(['group_by_category' => TRUE]),
        '#default_value' => $layout_definition['id'],
      ];

      $form['default_region'] = [
        '#type' => 'select',
        '#title' => $this->t('Default region'),
        '#description' => $this->t('Defines the region in which the fields will be rendered by default.'),
        '#options' => $layout_definition['region_names'],
        '#default_value' => $this->pluginOptions->getDefaultRegion(),
      ];

      $form['assigned_regions'] = [
        '#type' => 'fieldset',
        '#title' => $this->t('Assign regions'),
        '#description' => $this->t('You can use the dropdown menus above to select a region for each field to be rendered in.'),
      ];

      foreach ($this->displayHandler->getFieldLabels() as $field_name => $field_label) {
        $form['assigned_regions'][$field_name] = [
          '#type' => 'select',
          '#options' => $layout_definition['region_names'],
          '#title' => $field_label,
          '#default_value' => $this->pluginOptions->getAssignedRegion($field_name),
          '#empty_option' => $this->t('Default region'),
        ];
      }
    }
  }

  /**
   * {@inheritdoc}
   */
  public function render($row) {
    /** @var \Drupal\views\ResultRow $row */
    $build = $this->renderFieldsIntoRegions($row);
    return $this->buildLayoutRenderArray($build);
  }

  /**
   * Renders the row's fields into the regions specified in the region map.
   *
   * @param \Drupal\views\ResultRow $row
   *
   * @return \Drupal\Component\Render\MarkupInterface[]
   *   An array of MarkupInterface objects keyed by region machine name.
   */
  protected function renderFieldsIntoRegions(ResultRow $row) {
    $build = [];
    foreach ($this->getRegionMap()->getNonEmptyRegionNames() as $region_name) {
      try {
        $build[$region_name]['#markup'] = $this->renderFields($row, $this->getRegionMap()->getFieldsForRegion($region_name));
      }
      catch (NoMarkupGeneratedException $e) {
        // Even though we only try to render regions that actually contain
        // fields, it is still possible that those fields are empty. We don't
        // want to render empty regions, so we do nothing.
      }
    }

    return $build;
  }

  /**
   * Renders the fields.
   *
   * @param \Drupal\views\ResultRow $row
   * @param \Drupal\views\Plugin\views\field\FieldPluginBase[] $fieldsToRender
   *
   * @return \Drupal\Component\Render\MarkupInterface
   *
   * @throws NoMarkupGeneratedException
   */
  protected function renderFields(ResultRow $row, array $fieldsToRender) {
    // We have to override the available fields for rendering so we create a
    // backup of the original fields.
    $original_fields = $this->getViewFieldDefinitions();
    $this->setViewFieldDefinitions($fieldsToRender);

    // We can not just return a render array with a clone of a filtered view
    // because views assigns the view object just before rendering, which
    // results in all fields being rendered in each region.
    // We therefore have to force rendering outside of the render context of
    // this request.
    $renderer = $this->getRenderer();
    $markup = $renderer->executeInRenderContext(new RenderContext(), function () use ($row, $renderer) {
      // @codeCoverageIgnoreStart
      // We can never reach this code in our unit tests because we mocked out
      // the renderer. These two methods are however defined and tested by core.
      // There is no need for them to be tested by our unit tests.
      $render_array = parent::render($row);
      return $renderer->render($render_array);
      // @codeCoverageIgnoreEnd
    });

    // Restore the original fields.
    $this->setViewFieldDefinitions($original_fields);

    if (empty($markup)) {
      throw new NoMarkupGeneratedException();
    }
    return $markup;
  }

  /**
   * Retrieves the field property of the view.
   *
   * @return \Drupal\views\Plugin\views\field\FieldPluginBase[]
   */
  protected function getViewFieldDefinitions() {
    return $this->view->field;
  }

  /**
   * Sets the field property of the view.
   *
   * @param \Drupal\views\Plugin\views\field\FieldPluginBase[] $fieldDefinitions
   */
  protected function setViewFieldDefinitions(array $fieldDefinitions) {
    $this->view->field = $fieldDefinitions;
  }

  /**
   * @return \Drupal\layout_plugin_views\RegionMap
   */
  private function getRegionMap() {
    if (empty($this->regionMap)) {
      $this->regionMap = new RegionMap($this, $this->pluginOptions);
    }

    return $this->regionMap;
  }

  /**
   * Builds a renderable array for the selected layout.
   *
   * @param MarkupInterface[] $rendered_regions
   *  An array of MarkupInterface objects keyed by the machine name of the
   *  region they should be rendered in. @see ::renderFieldsIntoRegions.
   *
   * @return array
   *  Renderable array for the selected layout.
   */
  protected function buildLayoutRenderArray(array $rendered_regions) {
    if (!empty($rendered_regions)) {
      /** @var \Drupal\layout_plugin\Plugin\Layout\LayoutInterface $layout */
      $layout = $this->layoutPluginManager->createInstance($this->pluginOptions->getLayout(), []);
      return $layout->build($rendered_regions);
    }
    return $rendered_regions;
  }

}
