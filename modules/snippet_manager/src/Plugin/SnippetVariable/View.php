<?php

namespace Drupal\snippet_manager\Plugin\SnippetVariable;

use Drupal\Core\Entity\EntityTypeManagerInterface;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Plugin\ContainerFactoryPluginInterface;
use Drupal\Core\Url;
use Drupal\snippet_manager\SnippetVariableBase;
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
class View extends SnippetVariableBase implements ContainerFactoryPluginInterface {

  /**
   * The entity type manager service.
   *
   * @var \Drupal\Core\Entity\EntityTypeManagerInterface
   */
  protected $entityTypeManager;

  /**
   * Constructs View variable object.
   *
   * @param array $configuration
   *   A configuration array containing information about the plugin instance.
   * @param string $plugin_id
   *   The plugin_id for the plugin instance.
   * @param mixed $plugin_definition
   *   The plugin implementation definition.
   * @param \Drupal\Core\Entity\EntityTypeManagerInterface $entity_type_manager
   *   The entity manager service.
   */
  public function __construct(array $configuration, $plugin_id, $plugin_definition, EntityTypeManagerInterface $entity_type_manager) {
    parent::__construct($configuration, $plugin_id, $plugin_definition);
    $this->entityTypeManager = $entity_type_manager;
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

    $view = $this->getView();

    $displays = $view->get('display');
    $options = [];
    foreach ($displays as $display) {
      $options[$display['id']] = $display['display_title'];
    }

    $form['display'] = [
      '#title' => $this->t('Display'),
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
  public function build() {

    $view = $this->getView()->getExecutable();

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
  public function getOperations() {
    $links = parent::getOperations();

    $view = $this->getView();

    // Check implicitly if Views UI module is enabled.
    if ($view && $view->hasLinkTemplate('edit-form')) {
      $options = [
        'view' => $this->getDerivativeId(),
        'display_id' => $this->configuration['display'],
      ];
      $url = Url::fromRoute('entity.view.edit_display_form', $options);
      $links['edit_view'] = [
        'title' => $this->t('Edit view'),
        'url' => $url,
      ];

    }

    return $links;
  }

  /**
   * {@inheritdoc}
   */
  public function defaultConfiguration() {
    return [
      'display' => 'default',
    ];
  }

  /**
   * {@inheritdoc}
   */
  public function calculateDependencies() {
    return ['module' => 'views'];
  }

  /**
   * Return the associated view entity.
   *
   * @return \Drupal\views\ViewEntityInterface
   *   View configuration entity.
   */
  protected function getView() {
    return $this->entityTypeManager
      ->getStorage('view')
      ->load($this->getDerivativeId());
  }

}
