<?php

namespace Drupal\snippet_manager\Plugin\SnippetVariable;

use Drupal\Component\Plugin\Derivative\DeriverBase;
use Drupal\Core\Extension\ModuleHandlerInterface;
use Drupal\Core\Plugin\Discovery\ContainerDeriverInterface;
use Drupal\Core\StringTranslation\StringTranslationTrait;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * Retrieves plugin definitions for forms.
 */
class FormDeriver extends DeriverBase implements ContainerDeriverInterface {

  use StringTranslationTrait;

  /**
   * The module handler to invoke the alter hook.
   *
   * @var \Drupal\Core\Extension\ModuleHandlerInterface
   */
  protected $moduleHandler;

  /**
   * Creates the FormDeriver object.
   *
   * @param \Drupal\Core\Extension\ModuleHandlerInterface $module_handler
   *   The module handler.
   */
  public function __construct(ModuleHandlerInterface $module_handler) {
    $this->moduleHandler = $module_handler;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container, $base_plugin_id) {
    return new static(
      $container->get('module_handler')
    );
  }

  /**
   * {@inheritdoc}
   */
  public function getDerivativeDefinitions($base_plugin_definition) {

    $this->derivatives['user_login'] = [
      'form_id' => 'Drupal\user\Form\UserLoginForm',
      'title' => $this->t('User login'),
    ] + $base_plugin_definition;

    $this->derivatives['user_password'] = [
      'form_id' => 'Drupal\user\Form\UserPasswordForm',
      'title' => $this->t('User password'),
    ] + $base_plugin_definition;

    if ($this->moduleHandler->moduleExists('search')) {
      if (class_exists('Drupal\search\Form\SearchBlockForm')) {
        $this->derivatives['search_block'] = [
          'form_id' => 'Drupal\search\Form\SearchBlockForm',
          'title' => $this->t('Search'),
        ] + $base_plugin_definition;
      }
    }

    return $this->derivatives;
  }

}
