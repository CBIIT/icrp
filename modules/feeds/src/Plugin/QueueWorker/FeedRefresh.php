<?php

namespace Drupal\feeds\Plugin\QueueWorker;

use Drupal\feeds\Event\FeedsEvents;
use Drupal\feeds\Event\FetchEvent;
use Drupal\feeds\Event\InitEvent;
use Drupal\feeds\Exception\LockException;
use Drupal\feeds\FeedInterface;
use Drupal\feeds\StateInterface;

/**
 * @QueueWorker(
 *   id = "feeds_feed_import",
 *   title = @Translation("Feed refresh"),
 *   cron = {"time" = 60},
 *   deriver = "Drupal\feeds\Plugin\Derivative\FeedQueueWorker"
 * )
 */
class FeedRefresh extends FeedQueueWorkerBase {

  /**
   * {@inheritdoc}
   */
  public function processItem($feed) {
    if (!$feed instanceof FeedInterface) {
      return;
    }

    try {
      $feed->lock();
    }
    catch (LockException $e) {
      return;
    }

    $switcher = $this->switchAccount($feed);

    try {
      $feed->clearStates();

      $this->dispatchEvent(FeedsEvents::INIT_IMPORT, new InitEvent($feed, 'fetch'));
      $fetch_event = $this->dispatchEvent(FeedsEvents::FETCH, new FetchEvent($feed));
      $feed->setState(StateInterface::PARSE, NULL);

      $feed->saveStates();
      $this->queueFactory->get('feeds_feed_parse:' . $feed->bundle())
        ->createItem([$feed, $fetch_event->getFetcherResult()]);
    }
    catch (\Exception $exception) {
      return $this->handleException($feed, $exception);
    }
    finally {
      $switcher->switchBack();
    }
  }

}
