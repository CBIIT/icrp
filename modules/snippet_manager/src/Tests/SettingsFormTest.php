<?php

namespace Drupal\snippet_manager\Tests;

/**
 * Tests settings form.
 *
 * @group snippet_manager
 */
class SettingsFormTest extends TestBase {

  /**
   * {@inheritdoc}
   */
  public static $modules = [
    'snippet_manager',
    'snippet_manager_test',
  ];

  /**
   * Tests settings form..
   */
  public function testSettingsForm() {
    $this->drupalGet('admin/structure/snippet/settings');

    $form_prefix = '//form[@id="snippet-manager-settings"]';
    $codemirror_prefix = $form_prefix . '/details[@id="edit-codemirror"]';
    $this->assertByXpath($codemirror_prefix . '/summary[text() = "CodeMirror"]');
    $this->assertByXpath($codemirror_prefix . '//input[@name="codemirror[cdn]" and @checked="checked"]');
    $this->assertByXpath($codemirror_prefix . '//input[@name="codemirror[toolbar]" and @checked="checked"]');
    $this->assertByXpath($codemirror_prefix . '//select[@name="codemirror[theme]"]/option[@value="default" and @selected="selected"]');
    $this->assertByXpath($codemirror_prefix . '//select[@name="codemirror[mode]"]/option[@value="html_twig" and @selected="selected"]');

    $edit = [
      'codemirror[cdn]' => FALSE,
      'codemirror[toolbar]' => FALSE,
      'codemirror[theme]' => '3024-day',
      'codemirror[mode]' => 'twig',
    ];
    $this->drupalPostForm(NULL, $edit, 'Save configuration');

    $this->assertStatusMessage('The configuration options have been saved.');

    $this->assertByXpath($codemirror_prefix . '//input[@name="codemirror[cdn]" and not(@checked)]');
    $this->assertByXpath($codemirror_prefix . '//input[@name="codemirror[toolbar]" and not(@checked)]');
    $this->assertByXpath($codemirror_prefix . '//select[@name="codemirror[theme]"]/option[@value="3024-day" and @selected="selected"]');
    $this->assertByXpath($codemirror_prefix . '//select[@name="codemirror[mode]"]/option[@value="twig" and @selected="selected"]');
  }

}
