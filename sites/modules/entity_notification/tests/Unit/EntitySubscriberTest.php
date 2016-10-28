<?php

namespace Drupal\Tests\entity_notification\Unit;

use Drupal\Core\Entity\EntityInterface;
use Drupal\Core\Mail\MailManagerInterface;
use Drupal\entity_notification\EntitySubscriber;
use Drupal\Tests\UnitTestCase;
use Prophecy\Argument;

/**
 * @coversDefaultClass \Drupal\entity_notification\EntitySubscriber
 * @group entity_notification
 */
class EntitySubscriberTest extends UnitTestCase {

  /**
   * @covers ::onCallback
   */
  public function testMissingConfiguration() {
    $mail_manager = $this->prophesize(MailManagerInterface::class);
    $mail_manager->mail(Argument::cetera())->shouldNotBeCalled();

    $config_factory = $this->getConfigFactoryStub(['entity_notification.settings' => []]);

    $entity = $this->prophesize(EntityInterface::class);
    $entity->getEntityTypeId()->willReturn('entity_test')->shouldBeCalled();

    $entity_subscriber = new EntitySubscriber($config_factory, $mail_manager->reveal());

    $entity_subscriber->onCreate($entity->reveal());
    $entity_subscriber->onUpdate($entity->reveal());
    $entity_subscriber->onDelete($entity->reveal());
  }

  /**
   * @covers ::onCreate
   * @covers ::onCallback
   */
  public function testWithConfigurationOnCreate() {
    $mail_config = [
      'to' => 'giraffe@example.com',
      'subject' => '',
      'body' => ''
    ];

    $entity = $this->prophesize(EntityInterface::class);
    $entity->getEntityTypeId()->willReturn('entity_test')->shouldBeCalled();

    $mail_manager = $this->prophesize(MailManagerInterface::class);
    $mail_manager->mail('entity_notification', 'notification', 'giraffe@example.com', 'en', ['config' => $mail_config, 'entity' => $entity])->shouldBeCalled();

    $config_factory = $this->getConfigFactoryStub(['entity_notification.settings' => ['configuration.entity_test.create' => $mail_config]]);

    $entity_subscriber = new EntitySubscriber($config_factory, $mail_manager->reveal());

    $entity_subscriber->onCreate($entity->reveal());
  }

  /**
   * @covers ::onUpdate
   * @covers ::onCallback
   */
  public function testWithConfigurationOnUpdate() {
    $mail_config = [
      'to' => 'giraffe@example.com',
      'subject' => '',
      'body' => ''
    ];

    $entity = $this->prophesize(EntityInterface::class);
    $entity->getEntityTypeId()->willReturn('entity_test')->shouldBeCalled();

    $mail_manager = $this->prophesize(MailManagerInterface::class);
    $mail_manager->mail('entity_notification', 'notification', 'giraffe@example.com', 'en', ['config' => $mail_config, 'entity' => $entity])->shouldBeCalled();

    $config_factory = $this->getConfigFactoryStub(['entity_notification.settings' => ['configuration.entity_test.update' => $mail_config]]);

    $entity_subscriber = new EntitySubscriber($config_factory, $mail_manager->reveal());

    $entity_subscriber->onUpdate($entity->reveal());
  }

  /**
   * @covers ::onDelete
   * @covers ::onCallback
   */
  public function testWithConfigurationOnDelete() {
    $mail_config = [
      'to' => 'giraffe@example.com',
      'subject' => '',
      'body' => ''
    ];

    $entity = $this->prophesize(EntityInterface::class);
    $entity->getEntityTypeId()->willReturn('entity_test')->shouldBeCalled();

    $mail_manager = $this->prophesize(MailManagerInterface::class);
    $mail_manager->mail('entity_notification', 'notification', 'giraffe@example.com', 'en', ['config' => $mail_config, 'entity' => $entity])->shouldBeCalled();

    $config_factory = $this->getConfigFactoryStub(['entity_notification.settings' => ['configuration.entity_test.delete' => $mail_config]]);

    $entity_subscriber = new EntitySubscriber($config_factory, $mail_manager->reveal());

    $entity_subscriber->onDelete($entity->reveal());
  }

}
