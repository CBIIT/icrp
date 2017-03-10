<?php

namespace Drupal\snippet_manager\Form;

use Drupal\Component\Plugin\Exception\PluginNotFoundException;
use Drupal\Component\Utility\Html;
use Drupal\Core\Config\ConfigFactoryInterface;
use Drupal\Core\Entity\EntityForm;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Link;
use Drupal\Core\Url;
use Drupal\snippet_manager\SnippetVariablePluginManager;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * Snippet template form.
 *
 * @property \Drupal\snippet_manager\SnippetInterface $entity
 */
class TemplateForm extends EntityForm {

  /**
   * The config factory.
   *
   * @var \Drupal\Core\Config\ConfigFactoryInterface
   */
  protected $configFactory;

  /**
   * The variable manager.
   *
   * @var \Drupal\snippet_manager\SnippetVariablePluginManager
   */
  protected $variableManager;

  /**
   * Constructs a snippet form object.
   *
   * @param \Drupal\Core\Config\ConfigFactoryInterface $config_factory
   *   The config factory.
   * @param \Drupal\snippet_manager\SnippetVariablePluginManager $variable_manager
   *   The variable manager.
   */
  public function __construct(ConfigFactoryInterface $config_factory, SnippetVariablePluginManager $variable_manager) {
    $this->configFactory = $config_factory;
    $this->variableManager = $variable_manager;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container) {
    return new static(
      $container->get('config.factory'),
      $container->get('plugin.manager.snippet_variable')
    );
  }

  /**
   * {@inheritdoc}
   */
  public function form(array $form, FormStateInterface $form_state) {

    $form = parent::form($form, $form_state);

    $template = $this->entity->get('template');

    $form['template'] = [
      '#title' => t('Template'),
      '#type' => 'text_format',
      '#default_value' => $template['value'],
      '#rows' => 10,
      '#format' => $template['format'],
      '#editor' => FALSE,
      '#required' => TRUE,
      '#element_validate' => ['::validateTemplate'],
    ];

    $form['template']['#attributes'] = [
      'class' => ['snippet-code-textarea'],
      'data-btn-bold' => TRUE,
      'data-btn-italic' => TRUE,
      'data-btn-underline' => TRUE,
      'data-btn-strike-through' => TRUE,
      'data-btn-list-numbered' => TRUE,
      'data-btn-list-bullet' => TRUE,
      'data-btn-undo' => TRUE,
      'data-btn-redo' => TRUE,
      'data-btn-clear-formatting' => TRUE,
      'data-btn-enlarge' => TRUE,
      'data-btn-shrink' => TRUE,
      'data-mode' => 'html_twig',
      'id' => Html::getId('sm-textarea-template-' . $this->entity->id()),
    ];

    // -- Variables.
    $header = [
      t('Name'),
      t('Type'),
      t('Plugin'),
      t('Operations'),
    ];

    $form['table'] = [
      '#type' => 'table',
      '#header' => $header,
      '#rows' => [],
      '#empty' => t('Variables are not configured yet.'),
      '#caption' => t('Variables'),
      '#attributes' => ['class' => ['sm-variables']],
    ];

    $variables = (array) $this->entity->get('variables');
    foreach ($variables as $variable_name => $variable) {

      $variable_plugin = FALSE;
      try {
        $variable_plugin = $this->variableManager->createInstance($variable['plugin_id'], $variable['configuration']);
      }
      catch (PluginNotFoundException $exception) {
        drupal_set_message(t('The %plugin plugin does not exist.', ['%plugin' => $variable['plugin_id']]), 'warning');
      }

      $route_parameters = [
        'snippet' => $this->entity->id(),
        'variable' => $variable_name,
      ];

      $operation_links = [];
      if ($variable_plugin) {
        $operation_links['edit'] = [
          'title' => t('Edit'),
          'url' => Url::fromRoute('snippet_manager.variable_edit_form', $route_parameters),
        ];
        $operation_links += $variable_plugin->getOperations();
      }
      // Allow deletion of broken variables.
      $operation_links['delete'] = [
        'title' => t('Delete'),
        'url' => Url::fromRoute('snippet_manager.variable_delete_form', $route_parameters),
      ];

      $operation_data = [
        '#type' => 'operations',
        '#links' => $operation_links,
      ];

      $variable_url = Url::fromUserInput(
        '#',
        [
          'fragment' => 'snippet-edit-form',
          'attributes' => [
            'title' => t('Insert to the textarea'),
            'class' => 'snippet-variable',
          ],
        ]
      );

      $form['table']['#rows'][$variable_name] = [
        0 => Link::fromTextAndUrl($variable_name, $variable_url),
        1 => $variable_plugin ? $variable_plugin->getType() : '',
        2 => $variable['plugin_id'] . ($variable_plugin ? '' : ' - ' . t('missing')),
        'operations' => ['data' => $operation_data],
      ];
    }

    $form['#attached']['drupalSettings']['snippetManager']['buttonsPath'] = file_create_url(drupal_get_path('module', 'snippet_manager') . '/images/buttons.svg');
    $form['#attached']['drupalSettings']['snippetManager']['codeMirror'] = $this->configFactory->get('snippet_manager.settings')->get('codemirror');
    $form['#attached']['library'][] = 'snippet_manager/editor';

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  protected function actionsElement(array $form, FormStateInterface $form_state) {
    $element = parent::actionsElement($form, $form_state);
    $element['delete']['#access'] = FALSE;

    if (!$this->entity->isNew()) {
      $element['add_variable'] = [
        '#type' => 'link',
        '#title' => t('Add variable'),
        '#url' => Url::fromRoute('snippet_manager.variable_add_form', ['snippet' => $this->entity->id()]),
        '#attributes' => ['class' => 'button'],
        '#weight' => 5,
      ];
    }

    return $element;
  }

  /**
   * {@inheritdoc}
   */
  public function save(array $form, FormStateInterface $form_state) {
    parent::save($form, $form_state);
    drupal_set_message(t('Snippet %label has been updated.', ['%label' => $this->entity->label()]));
  }

  /**
   * Form element validation handler; Validates twig template.
   */
  public static function validateTemplate($element, FormStateInterface $form_state) {
    // Do not validate code format.
    if ($element['#type'] == 'textarea') {
      $template = $form_state->getValue('template');
      try {
        \Drupal::service('twig')->renderInline(check_markup($template['value'], $template['format']));
      }
      catch (\Twig_Error $e) {
        $form_state->setError($element, t('Twig error: %message', ['%message' => $e->getRawMessage()]));
      }
    }
  }

}
