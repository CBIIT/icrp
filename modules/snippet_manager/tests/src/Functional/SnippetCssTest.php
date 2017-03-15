<?php

namespace Drupal\Tests\snippet_manager\Functional;

/**
 * Snippet CSS test.
 *
 * @group snippet_manager
 */
class SnippetCssTest extends TestBase {

  /**
   * Tests snippet CSS managing.
   */
  public function testCss() {

    // Check CSS form appearance.
    $this->drupalGet($this->snippetUrl . '/edit/css');
    $this->assertPageTitle(t('Edit %label', ['%label' => $this->snippetLabel]));
    $this->assertByXpath('//form//input[@type="checkbox" and @name="css[status]" and not(@checked)]/following::label[.="Enable"]');
    $this->assertByXpath('//form//label[.="Group"]/following::select[@name="css[group]"]/option[@value="component" and @selected="selected"]');
    $this->assertByXpath('//form//label[.="CSS"]/following::div/textarea[@name="css[value]"]');
    $this->assertByXpath('//form//label[.="Text format"]/following::select[@name="css[format]"]/option[@value="snippet_manager_test_basic_format" and @selected="selected"]');
    $this->assertByXpath('//form//input[@type="submit" and @value="Save"]');

    $edit = [
      'css[status]' => TRUE,
      'css[value]' => '.test {color: pink}',
    ];
    $this->drupalPostForm(NULL, $edit, 'Save');
    $this->assertStatusMessage(t('Snippet %label has been updated.', ['%label' => $this->snippetLabel]));

    // Make sure the form values have been updated.
    $this->assertByXpath('//form//input[@name="css[status]" and @checked]');
    $this->assertByXpath('//form//textarea[@name="css[value]" and .=".test {color: pink}"]');

    // Check if the CSS file has been created.
    $this->click('//form//a[.="Open file" and @class="button" and @target="_blank"]');
    $file_url = $this->getUrl();
    $this->assertRegExp(sprintf('#^http://.*/files/snippet/%s.css\?.{6}$#', $this->snippetId), $file_url);
    $this->assertSession()->responseContains('.test {color: pink}');

    // Check that the CSS file is attached to the snippet.
    $this->drupalGet($this->snippetUrl);
    $this->assertByXpath(sprintf('//head/style[contains(., "/files/snippet/%s.css?")]', $this->snippetId));

    // Disable CSS and make sure the file is removed.
    $edit = [
      'css[status]' => FALSE,
    ];
    $this->drupalPostForm($this->snippetUrl . '/edit/css', $edit, 'Save');
    $this->assertSession()->linkNotExists('Open file');
    $this->drupalGet($file_url);
    $this->assertSession()->statusCodeEquals(404);

    // Check if text format is applied correctly.
    $edit = [
      'css[status]' => TRUE,
      'css[value]' => '/* <div class="foo">test</div> */',
      'css[format]' => 'snippet_manager_test_basic_format',
    ];
    $this->drupalPostForm($this->snippetUrl . '/edit/css', $edit, 'Save');
    $this->click('//form//a[.="Open file"]');
    $this->assertSession()->responseContains('<div class="foo">test</div>');

    $edit = [
      'css[format]' => 'snippet_manager_test_restricted_format',
    ];
    $this->drupalPostForm($this->snippetUrl . '/edit/css', $edit, 'Save');
    $this->click('//form//a[.="Open file"]');
    $this->assertSession()->responseNotContains('<div class="foo">test</div>');
    $this->assertSession()->responseContains('test');
  }

}
