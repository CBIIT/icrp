<?php

namespace Drupal\entity_notification;

use Drupal\Core\Config\ConfigFactoryInterface;
use Drupal\Core\Entity\EntityInterface;
use Drupal\Core\Mail\MailManagerInterface;

class EntitySubscriber {

  /**
   * The config factory.
   *
   * @var \Drupal\Core\Config\ConfigFactoryInterface
   */
  protected $configFactory;

  /**
   * The mail manager.
   *
   * @var \Drupal\Core\Mail\MailManagerInterface
   */
  protected $mailManager;

  /**
   * Creates a new EntitySubscriber instance.
   *
   * @param \Drupal\Core\Config\ConfigFactoryInterface $configFactory
   *   The config factory.
   */
  public function __construct(ConfigFactoryInterface $configFactory, MailManagerInterface $mail_manager) {
    $this->configFactory = $configFactory;
    $this->mailManager = $mail_manager;
  }

  public function onCreate(EntityInterface $entity) {
    $this->onCallback('create', $entity);
  }

  public function onUpdate(EntityInterface $entity) {
    $this->onCallback('update', $entity);
  }

  public function onDelete(EntityInterface $entity) {
    $this->onCallback('delete', $entity);
  }

  protected function onCallback($operation, EntityInterface $entity) {
    $config = $this->configFactory->get('entity_notification.settings');
    if ($entity_configuration = $config->get('configuration.' . $entity->getEntityTypeId() . '.' . $operation)) {
      $to = $entity_configuration['to'];
      $this->mailManager->mail('entity_notification', 'notification', $to, 'en', ['config' => $entity_configuration, 'entity' => $entity]);
    }
  }

}
