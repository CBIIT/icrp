<?php

namespace Drupal\feeds\Feeds\Target;

use Drupal\Component\Utility\Html;
use Drupal\Core\Entity\EntityManagerInterface;
use Drupal\Core\Entity\Query\QueryFactory;
use Drupal\Core\Field\FieldDefinitionInterface;
use Drupal\Core\Form\FormStateInterface;
use Drupal\feeds\Exception\EmptyFeedException;
use Drupal\feeds\FieldTargetDefinition;
use Drupal\feeds\Plugin\Type\Target\ConfigurableTargetInterface;
use Drupal\feeds\Plugin\Type\Target\FieldTargetBase;

/**
 * Defines an entity reference mapper.
 *
 * @FeedsTarget(
 *   id = "entity_reference",
 *   field_types = {"entity_reference"},
 *   arguments = {"@entity.manager", "@entity.query"}
 * )
 */
class EntityReference extends FieldTargetBase implements ConfigurableTargetInterface {

  /**
   * The entity manager.
   *
   * @var \Drupal\Core\Entity\EntityManagerInterface
   */
  protected $entityManager;

  /**
   * The entity query factory object.
   *
   * @var \Drupal\Core\Entity\Query\QueryFactory
   */
  protected $queryFactory;

  /**
   * Constructs an EntityReference object.
   *
   * @param array $configuration
   *   The plugin configuration.
   * @param string $plugin_id
   *   The plugin id.
   * @param array $plugin_definition
   *   The plugin definition.
   * @param \Drupal\Core\Entity\EntityManagerInterface $entity_manager
   *   The entity manager.
   * @param \Drupal\Core\Entity\Query\QueryFactory $query_factory
   *   The entity query factory.
   */
  public function __construct(array $configuration, $plugin_id, array $plugin_definition, EntityManagerInterface $entity_manager, QueryFactory $query_factory) {
    $this->entityManager = $entity_manager;
    $this->queryFactory = $query_factory;
    parent::__construct($configuration, $plugin_id, $plugin_definition);
  }

  /**
   * {@inheritdoc}
   */
  protected static function prepareTarget(FieldDefinitionInterface $field_definition) {
    // Only reference content entities. Configuration entities will need custom
    // targets.
    $type = $field_definition->getSetting('target_type');
    if (!\Drupal::entityManager()->getDefinition($type)->isSubclassOf('\Drupal\Core\Entity\ContentEntityInterface')) {
      return;
    }

    return FieldTargetDefinition::createFromFieldDefinition($field_definition)
      ->addProperty('target_id');
  }

  protected function getPotentialFields() {
    $field_definitions = $this->entityManager->getBaseFieldDefinitions($this->getEntityType());
    $field_definitions = array_filter($field_definitions, [$this, 'filterFieldTypes']);
    $options = [];
    foreach ($field_definitions as $id => $definition) {
      $options[$id] = Html::escape($definition->getLabel());
    }

    return $options;
  }

  protected function filterFieldTypes($field) {
    if ($field->isComputed()) {
      return FALSE;
    }

    switch ($field->getType()) {
      case 'string':
      case 'text_long':
      case 'path':
      case 'uuid':
        return TRUE;

      default:
        return FALSE;
    }
  }

  protected function getEntityType() {
    return $this->settings['target_type'];
  }

  protected function getBundles() {
    return $this->settings['handler_settings']['target_bundles'];
  }

  protected function getBundleKey() {
    return $this->entityManager->getDefinition($this->getEntityType())->getKey('bundle');
  }

  protected function getLabelKey() {
    return $this->entityManager->getDefinition($this->getEntityType())->getKey('label');
  }

  /**
   * {@inheritdoc}
   */
  protected function prepareValue($delta, array &$values) {
    if ($target_id = $this->findEntity($values['target_id'], $this->configuration['reference_by'])) {
      $values['target_id'] = $target_id;
      return;
    }

    throw new EmptyFeedException();
  }

  /**
   * Searches for an entity by entity key.
   *
   * @param string $value
   *   The value to search for.
   *
   * @return int|bool
   *   The entity id, or false, if not found.
   */
  protected function findEntity($value, $field) {
    $query = $this->queryFactory->get($this->getEntityType());

    if ($bundles = $this->getBundles()) {
      $query->condition($this->getBundleKey(), $bundles, 'IN');
    }

    $ids = array_filter($query->condition($field, $value)->range(0, 1)->execute());
    if ($ids) {
      return reset($ids);
    }

    if ($this->configuration['autocreate'] && $this->configuration['reference_by'] === $this->getLabelKey()) {
      return $this->createEntity($value);
    }

    return FALSE;
  }

  protected function createEntity($value) {
    if (!strlen(trim($value))) {
      return FALSE;
    }

    $bundles = $this->getBundles();

    $entity = $this->entityManager->getStorage($this->getEntityType())->create([
      $this->getLabelKey() => $value,
      $this->getBundleKey() => reset($bundles),
    ]);
    $entity->save();

    return $entity->id();
  }

  /**
   * {@inheritdoc}
   */
  public function defaultConfiguration() {
    return [
      'reference_by' => $this->getLabelKey(),
      'autocreate' => FALSE,
    ];
  }

  /**
   * {@inheritdoc}
   */
  public function buildConfigurationForm(array $form, FormStateInterface $form_state) {
    $options = $this->getPotentialFields();

    // Hack to find out the target delta.
    foreach ($form_state->getValues() as $key => $value) {
      if (strpos($key, 'target-settings-') === 0) {
        list(, , $delta) = explode('-', $key);
        break;
      }
    }

    $form['reference_by'] = [
      '#type' => 'select',
      '#title' => $this->t('Reference by'),
      '#options' => $options,
      '#default_value' => $this->configuration['reference_by'],
    ];

    $form['autocreate'] = [
      '#type' => 'checkbox',
      '#title' => $this->t('Autocreate entity'),
      '#default_value' => $this->configuration['autocreate'],
      '#states' => [
        'visible' => [
          ':input[name="mappings[' . $delta . '][settings][reference_by]"]' => [
            'value' => $this->getLabelKey(),
          ],
        ],
      ],
    ];

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function getSummary() {
    $options = $this->getPotentialFields();

    $summary = [];

    if ($this->configuration['reference_by'] && isset($options[$this->configuration['reference_by']])) {
      $summary[] = $this->t('Reference by: %message', ['%message' => $options[$this->configuration['reference_by']]]);
    }
    else {
      $summary[] = $this->t('Please select a field to reference by.');
    }

    if ($this->configuration['reference_by'] === $this->getLabelKey()) {
      $create = $this->configuration['autocreate'] ? $this->t('Yes') : $this->t('No');
      $summary[] = $this->t('Autocreate terms: %create', ['%create' => $create]);
    }

    return implode('<br>', $summary);
  }

}
