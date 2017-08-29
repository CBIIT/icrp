<?php

namespace Drupal\Tests\snippet_manager\Functional;

/**
 * Snippet status test.
 *
 * @group snippet_manager
 */
class EnableDisableTest extends TestBase {

  /**
   * Tests snippet status actions.
   */
  public function testDefaultContext() {
    $this->drupalGet('admin/structure/snippet');
    $this->assertByXpath('//td[.="alpha"]/../td[3][.="Enabled"]');

    $this->click('//td[.="alpha"]/../td//li/a[.="Disable"]');
    $this->assertByXpath('//td[.="alpha"]/../td[3][.="Disabled"]');
    $this->assertStatusMessage(t('Snippet %label has been disabled.', ['%label' => 'Alpha']));

    $this->click('//td[.="alpha"]/../td//li/a[.="Enable"]');
    $this->assertByXpath('//td[.="alpha"]/../td[3][.="Enabled"]');
  }

}
