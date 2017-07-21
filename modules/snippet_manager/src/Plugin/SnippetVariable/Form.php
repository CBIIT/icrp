<?php

namespace Drupal\snippet_manager\Plugin\SnippetVariable;

use Drupal\Core\Form\FormBuilderInterface;
use Drupal\Core\Plugin\ContainerFactoryPluginInterface;
use Drupal\snippet_manager\SnippetVariableBase;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * Provides text variable type.
 *
 * @SnippetVariable(
 *   id = "form",
 *   title = @Translation("Form"),
 *   category = @Translation("Form"),
 *   deriver = "\Drupal\snippet_manager\Plugin\SnippetVariable\FormDeriver",
 * )
 */
class Form extends SnippetVariableBase implements ContainerFactoryPluginInterface {

  /**
   * The form builder.
   *
   * @var \Drupal\Core\Form\FormBuilderInterface
   */
  protected $formBuilder;

  /**
   * Constructs form variable object.
   *
   * @param array $configuration
   *   A configuration array containing information about the plugin instance.
   * @param string $plugin_id
   *   The plugin_id for the plugin instance.
   * @param mixed $plugin_definition
   *   The plugin implementation definition.
   * @param \Drupal\Core\Form\FormBuilderInterface $form_builder
   *   The form builder.
   */
  public function __construct(array $configuration, $plugin_id, $plugin_definition, FormBuilderInterface $form_builder) {
    parent::__construct($configuration, $plugin_id, $plugin_definition);
    $this->formBuilder = $form_builder;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container, array $configuration, $plugin_id, $plugin_definition) {
    return new static(
      $configuration,
      $plugin_id,
      $plugin_definition,
      $container->get('form_builder')
    );
  }

  /**
   * {@inheritdoc}
   */
  public function build() {
    return $this->formBuilder->getForm($this->getPluginDefinition()['form_id']);
  }

}
