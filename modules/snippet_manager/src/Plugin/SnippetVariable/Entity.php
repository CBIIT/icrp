<?php

namespace Drupal\snippet_manager\Plugin\SnippetVariable;

use Drupal\Core\Entity\EntityDisplayRepositoryInterface;
use Drupal\Core\Entity\EntityTypeManagerInterface;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Logger\LoggerChannelInterface;
use Drupal\Core\Plugin\ContainerFactoryPluginInterface;
use Drupal\snippet_manager\SnippetVariableBase;
use Drupal\snippet_manager\SnippetVariableInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Drupal\Core\Routing\RouteMatchInterface;

/**
 * Provides Entity variable type.
 *
 * @SnippetVariable(
 *   id = "entity",
 *   title = @Translation("Entity"),
 *   category = @Translation("Entity"),
 *   deriver = "\Drupal\snippet_manager\Plugin\SnippetVariable\EntityDeriver",
 * )
 */
class Entity extends SnippetVariableBase implements SnippetVariableInterface, ContainerFactoryPluginInterface {

  /**
   * Entity type manager.
   *
   * @var \Drupal\Core\Entity\EntityTypeManagerInterface
   */
  protected $entityTypeManager;

  /**
   * The entity type.
   *
   * @var string
   */
  protected $entityType;

  /**
   * The entity display repository.
   *
   * @var \Drupal\Core\Entity\EntityDisplayRepositoryInterface
   */
  protected $entityDisplayRepository;

  /**
   * The logger channel.
   *
   * @var \Drupal\Core\Logger\LoggerChannelInterface
   */
  protected $logger;

  /**
   * The currently active route match object.
   *
   * @var \Drupal\Core\Routing\RouteMatchInterface
   */
  protected $routeMatch;

  /**
   * Constructs entity variable object.
   *
   * @param array $configuration
   *   The plugin configuration, i.e. an array with configuration values keyed
   *   by configuration option name. The special key 'context' may be used to
   *   initialize the defined contexts by setting it to an array of context
   *   values keyed by context names.
   * @param string $plugin_id
   *   The plugin_id for the plugin instance.
   * @param mixed $plugin_definition
   *   The plugin implementation definition.
   * @param \Drupal\Core\Entity\EntityTypeManagerInterface $entity_type_manager
   *   The entity manager service.
   * @param \Drupal\Core\Entity\EntityDisplayRepositoryInterface $entity_display_repository
   *   The entity display repository.
   * @param \Drupal\Core\Logger\LoggerChannelInterface $logger
   *   The logger channel.
   * @param \Drupal\Core\Routing\RouteMatchInterface $route_match
   *   The route match.
   */
  public function __construct(array $configuration, $plugin_id, $plugin_definition, EntityTypeManagerInterface $entity_type_manager, EntityDisplayRepositoryInterface $entity_display_repository, LoggerChannelInterface $logger, RouteMatchInterface $route_match) {
    parent::__construct($configuration, $plugin_id, $plugin_definition);
    $this->entityTypeManager = $entity_type_manager;
    $this->entityType = $this->getDerivativeId();
    $this->entityDisplayRepository = $entity_display_repository;
    $this->logger = $logger;
    $this->routeMatch = $route_match;
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
      $container->get('entity_display.repository'),
      $container->get('logger.channel.snippet_manager'),
      $container->get('current_route_match')
    );
  }

  /**
   * {@inheritdoc}
   */
  public function buildConfigurationForm(array $form, FormStateInterface $form_state) {

    $entity = NULL;
    if ($this->configuration['entity_id']) {
      $storage = $this->entityTypeManager->getStorage($this->entityType);
      $entity = $storage->load($this->configuration['entity_id']);

      if (!$entity) {
        drupal_set_message(
          t('Could not load entity: #%entity', ['%entity' => $this->configuration['entity_id']]),
          'error'
        );
      }
    }

    $entity_type_label = $this->entityTypeManager
      ->getDefinition($this->entityType)
      ->getLabel();

    $form['entity_id'] = [
      '#type' => 'entity_autocomplete',
      '#title' => $entity_type_label,
      '#default_value' => $entity,
      '#maxlength' => 2048,
      '#target_type' => $this->entityType,
      '#description' => t('Leave the field empty to load the entity dynamically from request.'),
    ];

    $form['view_mode'] = [
      '#type' => 'select',
      '#options' => $this->entityDisplayRepository->getViewModeOptions($this->entityType),
      '#title' => t('View mode'),
      '#default_value' => $this->configuration['view_mode'],
      '#required' => TRUE,
    ];

    return $form;
  }

  /**
   * Loads entity.
   *
   * @return \Drupal\Core\Entity\EntityInterface|null
   *   Loaded entity or null if the entity was not found.
   */
  protected function loadEntity() {

    if ($this->configuration['entity_id']) {
      $entity = $this->entityTypeManager->getStorage($this->entityType)
        ->load($this->configuration['entity_id']);

      if ($entity) {
        return $entity;
      }
      else {
        $this->logger->error(
          'Could not load @entity_type: #@entity_id.',
          [
            '@entity_type' => $this->entityType,
            '@entity_id' => $this->configuration['entity_id'],
          ]
        );
      }
    }
    else {
      $entity = $this->routeMatch->getParameter($this->entityType);
      if (is_object($entity)) {
        return $entity;
      }
    }
  }

  /**
   * {@inheritdoc}
   */
  public function build() {

    if ($entity = $this->loadEntity()) {
      if (!$this->configuration['entity_id']) {
        $entity->addCacheContexts(['url']);
      }

      $build = $this->entityTypeManager
        ->getViewBuilder($this->entityType)
        ->view($entity, $this->configuration['view_mode']);

      return $build;
    }

    // Empty value also needs cache context.
    else {
      return [
        '#cache' => [
          'context' => 'url',
          'max-age' => 0,
        ],
      ];
    }

  }

  /**
   * {@inheritdoc}
   */
  public function getOperations() {
    $links = parent::getOperations();
    $entity = $this->loadEntity();
    if ($entity && $entity->hasLinkTemplate('edit-form')) {
      $label = $entity->getEntityType()->getLowercaseLabel();
      $links['edit_entity'] = [
        'title' => t('Edit @label', ['@label' => $label]),
        'url' => $entity->toUrl('edit-form'),
      ];
    }
    return $links;
  }

  /**
   * {@inheritdoc}
   */
  public function defaultConfiguration() {
    return [
      'entity_id' => NULL,
      'view_mode' => 'default',
    ];
  }

}
