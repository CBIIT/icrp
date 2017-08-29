<?php

namespace Drupal\snippet_manager\Form;

use Drupal\Component\Utility\UrlHelper;
use Drupal\Core\Config\ConfigFactoryInterface;
use Drupal\Core\Display\VariantManager;
use Drupal\Core\Entity\EntityForm;
use Drupal\Core\Extension\ModuleHandlerInterface;
use Drupal\Core\Extension\ThemeHandlerInterface;
use Drupal\Core\Form\FormStateInterface;
use Drupal\user\PermissionHandlerInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * Snippet general form.
 *
 * @property \Drupal\snippet_manager\SnippetInterface $entity
 */
class GeneralForm extends EntityForm {

  /**
   * The variant manager.
   *
   * @var \Drupal\Core\Display\VariantManager
   */
  protected $variantManager;

  /**
   * The config factory.
   *
   * @var \Drupal\Core\Config\ConfigFactoryInterface
   */
  protected $configFactory;

  /**
   * The module handler to invoke the alter hook.
   *
   * @var \Drupal\Core\Extension\ModuleHandlerInterface
   */
  protected $moduleHandler;

  /**
   * The theme handler.
   *
   * @var \Drupal\Core\Extension\ThemeHandlerInterface
   */
  protected $themeHandler;

  /**
   * The permission handler.
   *
   * @var \Drupal\user\PermissionHandlerInterface
   */
  protected $permissionHandler;

  /**
   * Constructs a snippet form object.
   *
   * @param \Drupal\Core\Display\VariantManager $variant_manager
   *   The variant manager.
   * @param \Drupal\Core\Config\ConfigFactoryInterface $config_factory
   *   The config factory.
   * @param \Drupal\Core\Extension\ModuleHandlerInterface $module_handler
   *   The module handler.
   * @param \Drupal\Core\Extension\ThemeHandlerInterface $theme_handler
   *   The theme handler.
   * @param \Drupal\user\PermissionHandlerInterface $permission_handler
   *   The permission handler.
   */
  public function __construct(VariantManager $variant_manager, ConfigFactoryInterface $config_factory, ModuleHandlerInterface $module_handler, ThemeHandlerInterface $theme_handler, PermissionHandlerInterface $permission_handler) {
    $this->variantManager = $variant_manager;
    $this->configFactory = $config_factory;
    $this->moduleHandler = $module_handler;
    $this->themeHandler = $theme_handler;
    $this->permissionHandler = $permission_handler;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container) {
    return new static(
      $container->get('plugin.manager.display_variant'),
      $container->get('config.factory'),
      $container->get('module_handler'),
      $container->get('theme_handler'),
      $container->get('user.permissions')
    );
  }

