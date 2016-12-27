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
    $header['page'] = $this->t('Page');
    return $header + parent::buildHeader();
  }

  /**
   * {@inheritdoc}
   */
  public function buildRow(EntityInterface $entity) {
    /** @var \Drupal\snippet_manager\SnippetInterface $entity */
    $row['label'] = $entity->toLink();
    $row['id'] = $entity->id();
    $row['status'] = $entity->status() ? $this->t('Enabled') : $this->t('Disabled');
    $row['page'] = $entity->pageIsPublished() ? $this->t('Published') : $this->t('Not published');
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

}
