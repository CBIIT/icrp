<?php

namespace Drupal\feeds\Plugin\QueueWorker;

use Drupal\feeds\Event\FeedsEvents;
use Drupal\feeds\Event\InitEvent;
use Drupal\feeds\Event\ParseEvent;
use Drupal\feeds\StateInterface;

/**
 * @QueueWorker(
 *   id = "feeds_feed_parse",
 *   title = @Translation("Feed parse"),
 *   cron = {"time" = 60},
 *   deriver = "Drupal\feeds\Plugin\Derivative\FeedQueueWorker"
 * )
 */
class FeedParse extends FeedQueueWorkerBase {

  /**
   * {@inheritdoc}
   */
  public function processItem($data) {
    list($feed, $fetcher_result) = $data;

    $switcher = $this->switchAccount($feed);

    try {
      $this->dispatchEvent(FeedsEvents::INIT_IMPORT, new InitEvent($feed, 'parse'));
      $parse_event = $this->dispatchEvent(FeedsEvents::PARSE, new ParseEvent($feed, $fetcher_result));
      $feed->setState(StateInterface::PROCESS, NULL);

      $feed->saveStates();
      $queue = $this->queueFactory->get('feeds_feed_process:' . $feed->bundle());

      foreach ($parse_event->getParserResult() as $item) {
        $queue->createItem([$feed, $item]);
      }
      // Add a final process queue item that finalizes the import.
      $queue->createItem([$feed, $fetcher_result]);
    }
    catch (\Exception $exception) {
      return $this->handleException($feed, $exception);
    }
    finally {
      $switcher->switchBack();
    }
  }

}
