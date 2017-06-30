<?php

namespace Drupal\snippet_manager\Tests;

/**
 * Tests condition variable plugin.
 *
 * @group snippet_manager
 */
class ConditionVariableTest extends TestBase {

  /**
   * {@inheritdoc}
   */
  public static $modules = [
    'snippet_manager',
    'snippet_manager_test',
    'node',
  ];

  /**
   * Tests condition variable plugin.
   */
  public function testConditionVariable() {

    \Drupal::state()->set('show_snippet', 'alpha');

    $edit = [
      'plugin_id' => 'condition:request_path',
      'name' => 'node_page',
    ];
    $this->drupalPostForm('admin/structure/snippet/alpha/edit/variable/add', $edit, 'Save and continue');
    $this->assertStatusMessage('The variable has been created.');

    $edit = [
      'configuration[condition][pages]' => '/node',
    ];
    $this->drupalPostForm('admin/structure/snippet/alpha/edit/variable/node_page/edit', $edit, 'Save');

    $edit = [
      'template[value]' => "{% if node_page %}Foo{% else %}Bar{% endif %}",
    ];
    $this->drupalPostForm(NULL, $edit, 'Save');

    drupal_flush_all_caches();

    $this->drupalGet('node');
    $this->assertText('Foo');
    $this->assertNoText('Bar');

    $this->drupalGet('user');
    $this->assertText('Bar');
    $this->assertNoText('Foo');

    // Negate the condition.
    $edit = [
      'configuration[condition][negate]' => TRUE,
    ];
    $this->drupalPostForm('admin/structure/snippet/alpha/edit/variable/node_page/edit', $edit, 'Save');

    drupal_flush_all_caches();

    $this->drupalGet('node');
    $this->assertText('Bar');
    $this->assertNoText('Foo');

    $this->drupalGet('user');
    $this->assertText('Foo');
    $this->assertNoText('Bar');
  }

}
