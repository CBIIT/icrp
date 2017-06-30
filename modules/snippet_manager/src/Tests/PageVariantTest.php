<?php

namespace Drupal\snippet_manager\Tests;

/**
 * Tests snippet page variant.
 *
 * @group snippet_manager
 */
class PageVariantTest extends TestBase {

  /**
   * Tests snippet page variant.
   */
  public function testSnippetPageVariant() {

    // Alpha just says "Hello world!".
    drupal_flush_all_caches();
    \Drupal::state()->set('page_variant_snippet', 'alpha');
    $this->drupalGet('<front>');
    $this->assertText('Hello world!');

    // Beta displays main content converted to upper case.
    drupal_flush_all_caches();
    \Drupal::state()->set('page_variant_snippet', 'beta');
    $this->drupalGet('<front>');
    $this->assertTextPattern('/MEMBER FOR [0-9]{1,3}/');

    // Check if default page variant still works.
    drupal_flush_all_caches();
    \Drupal::state()->set('page_variant_snippet', NULL);
    $this->drupalGet('<front>');
    $this->assertTextPattern('/Member for [0-9]{1,3}/');
  }

}
