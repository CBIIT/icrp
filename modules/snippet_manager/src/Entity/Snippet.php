<?php

namespace Drupal\snippet_manager\Entity;

use Drupal\Core\Config\Entity\ConfigEntityBase;
use Drupal\Core\Entity\EntityStorageInterface;
use Drupal\snippet_manager\SnippetInterface;

/**
 * Defines the snippet entity type.
 *
 * @ConfigEntityType(
 *   id = "snippet",
 *   label = @Translation("Snippet"),
 *   handlers = {
 *     "access" = "Drupal\snippet_manager\SnippetAccessControlHandler",
 *     "view_builder" = "Drupal\snippet_manager\SnippetViewBuilder",
 *     "list_builder" = "Drupal\snippet_manager\SnippetListBuilder",
 *     "form" = {
 *       "add" = "Drupal\snippet_manager\Form\GeneralForm",
 *       "edit" = "Drupal\snippet_manager\Form\GeneralForm",
 *       "delete" = "Drupal\Core\Entity\EntityDeleteForm",
 *       "duplicate" = "Drupal\snippet_manager\Form\DuplicateForm",
 *       "variable_add" = "Drupal\snippet_manager\Form\VariableAddForm",
 *       "variable_edit" = "Drupal\snippet_manager\Form\VariableEditForm",
 *       "variable_delete" = "Drupal\snippet_manager\Form\VariableDeleteForm",
 *       "template_edit" = "Drupal\snippet_manager\Form\TemplateForm",
 *       "css_edit" = "Drupal\snippet_manager\Form\CssForm",
 *       "js_edit" = "Drupal\snippet_manager\Form\JsForm"
 *     }
 *   },
 *   config_prefix = "snippet",
 *   admin_permission = "administer snippets",
 *   links = {
 *     "collection" = "/admin/structure/snippet",
 *     "canonical" = "/admin/structure/snippet/{snippet}",
 *     "source" = "/admin/structure/snippet/{snippet}/source",
 *     "add-form" = "/admin/structure/snippet/add",
 *     "edit-form" = "/admin/structure/snippet/{snippet}/edit",
 *     "template-edit-form" = "/admin/structure/snippet/{snippet}/edit/template",
 *     "delete-form" = "/admin/structure/snippet/{snippet}/delete",
 *     "duplicate-form" = "/admin/structure/snippet/{snippet}/duplicate",
 *     "enable" = "/admin/structure/snippet/{snippet}/enable",
 *     "disable" = "/admin/structure/snippet/{snippet}/disable"
 *   },
 *   entity_keys = {
 *     "id" = "id",
 *     "label" = "label",
 *     "status" = "status",
 *     "uuid" = "uuid",
 *   }
 * )
 *
 * @property \Drupal\snippet_manager\SnippetInterface $original;
 */
class Snippet extends ConfigEntityBase implements SnippetInterface {

  /**
   * The snippet ID.
   *
   * @var string
   */
  protected $id;

  /**
   * The snippet label.
   *
   * @var string
   */
  protected $label;

  /**
   * The snippet description.
   *
   * @var string
   */
  protected $description;

  /**
   * The snippet template.
   *
   * @var array
   */
  protected $template;
  /**
   * The snippet variables.
   *
   * @var array
   */
  protected $variables = [];

  /**
   * The snippet page settings.
   *
   * @var array
   */
  protected $page;

  /**
   * The snippet block settings.
   *
   * @var array
   */
  protected $block;

  /**
   * The snippet block settings.
   *
   * @var array
   */
  protected $access;

  /**
   * The snippet CSS.
   *
   * @var array
   */
  protected $css;

  /**
   * The snippet JS.
   *
   * @var array
   */
  protected $js;

  /**
   * {@inheritdoc}
   */
  public function __construct(array $values, $entity_type) {

    $this->page = [
      'status' => FALSE,
      'title' => '',
      'path' => '',
      'display_variant' => [
        'id' => NULL,
        'configuration' => [],
      ],
      'theme' => '',
    ];

    $this->block = [
      'status' => FALSE,
      'name' => '',
    ];

    $this->access = [
      'type' => 'all',
      'role' => [],
      'permission' => '',
    ];

    $default_format = self::getDefaultFormat();

    $this->template = [
      'value' => '',
      'format' => $default_format,
    ];

    $this->css = [
      'status' => FALSE,
      'value' => '',
      'format' => $default_format,
      'group' => 'component',
    ];

    $this->js = [
      'status' => FALSE,
      'value' => '',
      'format' => $default_format,
    ];

    parent::__construct($values, $entity_type);
  }

  /**
   * {@inheritdoc}
   */
  public function preSave(EntityStorageInterface $storage) {
    // Sort variables by name to make their listing and configuration export
    // more consistent.
    ksort($this->variables);
    parent::preSave($storage);
  }

  /**
   * {@inheritdoc}
   */
  public function postSave(EntityStorageInterface $storage, $update = TRUE) {
    parent::postSave($storage, $update);

    $original = isset($this->original) ? $this->original : NULL;
    $status_changed = !$original || $this->status() != $this->original->status();

    if ($status_changed || $this->get('block') != $this->original->get('block')) {
      \Drupal::service('plugin.manager.block')->clearCachedDefinitions();
    }

    // Rebuild the router if this is a new snippet, or its page settings has
    // been updated, or its status has been changed.
    if ($status_changed || $this->get('page') !== $this->original->get('page')) {
      \Drupal::service('router.builder')->setRebuildNeeded();
    }

    // Update attached library.
    $library_builder = \Drupal::service('snippet_manager.snippet_library_builder');
    $library_builder->updateAssets($this, $original);
  }

  /**
   * {@inheritdoc}
   */
  public static function preDelete(EntityStorageInterface $storage, array $entities) {
    parent::preDelete($storage, $entities);
    \Drupal::service('plugin.manager.block')->clearCachedDefinitions();
  }

  /**
   * {@inheritdoc}
   */
  public function getVariable($key) {
    return isset($this->variables[$key]) ? $this->variables[$key] : NULL;
  }

  /**
   * {@inheritdoc}
   */
  public function setVariable($key, $variable) {
    $this->variables[$key] = $variable;
  }

  /**
   * {@inheritdoc}
   */
  public function removeVariable($key) {
    unset($this->variables[$key]);
  }

  /**
   * {@inheritdoc}
   */
  public function variableExists($key) {
    return isset($this->variables[$key]);
  }

  /**
   * Returns the ID of default filter format.
   */
  protected static function getDefaultFormat() {
    // Full HTML is the most suitable format for snippets.
    $formats = filter_formats(\Drupal::currentUser());
    return isset($formats['full_html']) ? 'full_html' : filter_default_format();
  }

}
