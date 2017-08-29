<?php

namespace Drupal\Tests\snippet_manager\Unit;

use Drupal\Tests\Core\Menu\LocalTaskIntegrationTestBase;

/**
 * Tests snippet manager local tasks.
 *
 * @group snippet_manager
 */
class LocalTasksTest extends LocalTaskIntegrationTestBase {

  /**
   * {@inheritdoc}
   */
  protected function setUp() {
    parent::setUp();
    // drupal_get_path() is not allowed here.
    $module_path = substr(__DIR__, strlen($this->root) + 1) . '/../../..';
    $this->directoryList = ['snippet_manager' => $module_path];
  }

  /**
   * Tests local task existence.
   */
  public function testActionLocalTasks() {
    $this->assertLocalTasks(
      'entity.snippet.collection',
      [
        [
          'entity.snippet.collection',
          'snippet_manager.settings',
        ],
      ]
    );
    $this->assertLocalTasks(
      'entity.snippet.canonical',
      [
        [
          'entity.snippet.view',
          'entity.snippet.edit_form',
          'entity.snippet.delete_form',
        ],
        [
          'entity.snippet.view_canonical',
          'entity.snippet.view_source',
        ],
      ]
    );
    $this->assertLocalTasks(
      'entity.snippet.edit_form',
      [
        [
          'entity.snippet.view',
          'entity.snippet.edit_form',
          'entity.snippet.delete_form',
        ],
        [
          'entity.snippet.edit_general',
          'entity.snippet.edit_template',
          'entity.snippet.edit_css',
          'entity.snippet.edit_js',
        ],
      ]
    );
  }

}
