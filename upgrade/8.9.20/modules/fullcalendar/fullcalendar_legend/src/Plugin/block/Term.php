<?php

/**
 * @file
 * Contains \Drupal\fullcalendar_legend\Plugin\Block\Term.
 */

namespace Drupal\fullcalendar_legend\Plugin\Block;

use Drupal\Core\Entity\EntityFieldManagerInterface;
use Drupal\Core\Entity\EntityManagerInterface;
use Drupal\Core\Entity\Query\QueryFactory;
use Drupal\Core\Entity\EntityTypeManagerInterface;
use Drupal\Core\Plugin\ContainerFactoryPluginInterface;
use Drupal\taxonomy\TermStorageInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * TODO
 *
 * @Plugin(
 *   id = "fullcalendar_legend_term",
 *   subject = @Translation("Fullcalendar Legend: Term"),
 *   module = "fullcalendar_legend"
 * )
 */
class Term extends FullcalendarLegendBase implements ContainerFactoryPluginInterface {

  /**
   * @var \Drupal\taxonomy\TermStorageInterface
   */
  protected $termStorage;

  /**
   * @var \Drupal\Core\Entity\Query\QueryFactory
   */
  protected $entityQuery;

  /**
   * @var \Drupal\Core\Entity\EntityTypeManagerInterface
   */
  protected $entityTypeManager;

  /**
   * {@inheritdoc}
   */
  public function __construct(array $configuration, $plugin_id, array $plugin_definition, EntityTypeManagerInterface $entity_type_manager, EntityFieldManagerInterface $entity_field_manager) {
    parent::__construct($configuration, $plugin_id, $plugin_definition);

    $this->termStorage = $entity_type_manager->getStorage('taxonomy_term');
    $this->entityTypeManager = $entity_type_manager;
    $this->entityFieldManager = $entity_field_manager;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container, array $configuration, $plugin_id, $plugin_definition) {
    return new static(
      $configuration,
      $plugin_id,
      $plugin_definition,
      $container->get('entity_type.manager'),
      $container->get('entity_field.manager')
    );
  }

  /**
   * {@inheritdoc}
   */
  protected function buildLegend(array $fields) {
    $types = [];

    /** @var \Drupal\Core\Field\FieldDefinitionInterface[] $fields */
    foreach ($fields as $field_name => $field) {
      // Then by entity type.
      foreach ($field->getBundles() as $entity_type => $bundles) {
        foreach ($bundles as $bundle) {
          foreach ($this->entityFieldManager->getFieldDefinitions($entity_type, $bundle) as $taxonomy_field_name => $taxonomy_field) {
            if ($taxonomy_field->getType() != 'taxonomy_term_reference') {
              continue;
            }

            foreach ($taxonomy_field->getSetting('allowed_values') as $vocab) {
              foreach ($this->termStorage->load($vocab) as $term) {
                $types[$term->id()] = [
                  'entity_type'    => $entity_type,
                  'field_name'     => $field_name,
                  'bundle'         => $bundle,
                  'label'          => $term->label(),
                  'taxonomy_field' => $taxonomy_field_name,
                  'tid'            => $term->id(),
                ];
              }
            }
          }
        }
      }
    }

    return $types;
  }

}
