<?php

namespace Drupal\snippet_manager\Tests;

/**
 * Tests view variable plugin.
 *
 * @group snippet_manager
 */
class ViewVariableTest extends TestBase {

  /**
   * {@inheritdoc}
   */
  public static $modules = [
    'snippet_manager',
    'snippet_manager_test',
    'views',
  ];

  /**
   * {@inheritdoc}
   */
  protected $extraPermissions = ['access user profiles'];

  /**
   * Tests view variable plugin.
   *
   * @todo Test operations.
   */
  public function testViewVariable() {

    $edit = [
      'plugin_id' => 'view:who_s_online',
      'name' => 'who_s_online',
    ];
    $this->drupalPostForm('admin/structure/snippet/alpha/edit/variable/add', $edit, 'Save and continue');
    $this->assertStatusMessage('The variable has been created.');

    $edit = [
      'configuration[display]' => 'default',
    ];
    $this->drupalPostForm(NULL, $edit, 'Save');

    $edit = [
      'template[value]' => '<div class="snippet-content">{{ who_s_online }}</div>',
    ];
    $this->drupalPostForm(NULL, $edit, 'Save');

    $this->drupalGet('admin/structure/snippet/alpha');

    $this->assertByXpath('//div[@class="snippet-content"]/div[contains(@class, "view-display-id-default")]/div[@class="view-content"]');

    // Change view display and test view appearance.
    $edit = [
      'configuration[display]' => 'who_s_online_block',
    ];
    $this->drupalPostForm('admin/structure/snippet/alpha/edit/variable/who_s_online/edit', $edit, 'Save');
    $this->drupalGet('admin/structure/snippet/alpha');

    $this->assertByXpath('//div[@class="snippet-content"]/div[contains(@class, "view-display-id-who_s_online_block")]/div[@class="view-content"]');

  }

}
