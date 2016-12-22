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
    $this->directoryList = ['snippet_manager' => 'modules/snippet_manager'];
    parent::setUp();
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
          'entity.snippet.view_admin',
        ],
      ]
    );
  }

}
