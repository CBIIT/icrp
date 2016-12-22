<?php

namespace Drupal\snippet_manager\Form;

use Drupal\Component\Plugin\Exception\PluginNotFoundException;
use Drupal\Core\Config\ConfigFactoryInterface;
use Drupal\Core\Display\VariantManager;
use Drupal\Core\Entity\EntityForm;
use Drupal\Core\Extension\ThemeHandlerInterface;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Language\LanguageInterface;
use Drupal\Core\Link;
use Drupal\Core\Path\AliasStorageInterface;
use Drupal\Core\Url;
use Drupal\snippet_manager\SnippetVariablePluginManager;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * Snippet form.
 *
 * @property \Drupal\snippet_manager\SnippetInterface $entity
 */
class SnippetForm extends EntityForm {

  /**
   * The variant manager.
   *
   * @var \Drupal\Core\Display\VariantManager
   */
  protected $variantManager;

  /**
   * The variable manager.
   *
   * @var \Drupal\snippet_manager\SnippetVariablePluginManager
   */
  protected $variableManager;

  /**
   * The path alias storage.
   *
   * @var \Drupal\Core\Path\AliasStorageInterface
   */
  protected $pathAliasStorage;

  /**
   * The config factory.
   *
   * @var \Drupal\Core\Config\ConfigFactoryInterface
   */
  protected $configFactory;

  /**
   * The theme handler.
   *
   * @var \Drupal\Core\Extension\ThemeHandlerInterface
   */
  protected $themeHandler;

  /**
   * Constructs a snippet form object.
   *
   * @param \Drupal\Core\Display\VariantManager $variant_manager
   *   The variant manager.
   * @param \Drupal\snippet_manager\SnippetVariablePluginManager $variable_manager
   *   The variable manager.
   * @param \Drupal\Core\Path\AliasStorageInterface $path_alias_storage
   *   The path alias storage.
   * @param \Drupal\Core\Config\ConfigFactoryInterface $config_factory
   *   The config factory.
   * @param \Drupal\Core\Extension\ThemeHandlerInterface $theme_handler
   *   The theme handler.
   */
  public function __construct(VariantManager $variant_manager, SnippetVariablePluginManager $variable_manager, AliasStorageInterface $path_alias_storage, ConfigFactoryInterface $config_factory, ThemeHandlerInterface $theme_handler) {
    $this->variantManager = $variant_manager;
    $this->variableManager = $variable_manager;
    $this->pathAliasStorage = $path_alias_storage;
    $this->configFactory = $config_factory;
    $this->themeHandler = $theme_handler;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container) {
    return new static(
      $container->get('plugin.manager.display_variant'),
      $container->get('plugin.manager.snippet_variable'),
      $container->get('path.alias_storage'),
      $container->get('config.factory'),
      $container->get('theme_handler')
    );
  }

  /**
   * {@inheritdoc}
   */
  public function form(array $form, FormStateInterface $form_state) {

    $form = parent::form($form, $form_state);

    if (!$this->entity->isNew()) {
      $form['#title'] = t('Edit @label', ['@label' => $this->entity->label()]);
    }

    $form['label'] = [
      '#type' => 'textfield',
      '#title' => t('Label'),
      '#maxlength' => 255,
      '#default_value' => $this->entity->label(),
      '#required' => TRUE,
    ];

    $form['id'] = [
      '#type' => 'machine_name',
      '#default_value' => $this->entity->id(),
      '#machine_name' => [
        'exists' => '\Drupal\snippet_manager\Entity\Snippet::load',
      ],
      '#disabled' => !$this->entity->isNew(),
    ];

    $form['status'] = [
      '#type' => 'checkbox',
      '#title' => t('Enabled'),
      '#default_value' => $this->entity->status(),
    ];

    $code = $this->entity->getCode();

    $form['code'] = [
      '#title' => t('Code'),
      '#type' => 'text_format',
      '#default_value' => $code['value'],
      '#rows' => 10,
      '#format' => $code['format'],
      '#editor' => FALSE,
      '#required' => TRUE,
      '#attributes' => ['class' => ['snippet-code-textarea']],
      '#element_validate' => ['::validateTemplate'],
    ];

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
    ];

