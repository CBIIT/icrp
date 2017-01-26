<?php

namespace Drupal\feeds\Plugin\QueueWorker;

use Drupal\feeds\Event\FeedsEvents;
use Drupal\feeds\Event\InitEvent;
use Drupal\feeds\Event\ProcessEvent;
use Drupal\feeds\FeedInterface;
use Drupal\feeds\Result\FetcherResultInterface;
use Drupal\feeds\StateInterface;

/**
 * @QueueWorker(
 *   id = "feeds_feed_process",
 *   title = @Translation("Feed process"),
 *   cron = {"time" = 60},
 *   deriver = "Drupal\feeds\Plugin\Derivative\FeedQueueWorker"
 * )
 */
class FeedProcess extends FeedQueueWorkerBase {

  /**
   * {@inheritdoc}
   */
  public function processItem($data) {
    list($feed, $item) = $data;

    $switcher = $this->switchAccount($feed);

    try {
      if ($item instanceof FetcherResultInterface) {
        $this->finish($feed, $item);
        return;
      }

      $this->dispatchEvent(FeedsEvents::INIT_IMPORT, new InitEvent($feed, 'process'));
      $this->dispatchEvent(FeedsEvents::PROCESS, new ProcessEvent($feed, $item));

      $feed->saveStates();
    }
    catch (\Exception $exception) {
      return $this->handleException($feed, $exception);
    }
    finally {
      $switcher->switchBack();
    }
  }

  /**
   * Finalizes the import.
   */
  protected function finish(FeedInterface $feed, FetcherResultInterface $fetcher_result) {
    if ($feed->progressParsing() !== StateInterface::BATCH_COMPLETE) {
      $this->queueFactory->get('feeds_feed_import:' . $feed->bundle())->createItem($feed);
    }
    elseif ($feed->progressFetching() !== StateInterface::BATCH_COMPLETE) {
      $this->queueFactory->get('feeds_feed_parse:' . $feed->bundle())->createItem([$feed, $fetcher_result]);
    }
    else {
      $feed->finishImport();
    }
  }

}
