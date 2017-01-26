<?php

namespace Drupal\Tests\feeds\Unit\Plugin\QueueWorker;

use Drupal\Core\DependencyInjection\ContainerBuilder;
use Drupal\feeds\Event\FeedsEvents;
use Drupal\feeds\Feeds\Item\DynamicItem;
use Drupal\feeds\Plugin\QueueWorker\FeedProcess;
use Drupal\feeds\Result\FetcherResult;
use Drupal\feeds\StateInterface;
use Drupal\Tests\feeds\Unit\FeedsUnitTestCase;
use Symfony\Component\EventDispatcher\EventDispatcher;

/**
 * @coversDefaultClass \Drupal\feeds\Plugin\QueueWorker\FeedProcess
 * @group feeds
 */
class FeedProcessTest extends FeedsUnitTestCase {

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
      ->will($this->returnValue($this->getMock('Drupal\Core\Queue\QueueInterface')));

    $container->set('queue', $queue_factory);
    $container->set('event_dispatcher', $this->dispatcher);
    $container->set('account_switcher', $this->getMockedAccountSwitcher());

    $this->plugin = FeedProcess::create($container, [], 'feeds_feed_process', []);
    $this->feed = $this->getMockFeed();
  }

  public function test() {
    $this->plugin->processItem([$this->feed, new DynamicItem()]);
  }

  /**
   * @expectedException \RuntimeException
   */
  public function testException() {
    $this->dispatcher->addListener(FeedsEvents::PROCESS, function ($parse_event) {
      throw new \RuntimeException();
    });

    $this->plugin->processItem([$this->feed, new DynamicItem()]);
  }

  public function testFinalPass() {
    $this->plugin->processItem([$this->feed, new FetcherResult('')]);

    $this->feed->expects($this->exactly(2))
      ->method('progressParsing')
      ->will($this->returnValue(StateInterface::BATCH_COMPLETE));

    $this->plugin->processItem([$this->feed, new FetcherResult('')]);
    $this->feed->expects($this->once())
      ->method('progressFetching')
      ->will($this->returnValue(StateInterface::BATCH_COMPLETE));
    $this->plugin->processItem([$this->feed, new FetcherResult('')]);
  }

}