  /**
   * {@inheritdoc}
   */
  public function form(array $form, FormStateInterface $form_state) {

    $form = parent::form($form, $form_state);

    $form['label'] = [
      '#type' => 'textfield',
      '#title' => $this->t('Label'),
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

    // -- Page.
    $form['page'] = [
      '#type' => 'fieldset',
      '#title' => $this->t('Page'),
      '#open' => FALSE,
      '#tree' => TRUE,
      '#group' => 'additional_settings',
    ];

    $form['page']['status'] = [
      '#type' => 'checkbox',
      '#title' => $this->t('Enable snippet page'),
      '#default_value' => $this->entity->get('page')['status'],
    ];

    $form['page']['title'] = [
      '#type' => 'textfield',
      '#title' => $this->t('Title'),
      '#description' => $this->t('Leave empty to use snippet label as page title.'),
      '#default_value' => $this->entity->get('page')['title'],
    ];

    $description_args = [
      '%placeholder_1' => '%',
      '%placeholder_2' => 'content/%',
      '%placeholder_3' => 'content/%node',
    ];
    $form['page']['path'] = [
      '#type' => 'textfield',
      '#title' => $this->t('Path'),
      '#description' => $this->t('This page will be displayed by visiting this path on your site. You may use "%placeholder_1" in your URL to represent placeholders. For example, "%placeholder_2". If needed you can even load entities using named route parameters like "%placeholder_3".', $description_args),
      '#default_value' => $this->entity->get('page')['path'],
    ];

    $display_variant_wrapper = 'display-variant-settings';
    $form['page']['display_variant'] = [
      '#type' => 'container',
      '#title' => $this->t('Display variant settings'),
      '#open' => TRUE,
      '#id' => $display_variant_wrapper,
    ];

    $theme_options[''] = $this->t('- Default -');
    foreach ($this->themeHandler->listInfo() as $theme) {
      if ($theme->status && empty($theme->info['hidden'])) {
        $theme_options[$theme->getName()] = $theme->info['name'];
      }
    }

    $form['page']['theme'] = [
      '#type' => 'select',
      '#title' => $this->t('Theme'),
      '#options' => $theme_options,
      '#default_value' => $this->entity->get('page')['theme'],
      '#description' => $this->t('A theme that will be used to render the page.'),
    ];

    $variant_definitions = $this->variantManager->getDefinitions();
    $options = ['' => $this->t('- Default -')];
    foreach ($variant_definitions as $id => $definition) {
      $options[$id] = $definition['admin_label'];
    }
    asort($options);

    $display_variant = $this->entity->get('page')['display_variant'];
    $form['page']['display_variant']['id'] = [
      '#type' => 'select',
      '#title' => $this->t('Display variant'),
      '#options' => $options,
      '#default_value' => $display_variant['id'],
      '#ajax' => [
        'wrapper' => $display_variant_wrapper,
        'callback' => '::displayVariantSettings',
        'event' => 'change',
      ],
      '#description' => $this->t('Display variants render the main content in a certain way.'),
    ];

    if ($display_variant && $display_variant['id']) {
      $plugin_configuration = isset($display_variant['configuration']) ?
        $display_variant['configuration'] : [];
      $variant_instance = $this->variantManager->createInstance($display_variant['id'], $plugin_configuration);
      $form['page']['display_variant']['configuration'] = $variant_instance->buildConfigurationForm([], $form_state);
    }

    // -- Block.
    if ($this->moduleHandler->moduleExists('block')) {
      $form['block'] = [
        '#type' => 'fieldset',
        '#title' => $this->t('Block'),
        '#open' => FALSE,
        '#tree' => TRUE,
        '#group' => 'additional_settings',
      ];

      $form['block']['status'] = [
        '#type' => 'checkbox',
        '#title' => $this->t('Enable snippet block'),
        '#default_value' => $this->entity->get('block')['status'],
      ];

      $form['block']['name'] = [
        '#type' => 'textfield',
        '#title' => $this->t('Admin description'),
        '#description' => $this->t('This will appear on blocks layout page.'),
        '#default_value' => $this->entity->get('block')['name'],
      ];
    }

    // -- Access.
    $form['access'] = [
      '#type' => 'fieldset',
      '#title' => $this->t('Access'),
      '#open' => FALSE,
      '#tree' => TRUE,
      '#group' => 'additional_settings',
    ];

    $form['access']['type'] = [
      '#type' => 'radios',
      '#options' => [
        'all' => $this->t('Do not limit'),
        'permission' => $this->t('Permission'),
        'role' => $this->t('Role'),
      ],
      '#default_value' => $this->entity->get('access')['type'],
    ];

    $options = ['' => $this->t('- Select permission -')];
    $permissions = $this->permissionHandler->getPermissions();
    foreach ($permissions as $permission => $permission_info) {
      $provider = $permission_info['provider'];
      $display_name = $this->moduleHandler->getName($provider);
      $options[$display_name][$permission] = strip_tags($permission_info['title']);
    }

    $form['access']['permission'] = [
      '#type' => 'select',
      '#options' => $options,
      '#title' => $this->t('Permission'),
      '#description' => $this->t('Only users with the selected permission flag will be able to access this snippet.'),
      '#default_value' => $this->entity->get('access')['permission'],
      '#states' => [
        'visible' => [
          ':input[name="access[type]"]' => ['value' => 'permission'],
        ],
      ],
    ];

    $form['access']['role'] = [
      '#type' => 'checkboxes',
      '#title' => $this->t('Role'),
      '#options' => array_map('\Drupal\Component\Utility\Html::escape', user_role_names()),
      '#description' => $this->t('Only the checked roles will be able to access this snippet.'),
      '#default_value' => $this->entity->get('access')['role'],
      '#states' => [
        'visible' => [
          ':input[name="access[type]"]' => ['value' => 'role'],
        ],
      ],
    ];

    $form['#attached']['drupalSettings']['snippetManager']['snippetId'] = $this->entity->id();
    $form['#attached']['drupalSettings']['snippetManager']['buttonsPath'] = file_create_url(drupal_get_path('module', 'snippet_manager') . '/images/buttons.svg');
    $form['#attached']['drupalSettings']['snippetManager']['codeMirror'] = $this->configFactory->get('snippet_manager.settings')->get('codemirror');
    $form['#attached']['library'][] = 'snippet_manager/editor';

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function validateForm(array &$form, FormStateInterface $form_state) {
    $page = $form_state->getValue('page');
    if ($page['status']) {
      $errors = $this->validatePath($page['path']);
      foreach ($errors as $error) {
        $form_state->setError($form['page']['path'], $error);
      }
      // Automatically remove '/' and trailing whitespace from path.
      $page['path'] = trim($page['path'], '/');

      // Display variant form is loaded through ajax request. Make sure the
      // configuration is initialized correctly even when the respected form
      // element is missing (for instance in test cases).
      if (empty($page['display_variant']['configuration']['label'])) {
        $page['display_variant']['configuration']['label'] = '';
      }
      $form_state->setValue('page', $page);
    }

    $access = $form_state->getValue('access');

    if ($access['type'] == 'permission' && !$access['permission']) {
      $form_state->setError($form['access']['permission'], $this->t('You must select a permission if access type is "Permission"'));
    }

    $role = array_filter($access['role']);
    if ($access['type'] == 'role' && count($role) == 0) {
      $form_state->setError($form['access']['role'], $this->t('You must select at least one role if access type is "Role"'));
    }
    $form_state->setValue(['access', 'role'], $role);

  }

  /**
   * {@inheritdoc}
   */
  public function save(array $form, FormStateInterface $form_state) {
    $result = $this->entity->save();

    $message_arguments = ['%label' => $this->entity->label()];
    $message = $result == SAVED_NEW ?
      $this->t('Snippet %label has been created.', $message_arguments) :
      $this->t('Snippet %label has been updated.', $message_arguments);
    drupal_set_message($message);

    $form_state->setRedirectUrl($this->entity->toUrl('edit-form'));
  }

  /**
   * Form element validation handler; Validates twig template.
   */
  public static function validateTemplate($element, FormStateInterface $form_state) {

    // Do not validate template format.
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

  /**
   * Validates the path of the display.
   *
   * @param string $path
   *   The path to validate.
   *
   * @return array
   *   A list of error strings.
   */
  protected function validatePath($path) {
    $errors = [];
    if (strpos($path, '%') === 0) {
      $errors[] = $this->t('"%" may not be used for the first segment of a path.');
    }

    $parsed_url = UrlHelper::parse($path);
    if (empty($parsed_url['path'])) {
      $errors[] = $this->t('Path is empty.');
    }

    if (!empty($parsed_url['query'])) {
      $errors[] = $this->t('No query allowed.');
    }

    if (!parse_url('internal:/' . $path)) {
      $errors[] = $this->t('Invalid path. Valid characters are alphanumerics as well as "-", ".", "_" and "~".');
    }

    $path_sections = explode('/', $path);
    // Symfony routing does not allow to use numeric placeholders.
    // @see \Symfony\Component\Routing\RouteCompiler
    $numeric_placeholders = array_filter($path_sections, function ($section) {
      return (preg_match('/^%(.*)/', $section, $matches)
        && is_numeric($matches[1]));
    });
    if (!empty($numeric_placeholders)) {
      $errors[] = $this->t('Numeric placeholders may not be used. Please use plain placeholders (%).');
    }
    return $errors;
  }

  /**
   * Ajax callback.
   */
  public function displayVariantSettings(array &$form, FormStateInterface $form_state) {
    return $form['page']['display_variant'];
  }

}
