<?php

namespace Drupal\snippet_manager\Tests;

/**
 * Tests text variable plugin.
 *
 * @group snippet_manager
 */
class TextVariableTest extends TestBase {

  /**
   * Tests text variable plugin.
   */
  public function testTextVariable() {
    $edit = [
      'plugin_id' => 'text',
      'name' => 'beer',
    ];

    $this->drupalPostForm('admin/structure/snippet/alpha/edit/variable/add', $edit, 'Save and continue');

    $this->assertByXpath('//select[@name="configuration[content][format]"]/option[@value="snippet_manager_test_basic_format" and @selected="selected"]');
    $this->assertByXpath('//select[@name="configuration[content][format]"]/option[@value="snippet_manager_test_restricted_format"]');

    $edit = [
      'configuration[content][value]' => '<p>Dark</p><span>Light</span>',
      'configuration[content][format]' => 'snippet_manager_test_basic_format',
    ];
    $this->drupalPostForm(NULL, $edit, 'Save');

    $edit = [
      'template[value]' => '<div class="snippet-content">-={{ beer }}=-</div>',
    ];
    $this->drupalPostForm(NULL, $edit, 'Save');

    $this->drupalGet('admin/structure/snippet/alpha');

    $this->assertByXpath('//div[@class="snippet-content"]/p[text() = "Dark"]');
    $result = $this->xpath('//div[@class="snippet-content"]/span');
    $this->assertFalse(isset($result[0]));

    $edit = [
      'configuration[content][format]' => 'snippet_manager_test_restricted_format',
    ];
    $this->drupalPostForm('admin/structure/snippet/alpha/edit/variable/beer/edit', $edit, 'Save');

    $this->drupalGet('admin/structure/snippet/alpha');

    $this->assertByXpath('//div[@class="snippet-content"]/span[text() = "Light"]');
    $result = $this->xpath('//div[@class="snippet-content"]/p');
    $this->assertFalse(isset($result[0]));
  }

}
