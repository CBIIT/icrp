<?php

namespace Drupal\Tests\feeds\Unit\Plugin\QueueWorker;

use Drupal\Core\DependencyInjection\ContainerBuilder;
use Drupal\feeds\Event\FeedsEvents;
use Drupal\feeds\Feeds\Item\DynamicItem;
use Drupal\feeds\Plugin\QueueWorker\FeedParse;
use Drupal\feeds\Result\FetcherResult;
use Drupal\feeds\Result\ParserResult;
use Drupal\Tests\feeds\Unit\FeedsUnitTestCase;
use Symfony\Component\EventDispatcher\EventDispatcher;

/**
 * @coversDefaultClass \Drupal\feeds\Plugin\QueueWorker\FeedParse
 * @group feeds
 */
class FeedParseTest extends FeedsUnitTestCase {

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
      ->with('feeds_feed_process:')
      ->will($this->returnValue($this->getMock('Drupal\Core\Queue\QueueInterface')));

    $container->set('queue', $queue_factory);
    $container->set('event_dispatcher', $this->dispatcher);
    $container->set('account_switcher', $this->getMockedAccountSwitcher());

    $this->plugin = FeedParse::create($container, [], 'feeds_feed_parse', []);
    $this->feed = $this->getMockFeed();
  }

  public function test() {
    $this->dispatcher->addListener(FeedsEvents::PARSE, function ($parse_event) {
      $parser_result = new ParserResult();
      $parser_result->addItem(new DynamicItem());
      $parse_event->setParserResult($parser_result);
    });

    $fetcher_result = new FetcherResult('');

    $this->plugin->processItem([$this->feed, $fetcher_result]);
  }

  /**
   * @expectedException \RuntimeException
   */
  public function testException() {
    $this->dispatcher->addListener(FeedsEvents::PARSE, function ($parse_event) {
      throw new \RuntimeException();
    });

    $this->plugin->processItem([$this->feed, new FetcherResult('')]);
  }

}
