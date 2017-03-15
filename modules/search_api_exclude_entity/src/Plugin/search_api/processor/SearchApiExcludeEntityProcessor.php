<?php

/**
 * @file
 * Contains Drupal\search_api_exclude_entity\Plugin\search_api\processor\SearchApiExcludeEntityProcessor.
 */

namespace Drupal\search_api_exclude_entity\Plugin\search_api\processor;

use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Plugin\PluginFormInterface;
use Drupal\search_api\Plugin\PluginFormTrait;
use Drupal\search_api\Processor\ProcessorPluginBase;


/**
 * @SearchApiProcessor(
 *   id = "search_api_exclude_entity_processor",
 *   label = @Translation("Search API Exclude Entity"),
 *   description = @Translation("Exclude entities from being indexed if they are excluded by 'Search API Exclude' module."),
 *   stages = {
 *     "alter_items" = -50
 *   }
 * )
 */
class SearchApiExcludeEntityProcessor extends ProcessorPluginBase implements PluginFormInterface {

  use PluginFormTrait;

  /**
   * {@inheritdoc}
   */
  public function defaultConfiguration() {
    return array(
      'fields' => array(),
    );
  }

  /**
   * {@inheritdoc}
   */
  public function buildConfigurationForm(array $form, FormStateInterface $form_state) {
    $fields_config = $this->getConfiguration()['fields'];

    foreach ($this->index->getDatasources() as $datasource_id => $datasource) {
      $datasource_id_expl = explode(':', $datasource_id);
      $entity_type = next($datasource_id_expl);

      $form['fields'][$entity_type] = array(
        '#type' => 'checkboxes',
        '#title' => $this->t('Fields entity type: %type', array('%type' => $datasource->label())),
        '#description' => $this->t('Choose the Search API Exclude fields that should be used to exclude entities in this index.'),
        '#default_value' => isset($fields_config[$entity_type]) ? $fields_config[$entity_type] : array(),
        '#options' => $this->getFieldOptions($entity_type, $datasource),
        '#multiple' => TRUE,
      );
    }

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function submitConfigurationForm(array &$form, FormStateInterface $form_state) {
    $values = $form_state->getValues();

    // Remove non selected values.
    if (isset($values['fields']) && is_array($values['fields'])) {
      foreach ($values['fields'] as $entity => $field) {
        $values['fields'][$entity] = array_values(array_filter($field));
      }
    }

    $this->setConfiguration($values);
  }

  /**
   * Find and return entity bundles enabled on the active index.
   *
   * @param string $entity_type
   *   The entity type we are finding bundles for.
   *
   * @param object $datasource
   *   The data source from the active index.
   *
   * @return array
   *   Options array with bundles.
   */
  private function getFieldOptions($entity_type, $datasource) {
    $entity_manager = \Drupal::service('entity_field.manager');
    $field_map = $entity_manager->getFieldMapByFieldType('search_api_exclude_entity');
    $bundles = $datasource->getBundles();

    $options = array();

    if (isset($field_map[$entity_type])) {
      foreach ($field_map[$entity_type] as $field_id => $field) {
        $bundles_filtered = array();
        foreach ($field['bundles'] as $field_bundle) {
          if (isset($bundles[$field_bundle])) {
            $bundles_filtered[] = $field_bundle;
          }
        }

        if (count($bundles_filtered) > 0) {
          $options[$field_id] = $field_id . ' (' . implode(', ', $bundles_filtered) . ')';
        }
      }
    }

    return $options;
  }

  /**
   * Checking if a specific entity bundle has a specific field.
   *
   * @param string $entity_type
   *   Entity type we are using in the field check.
   *
   * @param string $bundle
   *   Bundle we are using in the field check.
   *
   * @param string $field
   *   The field we are checking if it is being used by the bundle.
   *
   * @return array
   *   Options array with bundles.
   */
  private function bundleHasField($entity_type, $bundle, $field) {
    static $field_map;

    if (!isset($field_map)) {
      $entity_manager = \Drupal::service('entity_field.manager');
      $field_map = $entity_manager->getFieldMapByFieldType('search_api_exclude_entity');
    }

    if (isset($field_map[$entity_type][$field]['bundles'][$bundle])) {
      return TRUE;
    }
    else  {
      return FALSE;
    }
  }

  /**
   * {@inheritdoc}
   */
  public function alterIndexedItems(array &$items) {
    $config = $this->getConfiguration()['fields'];

    // Annoyingly, this doc comment is needed for PHPStorm. See
    // http://youtrack.jetbrains.com/issue/WI-23586
    /** @var \Drupal\search_api\Item\ItemInterface $item */
    foreach ($items as $item_id => $item) {
      $object = $item->getOriginalObject()->getValue();
      $entity_type_id = $object->getEntityTypeId();
      $bundle = $object->bundle();

      if (isset($config[$entity_type_id]) && is_array($config[$entity_type_id])) {
        foreach ($config[$entity_type_id] as $field) {

          // We need to be sure that the field actually exists
          // on the bundle before getting the value to avoid
          // InvalidArgumentException exceptions.
          if ($this->bundleHasField($entity_type_id, $bundle, $field)) {
            if (NULL !== $object->get($field)->getValue()[0]['value']) {
              $value = $object->get($field)->getValue()[0]['value'];
              if ($value) {
                unset($items[$item_id]);
                continue;
              }
            }
          }
        }
      }
    }
  }
}
