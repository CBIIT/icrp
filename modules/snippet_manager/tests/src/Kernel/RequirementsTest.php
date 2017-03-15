<?php

namespace Drupal\Tests\snippet_manager\Kernel;

use Drupal\KernelTests\KernelTestBase;

/**
 * Tests for the hook_requirements().
 *
 * @group snippet_manager
 */
class RequirementsTest extends KernelTestBase {

  /**
   * {@inheritdoc}
   */
  public static $modules = ['snippet_manager'];

  /**
   * Test callback.
   */
  public function testRequirements() {
    module_load_include('install', 'snippet_manager');

    $requirements = snippet_manager_requirements('runtime');

    // It's not possible to mock this path because of DRUPAL_ROOT constant.
    if (file_exists(DRUPAL_ROOT . '/libraries/codemirror/lib/codemirror.js')) {
      $expected_requirements['snippet_manager_codemirror'] = [
        'title' => t('CodeMirror library'),
        'value' => t('Installed'),
        'severity' => REQUIREMENT_INFO,
      ];
    }
    else {
      $description = t(
        'You need to download the <a href=":library_url">CodeMirror library</a> and extract the archive to the <em>libraries/codemirror</em> directory on your server.',
        [':library_url' => 'https://codemirror.net/']
      );
      $expected_requirements['snippet_manager_codemirror'] = [
        'title' => t('CodeMirror library'),
        'value' => t('Not found'),
        'severity' => REQUIREMENT_ERROR,
        'description' => $description,
      ];
    }

    $this->assertEquals($requirements, $expected_requirements);
    $this->config('snippet_manager.settings')->set('codemirror.cdn', TRUE)->save();
    $requirements = snippet_manager_requirements('runtime');
    $this->assertEquals($requirements, []);
  }

}
