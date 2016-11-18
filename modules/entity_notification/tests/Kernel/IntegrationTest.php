<?php

namespace Drupal\Tests\entity_notification\Kernel;

use Drupal\KernelTests\KernelTestBase;
use Drupal\user\Entity\User;

/**
 * Provides some integration level test coverage.
 *
 * @group entity_notification
 */
class IntegrationTest extends KernelTestBase {

  /**
   * {@inheritdoc}
   */
  public static $modules = ['entity_notification', 'user', 'system'];

  /**
   * {@inheritdoc}
   */
  protected function setUp() {
    parent::setUp();

    $this->installEntitySchema('user');
    $this->installSchema('system', 'sequences');
    $this->installSchema('user', 'users_data');

    \Drupal::configFactory()->getEditable('system.mail')
      ->set('interface.default', 'test_mail_collector')
      ->save();
  }

  public function testMail() {
    $config = \Drupal::configFactory()->getEditable('entity_notification.settings');

    $config->set('configuration.user.create', [
      'to' => 'foo@example.com',
      'subject' => 'subject create [user:uid]',
      'body' => 'body create [user:uid]',
    ]);
    $config->set('configuration.user.update', [
      'to' => 'foo@example.com',
      'subject' => 'subject update [user:uid]',
      'body' => 'body update [user:uid]',
    ]);
    $config->set('configuration.user.delete', [
      'to' => 'foo@example.com',
      'subject' => 'subject delete [user:uid]',
      'body' => 'body delete [user:uid]',
    ]);
    $config->save();

    $user = User::create([
      'name' => 'test',
    ]);
    $user->save();

    $user->name->value = 'foo';
    $user->save();
    $user->delete();

    $this->assertMailCount(3);

    $mails = $this->getMails();
    $this->assertEquals('foo@example.com', $mails[0]['to']);
    $this->assertEquals('foo@example.com', $mails[1]['to']);
    $this->assertEquals('foo@example.com', $mails[2]['to']);

    $this->assertEquals('subject create 1', $mails[0]['subject']);
    $this->assertEquals('subject update 1', $mails[1]['subject']);
    $this->assertEquals('subject delete 1', $mails[2]['subject']);

    $this->assertEquals('body create 1' . PHP_EOL, $mails[0]['body']);
    $this->assertEquals('body update 1' . PHP_EOL, $mails[1]['body']);
    $this->assertEquals('body delete 1' . PHP_EOL, $mails[2]['body']);
  }

  /**
   * @param int $expected_count
   */
  protected function assertMailCount($expected_count) {
    $mail = \Drupal::state()->get('system.test_mail_collector', []);
    $this->assertCount($expected_count, $mail);
  }

  /**
   * @return array
   */
  protected function getMails() {
    $mail = \Drupal::state()->get('system.test_mail_collector');
    return $mail;
  }

}
