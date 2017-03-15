<?php

namespace Drupal\snippet_manager\Form;

use Drupal\Component\Plugin\Exception\PluginNotFoundException;
use Drupal\Component\Plugin\PluginManagerInterface;
use Drupal\Core\Entity\EntityForm;
use Drupal\Core\Form\FormStateInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

/**
 * Provides a base class for variable forms.
 *
 * @property \Drupal\snippet_manager\SnippetInterface $entity
 */
abstract class VariableFormBase extends EntityForm {

  /**
   * The variable plugin.
   *
   * @var \Drupal\snippet_manager\SnippetVariableInterface
   */
  protected $plugin;

  /**
   * The variable manager.
   *
   * @var \Drupal\Component\Plugin\PluginManagerInterface
   */
  protected $variableManager;

  /**
   * The variable definition.
   *
   * @var array
   */
  protected $variable;

  /**
   * Constructs form object object.
   */
  public function __construct(PluginManagerInterface $variable_manager) {
    $this->variableManager = $variable_manager;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container) {
    return new static(
      $container->get('plugin.manager.snippet_variable')
    );
  }

  /**
   * Initialize the form state and the entity before the first form build.
   */
  protected function init(FormStateInterface $form_state) {
    parent::init($form_state);
    if ($this->operation != 'variable_add') {
      $this->variable = $this->entity->getVariable($this->getVariableName());
      if (!$this->variable) {
        throw new NotFoundHttpException();
      }
    }
  }

  /**
   * Plugin getter.
   *
   * The plugin cannot be set in the constructor because form $entity is not
   * ready yet at that moment.
   */
  protected function getPlugin() {
    if (!$this->plugin) {
      try {
        $this->plugin = $this->variableManager->createInstance(
          $this->variable['plugin_id'],
          $this->variable['configuration']
        );
      }
      catch (PluginNotFoundException $exception) {
        drupal_set_message(t('The %plugin plugin does not exist.', ['%plugin' => $this->variable['plugin_id']]), 'warning');
        throw new NotFoundHttpException();
      }
    }
    return $this->plugin;
  }

  /**
   * Returns name of the variable.
   */
  protected function getVariableName() {
    return $this->getRouteMatch()->getParameter('variable');
  }

}
