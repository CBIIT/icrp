<?php

namespace Drupal\Tests\snippet_manager\Functional;

use Drupal\Tests\BrowserTestBase;

/**
 * Base class for Snippet manager browser tests.
 */
abstract class TestBase extends BrowserTestBase {

  /**
   * {@inheritdoc}
   */
  public static $modules = ['snippet_manager', 'snippet_manager_test'];

  /**
   * Checks that an element specified by a the xpath exists on the current page.
   */
  protected function assertByXpath($xpath) {
    $this->assertSession()->elementExists('xpath', $xpath);
  }

}
