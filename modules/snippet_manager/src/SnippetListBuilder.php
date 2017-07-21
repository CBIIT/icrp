<?php

namespace Drupal\snippet_manager;

use Drupal\Core\Config\Entity\ConfigEntityListBuilder;
use Drupal\Core\Entity\EntityInterface;
use Drupal\Core\Link;
use Drupal\Core\Url;

/**
 * Provides a listing of snippets.
 */
class SnippetListBuilder extends ConfigEntityListBuilder {

  /**
   * {@inheritdoc}
   */
  public function buildHeader() {
    $header['name'] = $this->t('Name');
    $header['id'] = [
      'data' => $this->t('ID'),
      'class' => [RESPONSIVE_PRIORITY_MEDIUM],
    ];
    $header['status'] = $this->t('Status');
    $header['size'] = [
      'data' => $this->t('Size'),
      'class' => [RESPONSIVE_PRIORITY_LOW],
    ];
    $header['format'] = [
      'data' => $this->t('Format'),
      'class' => [RESPONSIVE_PRIORITY_LOW],
    ];
    $header['page'] = [
      'data' => $this->t('Page'),
      'class' => [RESPONSIVE_PRIORITY_MEDIUM],
    ];
    $header['block'] = [
      'data' => $this->t('Block'),
      'class' => [RESPONSIVE_PRIORITY_MEDIUM],
    ];
    $header += parent::buildHeader();
    return $header;
  }

  /**
   * {@inheritdoc}
   */
  public function buildRow(EntityInterface $entity) {
    /** @var \Drupal\snippet_manager\SnippetInterface $entity */
    $row['name'] = $entity->toLink();
    $row['id'] = $entity->id();

    if ($entity->status()) {
      $row['status'] = $this->t('Enabled');
    }
    else {
      $row['status']['data'] = $this->t('Disabled');
      $row['status']['class'] = ['sm-inactive'];
    }

    $template = $entity->get('template');
    $row['size'] = $this->formatSize(strlen($template['value']));

    if ($format_label = $this->getFormatLabel($template['format'])) {
      $row['format'] = $format_label;
    }
    else {
      $row['format']['data'] = $template['format'];
      $row['format']['class'] = ['sm-inactive'];
    }

    $page = $entity->get('page');
    if ($page['status']) {
      if (strpos($page['path'], '%') === FALSE) {
        $url = Url::fromUri('internal:/' . $page['path']);
        $row['page'] = Link::fromTextAndUrl($page['path'], $url);
      }
      else {
        $row['page'] = $page['path'];
      }
    }
    else {
      $row['page'] = '';
    }

    $block = $entity->get('block');
    if ($block['status']) {
      $row['block'] = $block['name'] ?: $entity->label();
    }
    else {
      $row['block'] = '';
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

    if (isset($operations['enable'])) {
      $operations['enable']['weight'] = 150;
    }

    if (isset($operations['disable'])) {
      $operations['disable']['weight'] = 150;
    }

    return $operations;
  }

  /**
   * {@inheritdoc}
   */
  public function render() {
    $build = parent::render();

    $build['filters'] = [
      '#type' => 'search',
      '#title' => $this->t('Filter snippets'),
      '#title_display' => 'invisible',
      '#size' => 30,
      '#weight' => -10,
      '#placeholder' => $this->t('Filter by snippet name or ID'),
      '#attributes' => [
        'data-drupal-selector' => ['sm-snippet-filter'],
        'autocomplete' => 'off',
      ],
    ];

    $build['table']['#attributes']['class'][] = 'sm-snippets-overview';
    $build['table']['#attributes']['data-drupal-selector'] = 'sm-snippet-list';
    $build['#attached']['library'][] = 'snippet_manager/listing';
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
