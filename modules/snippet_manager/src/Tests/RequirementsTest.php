<?php

namespace Drupal\snippet_manager\Tests;

/**
 * Tests snippet_manager_requirements().
 *
 * @group snippet_manager
 */
class RequirementsTest extends TestBase {

  /**
   * {@inheritdoc}
   */
  protected $extraPermissions = ['administer site configuration'];

  /**
   * Tests snippet_manager_requirements().
   */
  public function testSnippetRequirements() {
    $this->drupalGet('admin/reports/status');
    $text = file_exists(DRUPAL_ROOT . '/libraries/codemirror/lib/codemirror.js') ?
      'Installed' :
      'You need to download the CodeMirror library and extract the archive to the libraries/codemirror directory on your server.';
    $this->assertNoText($text);
    $this->drupalPostForm('admin/structure/snippet/settings', ['codemirror[cdn]' => FALSE], 'Save configuration');
    $this->drupalGet('admin/reports/status');
    $this->assertText($text);
  }

}
