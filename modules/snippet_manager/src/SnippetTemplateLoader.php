<?php

namespace Drupal\snippet_manager;

use Drupal\Core\Entity\EntityTypeManagerInterface;
use Drupal\Core\Logger\LoggerChannelInterface;

/**
 * Loads templates from the snippet storage.
 */
class SnippetTemplateLoader implements \Twig_LoaderInterface, \Twig_ExistsLoaderInterface {

  /**
   * The entity_type.manager service.
   *
   * @var \Drupal\Core\Entity\EntityTypeManagerInterface
   */
  protected $entityTypeManager;

  /**
   * Snippet renderer.
   *
   * @var \Drupal\Core\Logger\LoggerChannelInterface
   */
  protected $logger;

  /**
   * Constructs a new Snippet template loader instance.
   *
   * @param \Drupal\Core\Entity\EntityTypeManagerInterface $entity_type_manager
   *   The manager service.
   * @param \Drupal\Core\Logger\LoggerChannelInterface $logger
   *   The logger channel.
   */
  public function __construct(EntityTypeManagerInterface $entity_type_manager, LoggerChannelInterface $logger) {
    $this->entityTypeManager = $entity_type_manager;
    $this->logger = $logger;
  }

  /**
   * {@inheritdoc}
   */
  public function exists($name) {
    return strpos($name, '@snippet/') !== FALSE;
  }

  /**
   * {@inheritdoc}
   */
  public function getSource($name) {
    $snippet_id = explode('/', $name)[1];

    /** @var \Drupal\snippet_manager\SnippetInterface $snippet */
    $snippet = $this->entityTypeManager->getStorage('snippet')->load($snippet_id);
    if ($snippet && $snippet->status()) {
      $template = $snippet->get('template');
      return (string) check_markup($template['value'], $template['format']);
    }

    $this->logger->error('Could not load snippet: %snippet', ['%snippet' => $snippet_id]);
  }

  /**
   * {@inheritdoc}
   */
  public function getCacheKey($name) {
    return $name;
  }

  /**
   * {@inheritdoc}
   */
  public function isFresh($name, $time) {
    return TRUE;
  }

}
