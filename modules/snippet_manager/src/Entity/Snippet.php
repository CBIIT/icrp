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
 *       "add" = "Drupal\snippet_manager\Form\SnippetForm",
 *       "edit" = "Drupal\snippet_manager\Form\SnippetForm",
 *       "delete" = "Drupal\Core\Entity\EntityDeleteForm",
 *       "duplicate" = "Drupal\snippet_manager\Form\SnippetDuplicateForm",
 *       "variable_add" = "Drupal\snippet_manager\Form\VariableAddForm",
 *       "variable_edit" = "Drupal\snippet_manager\Form\VariableEditForm",
 *       "variable_delete" = "Drupal\snippet_manager\Form\VariableDeleteForm"
 *     }
 *   },
 *   config_prefix = "snippet",
 *   admin_permission = "administer snippets",
 *   links = {
 *     "collection" = "/admin/structure/snippet",
 *     "canonical" = "/snippet/{snippet}",
 *     "admin" = "/snippet/{snippet}/html-source",
 *     "add-form" = "/snippet/add",
 *     "edit-form" = "/snippet/{snippet}/edit",
 *     "delete-form" = "/snippet/{snippet}/delete",
 *     "duplicate-form" = "/snippet/{snippet}/duplicate"
 *   },
 *   entity_keys = {
 *     "id" = "id",
 *     "label" = "label",
 *     "uuid" = "uuid"
 *   }
 * )
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
   * The snippet code.
   *
   * @var array
   */
  protected $code;

  /**
   * The snippet variables.
   *
   * @var array
   */
  protected $variables = [];

  /**
   * The snippet context.
   *
   * The context is an array of processed twig variables.
   *
   * @var array
   */
  protected $context = [];

  /**
   * The snippet page settings.
   *
   * @var array
   */
  protected $page = [
    'status' => FALSE,
    'admin' => FALSE,
    'url_alias' => '',
    'display_variant' => [
      'id' => NULL,
      'configuration' => [],
    ],
    'theme' => '',
  ];

  /**
   * {@inheritdoc}
   */
  public function postSave(EntityStorageInterface $storage, $update = TRUE) {
    parent::postSave($storage, $update);
    \Drupal::service('plugin.manager.block')->clearCachedDefinitions();
  }

  /**
   * {@inheritdoc}
   */
  public static function preDelete(EntityStorageInterface $storage, array $entities) {
    parent::postDelete($storage, $entities);
    \Drupal::service('plugin.manager.block')->clearCachedDefinitions();
  }

  /**
   * {@inheritdoc}
   */
  public function getCode() {
    return $this->code ? $this->code : [
      'value' => str_repeat("\n", 10),
      'format' => filter_default_format(),
    ];
  }

  /**
   * {@inheritdoc}
   */
  public function setCode(array $code) {
    return $this->code = $code;
  }

  /**
   * {@inheritdoc}
   */
  public function getVariables() {
    return $this->variables;
  }

  /**
   * {@inheritdoc}
   */
  public function setVariables($variables) {
    $this->variables = $variables;
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
   * {@inheritdoc}
   */
  public function getContext() {
    return $this->context;
  }

  /**
   * {@inheritdoc}
   */
  public function setContext($context) {
    $this->context = $context;
  }

  /**
   * {@inheritdoc}
   */
  public function pageIsPublished() {
    return $this->page['status'];
  }

}
