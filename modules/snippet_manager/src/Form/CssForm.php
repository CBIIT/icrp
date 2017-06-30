<?php

namespace Drupal\snippet_manager\Form;

use Drupal\Component\Utility\Html;
use Drupal\Core\Config\ConfigFactoryInterface;
use Drupal\Core\Entity\EntityForm;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\State\StateInterface;
use Drupal\Core\Url;
use Drupal\snippet_manager\SnippetLibraryBuilder;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * Snippet CSS form.
 *
 * @property \Drupal\snippet_manager\SnippetInterface $entity
 */
class CssForm extends EntityForm {

  /**
   * The config factory.
   *
   * @var \Drupal\Core\Config\ConfigFactoryInterface
   */
  protected $configFactory;

  /**
   * The library builder.
   *
   * @var \Drupal\snippet_manager\SnippetLibraryBuilder
   */
  protected $libraryBuilder;

  /**
   * The key/value Store to use for state.
   *
   * @var \Drupal\Core\State\StateInterface
   */
  protected $state;

  /**
   * Constructs a snippet form object.
   *
   * @param \Drupal\Core\Config\ConfigFactoryInterface $config_factory
   *   The config factory.
   * @param \Drupal\snippet_manager\SnippetLibraryBuilder $library_builder
   *   The snippet library builder.
   * @param \Drupal\Core\State\StateInterface $state
   *   The state key/value store.
   */
  public function __construct(ConfigFactoryInterface $config_factory, SnippetLibraryBuilder $library_builder, StateInterface $state) {
    $this->configFactory = $config_factory;
    $this->libraryBuilder = $library_builder;
    $this->state = $state;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container) {
    return new static(
      $container->get('config.factory'),
      $container->get('snippet_manager.snippet_library_builder'),
      $container->get('state')
    );
  }

  /**
   * {@inheritdoc}
   */
  public function form(array $form, FormStateInterface $form_state) {

    $form = parent::form($form, $form_state);

    $css = $this->entity->get('css');

    $form['css'] = [
      '#title' => t('CSS'),
      '#type' => 'text_format',
      '#default_value' => $css['value'],
      '#rows' => 10,
      '#format' => $css['format'],
      '#editor' => FALSE,
    ];

    $form['css']['#attributes'] = [
      'class' => ['snippet-code-textarea'],
      'data-btn-undo' => TRUE,
      'data-btn-redo' => TRUE,
      'data-btn-enlarge' => TRUE,
      'data-btn-shrink' => TRUE,
      'data-mode' => 'css',
      'id' => Html::getId('sm-textarea-css-' . $this->entity->id()),
    ];

    $form['css']['status'] = [
      '#type' => 'checkbox',
      '#title' => t('Enable'),
      '#default_value' => $css['status'],
    ];

    $form['css']['group'] = [
      '#type' => 'select',
      '#title' => t('Group'),
      '#default_value' => $css['group'],
      '#options' => [
        'base' => t('Base'),
        'layout' => t('Layout'),
        'component' => t('Component'),
        'state' => t('State'),
        'theme' => t('Theme'),
      ],
    ];

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

    $file_path = $this->libraryBuilder->getFilePath('css', $this->entity);
    if (file_exists(DRUPAL_ROOT . '/' . $file_path)) {
      $options['query'][$this->state->get('system.css_js_query_string') ?: '0'] = NULL;
      $element['open_file'] = [
        '#type' => 'link',
        '#title' => t('Open file'),
        '#url' => Url::fromUri('base://' . $file_path, $options),
        '#attributes' => ['class' => 'button', 'target' => '_blank'],
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

}