    $variables = (array) $this->entity->getVariables();
    foreach ($variables as $variable_name => $variable) {

      $variable_plugin = FALSE;
      try {
        $variable_plugin = $this->variableManager->createInstance($variable['plugin_id'], $variable['configuration']);
      }
      catch (PluginNotFoundException $exception) {
        drupal_set_message(t('The %plugin does not exist.', ['%plugin' => $variable['plugin_id']]), 'warning');
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

    $form['page'] = [
      '#type' => 'details',
      '#title' => t('Page settings'),
      '#open' => FALSE,
      '#tree' => TRUE,
    ];

    $form['page']['status'] = [
      '#type' => 'checkbox',
      '#title' => t('Publish snippet page'),
      '#default_value' => $this->entity->get('page')['status'],
      '#description' => t('Published page will be accessible for privileged visitors if the snippet is enabled.'),
    ];

    $form['page']['url_alias'] = [
      '#type' => 'textfield',
      '#title' => t('URL alias'),
      '#description' => t('The alternative URL for this content. Use a relative path. The alias needs to start with a slash.'),
      '#default_value' => $this->entity->get('page')['url_alias'],
      '#element_validate' => ['::validateUrlAlias'],
    ];

    $display_variant_wrapper = 'display-variant-settings';
    $form['page']['display_variant'] = [
      '#type' => 'container',
      '#title' => t('Display variant settings'),
      '#open' => TRUE,
      '#id' => $display_variant_wrapper,
    ];

    $themes = $this->themeHandler->rebuildThemeData();
    uasort($themes, 'system_sort_modules_by_info_name');

    $theme_options[''] = t('- Default -');
    foreach ($themes as &$theme) {
      if ($theme->status && empty($theme->info['hidden'])) {
        $theme_options[$theme->getName()] = $theme->info['name'];
      }
    }

    $form['page']['theme'] = [
      '#type' => 'select',
      '#title' => t('Theme'),
      '#options' => $theme_options,
      '#default_value' => $this->entity->get('page')['theme'],
      '#description' => t('A theme that will be used to render the snippet.'),
    ];

    $variant_definitions = $this->variantManager->getDefinitions();
    $options = ['' => t('- Default -')];
    foreach ($variant_definitions as $id => $definition) {
      $options[$id] = $definition['admin_label'];
    }
    asort($options);

    $display_variant = $this->entity->get('page')['display_variant'];
    $form['page']['display_variant']['id'] = [
      '#type' => 'select',
      '#title' => t('Display variant'),
      '#options' => $options,
      '#default_value' => $display_variant['id'],
      '#ajax' => [
        'wrapper' => $display_variant_wrapper,
        'callback' => '::displayVariantSettings',
        'event' => 'change',
      ],
      '#description' => t('Display variants render the main content in a certain way.'),
    ];

    if ($display_variant && $display_variant['id']) {
      $plugin_configuration = isset($display_variant['configuration']) ?
        $display_variant['configuration'] : [];
      $variant_instance = $this->variantManager->createInstance($display_variant['id'], $plugin_configuration);
      $form['page']['display_variant']['configuration'] = $variant_instance->buildConfigurationForm([], $form_state);
    }

    $form['#attached']['drupalSettings']['snippetManager']['snippetId'] = $this->entity->id();
    $form['#attached']['drupalSettings']['snippetManager']['buttonsPath'] = file_create_url(drupal_get_path('module', 'snippet_manager') . '/images/buttons.svg');
    $form['#attached']['drupalSettings']['snippetManager']['codeMirror'] = $this->configFactory->get('snippet_manager.settings')->get('codemirror');
    $form['#attached']['library'][] = 'snippet_manager/snippet_manager';
    return $form;
  }

  /**
   * {@inheritdoc}
   */
  protected function actionsElement(array $form, FormStateInterface $form_state) {
    $element = parent::actionsElement($form, $form_state);

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

    $result = $this->entity->save();

    // @todo: Test path saving.
    $path = '/' . $this->entity->toUrl('canonical')->getInternalPath();

    $this->pathAliasStorage->delete(['source' => $path]);

    $url_alias = $this->entity->get('page')['url_alias'];
    if ($url_alias) {
      $this->pathAliasStorage->save($path, $url_alias);
    }

    $message_arguments = ['%label' => $this->entity->label()];
    $message = $result == SAVED_NEW ?
      t('Snippet %label has been created.', $message_arguments) :
      t('Snippet %label has been updated.', $message_arguments);
    drupal_set_message($message);

    $redirect_page = $this->configFactory->get('snippet_manager.settings')->get('redirect_page');
    $form_state->setRedirectUrl($this->entity->toUrl($redirect_page));
  }

  /**
   * Form element validation handler; Validates twig template.
   */
  public static function validateTemplate($element, FormStateInterface $form_state) {

    // Do not validate code format.
    if ($element['#type'] == 'textarea') {
      $code = $form_state->getValue('code');
      try {
        \Drupal::service('twig')->renderInline(check_markup($code['value'], $code['format']));
      }
      catch (\Twig_Error $e) {
        $form_state->setError($element, t('Twig error: %message', ['%message' => $e->getRawMessage()]));
      }
    }

  }

  /**
   * Form element validation handler for URL alias form element.
   *
   * @param array $element
   *   The form element.
   * @param \Drupal\Core\Form\FormStateInterface $form_state
   *   The form state.
   */
  public static function validateUrlAlias(array &$element, FormStateInterface $form_state) {
    // Trim the submitted value of whitespace and slashes.
    $alias = rtrim(trim($element['#value']), " \\/");
    if (!empty($alias)) {
      $form_state->setValueForElement($element, $alias);

      $source = '/snippet/' . $form_state->getValue('id');

      // Validate that the submitted alias does not exist yet.
      $is_exists = \Drupal::service('path.alias_storage')->aliasExists($alias, LanguageInterface::LANGCODE_NOT_SPECIFIED, $source);
      if ($is_exists) {
        $form_state->setError($element, t('The alias is already in use.'));
      }
    }

    if ($alias && $alias[0] !== '/') {
      $form_state->setError($element, t('The alias needs to start with a slash.'));
    }
  }

  /**
   * Ajax callback.
   */
  public function displayVariantSettings(array &$form, FormStateInterface $form_state) {
    return $form['page']['display_variant'];
  }

}
