<?php

namespace Drupal\snippet_manager\Tests;

use Drupal\Component\Utility\Html;

/**
 * Tests CodeMirror library assets.
 *
 * @group snippet_manager
 */
class CodeMirrorAssetsTest extends TestBase {

  /**
   * {@inheritdoc}
   */
  public static $modules = [
    'snippet_manager',
    'snippet_manager_test',
  ];

  /**
   * Tests that CodeMirror assets are loaded properly.
   */
  public function testAssets() {

    $this->drupalGet('admin/structure/snippet/alpha/edit');

    $codemirror_version = '5.14.2';

    $css_files = [
      'codemirror.css',
      'addon/fold/foldgutter.css',
      'addon/display/fullscreen.css',
    ];

    $js_files = [
      'codemirror.js',
      'mode/javascript/javascript.js',
      'mode/xml/xml.js',
      'mode/twig/twig.js',
      'mode/css/css.js',
      'addon/fold/foldcode.js',
      'addon/fold/brace-fold.js',
      'addon/fold/xml-fold.js',
      'addon/fold/comment-fold.js',
      'addon/display/fullscreen.js',
    ];

    // Check CDN mode.
    foreach ($css_files as $file) {
      $this->assertByXpath('//head/link[@rel="stylesheet" and @href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/' . $codemirror_version . '/' . $file . '"]');
    }

    foreach ($js_files as $file) {
      $this->assertByXpath('//body/script[@src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/' . $codemirror_version . '/' . $file . '"]');
    }

    // Check local mode and non-default theme.
    $config = \Drupal::service('config.factory')->getEditable('snippet_manager.settings');
    $codemirror_settings = $config->get('codemirror');
    $codemirror_settings['theme'] = '3024-day';
    $codemirror_settings['cdn'] = FALSE;
    $config->set('codemirror', $codemirror_settings)->save();

    // Invalidate cache discovery to rebuild asserts.
    \Drupal::service('cache_tags.invalidator')->invalidateTags(['library_info']);

    $this->drupalGet('admin/structure/snippet/alpha/edit');

    $imports = explode("\n", $this->xpath('//head/style')[0]);
    $query_string = \Drupal::state()->get('system.css_js_query_string');

    // Add theme CSS file.
    $css_files[] = 'theme/3024-day.css';
    foreach ($css_files as $file) {
      if ($file == 'codemirror.css') {
        $file = 'lib/' . $file;
      }
      $file = 'libraries/codemirror/' . $file;
      $import = '@import url("' . Html::escape(file_url_transform_relative(file_create_url($file)) . '?' . $query_string) . '");';
      $this->assertTrue(in_array($import, $imports), 'CSS file has been found.');
    }

    foreach ($js_files as $file) {
      if ($file == 'codemirror.js') {
        $file = 'lib/' . $file;
      }
      $file = 'libraries/codemirror/' . $file . '?v=' . $codemirror_version;
      $file = file_url_transform_relative(file_create_url($file));
      $this->assertByXpath('//body/script[@src="' . $file . '"]', 'JS file has been found');
    }

  }

}
