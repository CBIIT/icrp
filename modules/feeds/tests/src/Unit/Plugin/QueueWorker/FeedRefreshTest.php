<?php

namespace Drupal\Tests\feeds\Unit\Plugin\QueueWorker;

use Drupal\Core\DependencyInjection\ContainerBuilder;
use Drupal\feeds\Event\FeedsEvents;
use Drupal\feeds\Exception\LockException;
use Drupal\feeds\Plugin\QueueWorker\FeedRefresh;
use Drupal\Tests\feeds\Unit\FeedsUnitTestCase;
use Symfony\Component\EventDispatcher\EventDispatcher;

/**
 * @coversDefaultClass \Drupal\feeds\Plugin\QueueWorker\FeedRefresh
 * @group feeds
 */
class FeedRefreshTest extends FeedsUnitTestCase {

  protected $dispatcher;
  protected $plugin;
  protected $feed;

  public function setUp() {
    parent::setUp();
    $container = new ContainerBuilder();
    $this->dispatcher = new EventDispatcher();
    $queue_factory = $this->getMock('Drupal\Core\Queue\QueueFactory', [], [], '', FALSE);
    $queue_factory->expects($this->any())
      ->method('get')
      ->with('feeds_feed_parse:')
      ->will($this->returnValue($this->getMock('Drupal\Core\Queue\QueueInterface')));

    $container->set('queue', $queue_factory);
    $container->set('event_dispatcher', $this->dispatcher);
    $container->set('account_switcher', $this->getMockedAccountSwitcher());

    $this->plugin = FeedRefresh::create($container, [], 'feeds_feed_parse', []);
    $this->feed = $this->getMockFeed();
  }

  public function test() {
    $this->plugin->processItem(NULL);
    $this->plugin->processItem($this->feed);
  }

  public function testLockException() {
    $this->feed->expects($this->once())
      ->method('lock')
      ->will($this->throwException(new LockException()));
    $this->plugin->processItem($this->feed);
  }

  /**
   * @expectedException \RuntimeException
   */
  public function testException() {
    $this->dispatcher->addListener(FeedsEvents::FETCH, function ($parse_event) {
      throw new \RuntimeException();
    });

    $this->plugin->processItem($this->feed);
  }

}
