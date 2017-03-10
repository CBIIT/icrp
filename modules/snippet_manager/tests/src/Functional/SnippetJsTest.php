<?php

namespace Drupal\Tests\snippet_manager\Functional;

/**
 * Snippet JS test.
 *
 * @group snippet_manager
 */
class SnippetJsTest extends TestBase {

  /**
   * Tests snippet JS managing.
   */
  public function testJs() {

    // Check JS form appearance.
    $this->drupalGet($this->snippetUrl . '/edit/js');
    $this->assertPageTitle(t('Edit %label', ['%label' => $this->snippetLabel]));
    $this->assertByXpath('//form//input[@type="checkbox" and @name="js[status]" and not(@checked)]/following::label[.="Enable"]');
    $this->assertByXpath('//form//label[.="JavaScript"]/following::div/textarea[@name="js[value]"]');
    $this->assertByXpath('//form//label[.="Text format"]/following::select[@name="js[format]"]/option[@value="snippet_manager_test_basic_format" and @selected="selected"]');
    $this->assertByXpath('//form//input[@type="submit" and @value="Save"]');

    $edit = [
      'js[status]' => TRUE,
      'js[value]' => 'alert(123);',
    ];
    $this->drupalPostForm(NULL, $edit, 'Save');
    $this->assertStatusMessage(t('Snippet %label has been updated.', ['%label' => $this->snippetLabel]));

    // Make sure the form values have been updated.
    $this->assertByXpath('//form//input[@name="js[status]" and @checked]');
    $this->assertByXpath('//form//textarea[@name="js[value]" and .="alert(123);"]');

    // Check if the JS file has been created.
    $this->click('//form//a[.="Open file" and @class="button" and @target="_blank"]');
    $file_url = $this->getUrl();
    $this->assertRegExp(sprintf('#^http://.*/files/snippet/%s.js\?.{6}$#', $this->snippetId), $file_url);
    $this->assertSession()->responseContains('alert(123);');

    // Check that the JS file is attached to the snippet.
    $this->drupalGet($this->snippetUrl);
    $this->assertByXpath(sprintf('//script[contains(@src, "/files/snippet/%s.js?")]', $this->snippetId));

    // Disable JS and make sure the file is removed.
    $edit = [
      'js[status]' => FALSE,
    ];
    $this->drupalPostForm($this->snippetUrl . '/edit/js', $edit, 'Save');
    $this->assertSession()->linkNotExists('Open file');
    $this->drupalGet($file_url);
    $this->assertSession()->statusCodeEquals(404);

    // Check if text format is applied correctly.
    $edit = [
      'js[status]' => TRUE,
      'js[value]' => '/* <div class="foo">test</div> */',
      'js[format]' => 'snippet_manager_test_basic_format',
    ];
    $this->drupalPostForm($this->snippetUrl . '/edit/js', $edit, 'Save');
    $this->click('//form//a[.="Open file"]');
    $this->assertSession()->responseContains('<div class="foo">test</div>');

    $edit = [
      'js[format]' => 'snippet_manager_test_restricted_format',
    ];
    $this->drupalPostForm($this->snippetUrl . '/edit/js', $edit, 'Save');
    $this->click('//form//a[.="Open file"]');
    $this->assertSession()->responseNotContains('<div class="foo">test</div>');
    $this->assertSession()->responseContains('test');
  }

}
