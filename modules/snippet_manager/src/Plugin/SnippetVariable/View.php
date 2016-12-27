<?php

namespace Drupal\snippet_manager\Plugin\SnippetVariable;

use Drupal\Core\Entity\EntityTypeManagerInterface;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Plugin\ContainerFactoryPluginInterface;
use Drupal\snippet_manager\SnippetVariableBase;
use Drupal\snippet_manager\SnippetVariableInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * Provides View variable type.
 *
 * @SnippetVariable(
 *   id = "view",
 *   title = @Translation("View"),
 *   category = @Translation("View"),
 *   deriver = "\Drupal\snippet_manager\Plugin\SnippetVariable\ViewDeriver",
 * )
 */
class View extends SnippetVariableBase implements SnippetVariableInterface, ContainerFactoryPluginInterface {

  /**
   * The entity type manager service.
   *
   * @var \Drupal\Core\Entity\EntityTypeManagerInterface
   */
  protected $entityTypeManager;

  /**
   * The ID of the view.
   *
   * @var string
   */
  protected $viewId;

  /**
   * Constructs View variable object.
   *
   * @param \Drupal\Core\Entity\EntityTypeManagerInterface $entity_type_manager
   *   The entity manager service.
   */
  public function __construct(array $configuration, $plugin_id, $plugin_definition, EntityTypeManagerInterface $entity_type_manager) {
    parent::__construct($configuration, $plugin_id, $plugin_definition);
    $this->entityTypeManager = $entity_type_manager;
    $this->viewId = $this->getDerivativeId();
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container, array $configuration, $plugin_id, $plugin_definition) {
    return new static(
      $configuration,
      $plugin_id,
      $plugin_definition,
      $container->get('entity_type.manager')
    );
  }

  /**
   * {@inheritdoc}
   */
  public function buildConfigurationForm(array $form, FormStateInterface $form_state) {

    /** @var \Drupal\views\Entity\View $view */
    $view = $this->entityTypeManager->getStorage('view')->load($this->viewId);

    $displays = $view->get('display');
    $options = [];
    foreach ($displays as $display) {
      $options[$display['id']] = $display['display_title'];
    }

    $form['display'] = [
      '#title' => t('Display'),
      '#type' => 'select',
      '#options' => $options,
      '#default_value' => $this->configuration['display'],
      '#required' => TRUE,
    ];

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function getContent() {

    /** @var \Drupal\views\ViewExecutable $view */
    $view = $this->entityTypeManager->getStorage('view')->load($this->viewId)->getExecutable();

    $display = $this->configuration['display'];

    if (!$view || !$view->access($display)) {
      return FALSE;
    }

    $output = $view->preview($display);
    return $output;
  }

  /**
   * {@inheritdoc}
   */
  public function defaultConfiguration() {
    return [
      'display' => NULL,
    ];
  }

}
