<?php

namespace Drupal\snippet_manager\Plugin\SnippetVariable;

use Drupal\Component\Plugin\Exception\ContextException;
use Drupal\Core\Condition\ConditionManager;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Form\SubformState;
use Drupal\Core\Plugin\ContainerFactoryPluginInterface;
use Drupal\Core\Plugin\Context\ContextHandlerInterface;
use Drupal\Core\Plugin\Context\ContextRepositoryInterface;
use Drupal\Core\Plugin\ContextAwarePluginInterface;
use Drupal\snippet_manager\SnippetVariableBase;
use Drupal\snippet_manager\SnippetVariableInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * Provides condition variable type.
 *
 * @codingStandardsIgnoreStart
 * @SnippetVariable(
 *   id = "condition",
 *   title = @Translation("Condition"),
 *   category = @Translation("Condition"),
 *   deriver = "\Drupal\snippet_manager\Plugin\SnippetVariable\ConditionDeriver",
 * )
 * @codingStandardsIgnoreEnd
 */
class Condition extends SnippetVariableBase implements SnippetVariableInterface, ContainerFactoryPluginInterface {

  /**
   * The condition manager.
   *
   * @var \Drupal\Core\Condition\ConditionManager
   */
  protected $conditionManager;

  /**
   * The plugin context handler.
   *
   * @var \Drupal\Core\Plugin\Context\ContextHandlerInterface
   */
  protected $contextHandler;

  /**
   * The context repository.
   *
   * @var \Drupal\Core\Plugin\Context\ContextRepositoryInterface
   */
  protected $contextRepository;

  /**
   * Boolean indicating whether or not the condition context is missing.
   *
   * @var bool
   */
  protected $missingContext;

  /**
   * Constructor.
   *
   * @param \Drupal\Core\Condition\ConditionManager $condition_manager
   *   The condition manager.
   *   The ConditionManager for checking visibility of blocks.
   * @param \Drupal\Core\Plugin\Context\ContextHandlerInterface $context_handler
   *   The ContextHandler for applying contexts to conditions properly.
   * @param \Drupal\Core\Plugin\Context\ContextRepositoryInterface $context_repository
   *   The lazy context repository service.
   */
  public function __construct(array $configuration, $plugin_id, $plugin_definition, ConditionManager $condition_manager, ContextHandlerInterface $context_handler, ContextRepositoryInterface $context_repository) {
    parent::__construct($configuration, $plugin_id, $plugin_definition);
    $this->conditionManager = $condition_manager;
    $this->contextHandler = $context_handler;
    $this->contextRepository = $context_repository;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container, array $configuration, $plugin_id, $plugin_definition) {
    return new static(
      $configuration,
      $plugin_id,
      $plugin_definition,
      $container->get('plugin.manager.condition'),
      $container->get('context.handler'),
      $container->get('context.repository')
    );
  }

  /**
   * {@inheritdoc}
   */
  public function getType() {
    return t('Boolean');
  }

  /**
   * {@inheritdoc}
   */
  public function buildConfigurationForm(array $form, FormStateInterface $form_state) {
    $form = parent::buildConfigurationForm($form, $form_state);

    $form['condition'] = [];
    $sub_form_state = SubformState::createForSubform($form['condition'], $form, $form_state);
    $form['condition'] = $this
      ->getPlugin()
      ->buildConfigurationForm($form['condition'], $sub_form_state);

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function validateConfigurationForm(array &$form, FormStateInterface $form_state) {
    parent::validateConfigurationForm($form, $form_state);
    $sub_form_state = SubformState::createForSubform($form['condition'], $form, $form_state);
    $this->getPlugin()->validateConfigurationForm($form['condition'], $sub_form_state);
  }

  /**
   * {@inheritdoc}
   */
  public function submitConfigurationForm(array &$form, FormStateInterface $form_state) {
    parent::submitConfigurationForm($form, $form_state);
    $sub_form_state = SubformState::createForSubform($form['condition'], $form, $form_state);
    $plugin = $this->getPlugin();
    $plugin->submitConfigurationForm($form['condition'], $sub_form_state);
    $this->setConfiguration(['condition' => $plugin->getConfiguration()]);
  }

  /**
   * {@inheritdoc}
   */
  public function getContent() {
    $condition = $this->getPlugin();
    if ($this->missingContext) {
      return $condition->isNegated();
    }
    return $this->conditionManager->execute($condition);
  }

  /**
   * Creates a condition plugin instance.
   *
   * @return \Drupal\Core\Condition\ConditionInterface
   *   The condition instance.
   */
  protected function getPlugin() {
    $condition = $this->conditionManager->createInstance($this->getDerivativeId(), $this->configuration['condition']);
    if ($condition instanceof ContextAwarePluginInterface) {
      try {
        // @todo: Find a better way to set contexts.
        $context_mapping = [];
        if ($condition->getPluginId() == 'user_role') {
          $context_mapping['user'] = '@user.current_user_context:current_user';
        }
        elseif ($condition->getPluginId() == 'node_type') {
          $context_mapping['node'] = '@node.node_route_context:node';
        }
        $condition->setContextMapping($context_mapping);

        $contexts = $this->contextRepository->getRuntimeContexts(array_values($condition->getContextMapping()));
        $this->contextHandler->applyContextMapping($condition, $contexts);
      }
      catch (ContextException $e) {
        $this->missingContext = TRUE;
      }
    }
    return $condition;
  }

  /**
   * {@inheritdoc}
   */
  public function defaultConfiguration() {
    $configuration['condition'] = [];
    return $configuration;
  }

}
