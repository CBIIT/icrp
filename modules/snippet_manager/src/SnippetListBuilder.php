<?php

namespace Drupal\snippet_manager;

use Drupal\Core\Config\Entity\ConfigEntityListBuilder;
use Drupal\Core\Entity\EntityInterface;

/**
 * Provides a listing of snippets.
 */
class SnippetListBuilder extends ConfigEntityListBuilder {

  /**
   * {@inheritdoc}
   */
  public function buildHeader() {
    $header['label'] = $this->t('Label');
    $header['id'] = $this->t('Machine name');
    $header['status'] = $this->t('Status');
    $header['size'] = $this->t('Size');
    $header['format'] = $this->t('Format');
    $header['page'] = $this->t('Page');
    $header += parent::buildHeader();
    $header['operations'] = [
      'data' => $header['operations'],
      'class' => 'sm-snippet-operations',
    ];
    return $header;
  }

  /**
   * {@inheritdoc}
   */
  public function buildRow(EntityInterface $entity) {
    /** @var \Drupal\snippet_manager\SnippetInterface $entity */
    $row['label'] = $entity->toLink();
    $row['id'] = $entity->id();

    if ($entity->status()) {
      $row['status'] = $this->t('Enabled');
    }
    else {
      $row['status']['data'] = $this->t('Disabled');
      $row['status']['class'] = ['sm-inactive'];
    }

    $code = $entity->getCode();
    $row['size'] = $this->formatSize(strlen($code['value']));

    if ($format_label = $this->getFormatLabel($code['format'])) {
      $row['format'] = $format_label;
    }
    else {
      $row['format']['data'] = $code['format'];
      $row['format']['class'] = ['sm-inactive'];
    }

    if ($entity->pageIsPublished()) {
      $row['page'] = $this->t('Published');
    }
    else {
      $row['page']['data'] = $this->t('Not published');
      $row['page']['class'] = ['sm-inactive'];
    }

    return $row + parent::buildRow($entity);
  }

  /**
   * {@inheritdoc}
   */
  public function getDefaultOperations(EntityInterface $entity) {
    /** @var \Drupal\Core\Config\Entity\ConfigEntityInterface $entity */
    $operations = parent::getDefaultOperations($entity);
    $operations['duplicate'] = [
      'title' => $this->t('Duplicate'),
      'url' => $entity->toUrl('duplicate-form'),
      'weight' => 100,
    ];
    return $operations;
  }

  /**
   * {@inheritdoc}
   */
  public function render() {
    $build = parent::render();
    $build['table']['#attributes']['class'][] = 'sm-snippets-overview';
    $build['#attached']['library'][] = 'snippet_manager/snippet_manager';
    return $build;
  }

  /**
   * Generates a string representation for the given byte count.
   *
   * @see format_size()
   */
  public function formatSize($size) {
    return format_size($size);
  }

  /**
   * Returns label for a given format.
   */
  public function getFormatLabel($format) {
    $formats = filter_formats();
    return isset($formats[$format]) ? $formats[$format]->label() : NULL;
  }

}
