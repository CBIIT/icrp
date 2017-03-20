<?php

namespace Drupal\Tests\snippet_manager\Functional;

use Drupal\Core\Url;

/**
 * Default context test.
 *
 * @group snippet_manager
 */
class DefaultContextTest extends TestBase {

  /**
   * Tests default context.
   */
  public function testDefaultContext() {
    $this->drupalGet('admin/structure/snippet/gamma');
    $prefix = '//ol[@class="default-context"]';
    $this->assertByXpath($prefix . '/li[1][. = "classy"]');
    $this->assertByXpath($prefix . '/li[2][. = "core/themes/classy"]');
    $this->assertByXpath($prefix . sprintf('/li[3][. = "%s"]', base_path()));
    $this->assertByXpath($prefix . sprintf('/li[4][. = "%s"]', Url::fromRoute('<front>')->toString()));
    $this->assertByXpath($prefix . '/li[5][. = ""]');
    $this->assertByXpath($prefix . '/li[6][. = ""]');
    $this->assertByXpath($prefix . '/li[7][. = "1"]');
    // This one comes from alter hook.
    $this->assertByXpath($prefix . '/li[8][. = "Foo"]');
    $this->assertByXpath($prefix . '/li[9][. = "Bar"]');
  }

}
