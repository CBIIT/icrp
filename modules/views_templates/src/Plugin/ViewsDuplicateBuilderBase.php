<?php
/**
 * @file
 * Contains \Drupal\views_templates\Plugin\ViewsDuplicateBuilder.
 */


namespace Drupal\views_templates\Plugin;


use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Plugin\ContainerFactoryPluginInterface;
use Drupal\views\Entity\View;
use Drupal\views_templates\ViewsTemplateLoaderInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Symfony\Component\HttpFoundation\File\Exception\FileNotFoundException;

abstract class ViewsDuplicateBuilderBase extends ViewsBuilderBase implements ViewsDuplicateBuilderPluginInterface, ContainerFactoryPluginInterface {

  /** @var \Drupal\views_templates\ViewsTemplateLoaderInterface $template_loader */
  protected $template_loader;

  protected $loaded_template;

  public function __construct(array $configuration, $plugin_id, $plugin_definition, ViewsTemplateLoaderInterface $loader) {
    parent::__construct($configuration, $plugin_id, $plugin_definition);
    $this->template_loader = $loader;

  }


  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container, array $configuration, $plugin_id, $plugin_definition) {
    return new static(
      $configuration,
      $plugin_id,
      $plugin_definition,
      $container->get('views_templates.loader')
    );
  }

  /**
   * {@inheritdoc}
   */
  public function createView($options = NULL) {
    if ($view_template = $this->loadTemplate($options)) {
      $view_template['id'] = $options['id'];
      $view_template['label'] = $options['label'];
      $view_template['description'] = $options['description'];
      return View::create($view_template);
    }
    return NULL;

  }


  /**
   * {@inheritdoc}
   */
  public function getViewTemplateId() {
    return $this->getDefinitionValue('view_template_id');
  }

  /**
   * {@inheritdoc}
   */
  public function buildConfigurationForm($form, FormStateInterface $form_state) {
    return [];
  }

  /**
   * {@inheritdoc}
   */
  public function getAdminLabel() {
    return $this->loadViewsTemplateValue('label');
  }

  /**
   * {@inheritdoc}
   */
  public function getDescription() {
    return $this->loadViewsTemplateValue('description');
  }

  /**
   * Return value from template.
   *
   * @param $key
   *
   * @param null $options
   *
   * @return mixed|null
   */
  protected function loadViewsTemplateValue($key, $options = NULL) {
    $view_template = $this->loadTemplate($options);
    if (isset($view_template[$key])) {
      return $view_template[$key];
    }
    return NULL;
  }

  /**
   * Load template from service.
   *
   * @param $options
   *
   * @return object
   */
  protected function loadTemplate($options) {
    if (empty($this->loaded_template)) {
      try {
        $template = $this->template_loader->load($this);
      } catch (FileNotFoundException $e) {
        watchdog_exception('views_templates', $e, $e->getMessage());
        return NULL;
      }

      $this->alterViewTemplateAfterCreation($template, $options);
      $this->loaded_template = $template;
    }

    return $this->loaded_template;
  }

  /**
   * After View Template has been created the Builder should alter it some how.
   *
   * @param array $view_template
   *
   * @param array $options
   *  Options for altering
   */
  protected function alterViewTemplateAfterCreation(array &$view_template, $options = NULL) {
    if ($replacements = $this->getReplacements($options)) {
      $this->replaceTemplateKeyAndValues($view_template, $replacements, $options);
    }
  }

  /**
   * Get the replaces array from the plugin definition.
   *
   * The keys will be converted to work with yml files.
   *
   * @param $options
   *
   * @return array
   */
  protected function getReplacements($options) {
    if ($replacements = $this->getDefinitionValue('replacements')) {
      $converted_replacements = [];
      foreach ($replacements as $key => $value) {
        $new_key = '__' . strtoupper($key);
        $converted_replacements[$new_key] = $value;
      }
      return $converted_replacements;
    }
    return [];
  }

  /**
   * Recursively replace keys and values in template elements.
   *
   * For example of builder and yml template:
   *
   * @see Drupal\views_templates_builder_test\Plugin\ViewsTemplateBuilder
   *
   * @param array $template_elements
   *  Array of elements from a View Template array
   * @param array $replace_values
   *  The values in that should be replaced in the template.
   *  The keys in this array can be keys OR values template array.
   *  This allows replacing both keys and values in the template.
   * @param null $options
   */
  protected function replaceTemplateKeyAndValues(array &$template_elements, array $replace_values, $options = NULL) {
    foreach ($template_elements as $key => &$value) {
      if (is_array($value)) {
        $this->replaceTemplateKeyAndValues($value, $replace_values, $options);
      }
      foreach ($replace_values as $replace_key => $replace_value) {
        if (!is_array($value)) {
          if (is_string($value)) {
            if (stripos($value, $replace_key) !== FALSE) {
              $value = str_replace($replace_key, $replace_value, $value);
            }
          }
          elseif ($replace_key === $value) {
            $value = $replace_value;
          }
        }
        if (stripos($key, $replace_key) !== FALSE) {
          $new_key = str_replace($replace_key, $replace_value, $key);
          // NULL is used in replace value to remove keys from template.
          if ($replace_value !== NULL) {
            $template_elements[$new_key] = $value;
          }
          unset($template_elements[$key]);
        }
      }
    }
  }

  /**
   * Check if template exists
   *
   * @return bool
   */
  public function templateExists() {
    return $this->loadTemplate([]) ? TRUE : FALSE;
  }

}
