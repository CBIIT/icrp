<?php

namespace Drupal\entity_notification;

use Drupal\Core\Utility\Token;

class NotificationMail {

  /**
   * The token replacement service.
   *
   * @var \Drupal\Core\Utility\Token
   */
  protected $token;

  /**
   * Creates a new NotificationMail instance.
   *
   * @param \Drupal\Core\Utility\Token $token
   *   The token replacement service.
   */
  public function __construct(Token $token) {
    $this->token = $token;
  }

  /**
   * @see hook_mail()
   */
  public function mail($key, &$message, $params) {
    if ($key == 'notification') {
      $this->notificationMail($key, $message, $params);
    }

    return $this;
  }

  protected function notificationMail($key, &$message, $params) {
    /** @var \Drupal\Core\Entity\EntityInterface $entity */
    $entity = $params['entity'];
    $message['subject'] = $this->token->replace($params['config']['subject'], [$entity->getEntityTypeId() => $entity]);
    $message['body'] = [$this->token->replace($params['config']['body'], [$entity->getEntityTypeId() => $entity])];
  }

}
