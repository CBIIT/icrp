<?php

namespace Drupal\Tests\snippet_manager\Functional;

use Drupal\Tests\BrowserTestBase;

/**
 * Base class for Snippet manager browser tests.
 */
abstract class TestBase extends BrowserTestBase {

  /**
   * {@inheritdoc}
   */
  public static $modules = ['snippet_manager', 'snippet_manager_test'];

  protected $permissions = [
    'administer snippets',
    'use text format snippet_manager_test_restricted_format',
    'use text format snippet_manager_test_basic_format',
  ];

  protected $snippetId;
  protected $snippetLabel;
  protected $snippetUrl;

  /**
   * {@inheritdoc}
   */
  protected function setUp() {
    parent::setUp();

    $user = $this->drupalCreateUser($this->permissions);
    $this->drupalLogin($user);

    $this->snippetId = strtolower($this->randomMachineName());
    $this->snippetLabel = $this->snippetId;
    $this->snippetUrl = 'admin/structure/snippet/' . $this->snippetId;

    $edit = [
      'id' => $this->snippetId,
      'label' => $this->snippetLabel,
    ];
    $this->drupalPostForm('admin/structure/snippet/add', $edit, 'Save');

    $this->drupalGet($this->snippetUrl);

    $edit = [
      'template[value]' => '<div class="snippet-test">{{ 3 * 3 }}</div>',
      'template[format]' => 'snippet_manager_test_basic_format',
    ];
    $this->drupalPostForm($this->snippetUrl . '/edit/template', $edit, 'Save');
  }

  /**
   * Checks that an element specified by a the xpath exists on the current page.
   *
   * @param string $selector
   *   The XPath identifying the element to check.
   */
  protected function assertByXpath($selector) {
    $this->assertSession()->elementExists('xpath', $selector);
  }

  /**
   * Clicks the element with the given XPath selector.
   *
   * @param string $selector
   *   The XPath identifying the element to click.
   */
  protected function click($selector) {
    $this->getSession()->getDriver()->click($selector);
  }

  /**
   * Finds Drupal messages on the page.
   *
   * @param string $type
   *   A message type (e.g. status, warning, error).
   *
   * @return array
   *   List of found messages.
   */
  protected function getMessages($type) {
    $messages = [];

    $get_message = function ($element) {
      // Remove hidden heading.
      $message = preg_replace('#<h2[^>]*>.*</h2>#', '', $element->getHtml());
      $message = strip_tags($message, '<em>');
      return trim(preg_replace('#\s+#', ' ', $message));
    };

    $xpath = '//div[@aria-label="' . ucfirst($type) . ' message"]';
    // Error messages have one more wrapper.
    if ($type == 'error') {
      $xpath .= '/div[@role="alert"]';
    }
    $wrapper = $this->xpath($xpath);
    if (!empty($wrapper[0])) {
      unset($wrapper[0]->h2);
      $items = $wrapper[0]->findAll('xpath', '/ul/li');

      // Multiple messages are rendered with an HTML list.
      if ($items) {
        foreach ($items as $item) {
          $messages[] = $get_message($item);
        }
      }
      else {
        $messages[] = $get_message($wrapper[0]);
      }
    }
    return $messages;
  }

  /**
   * Passes if a given error message was found on the page.
   */
  protected function assertErrorMessage($message) {
    $messages = $this->getMessages('error');
    $this->assertTrue(in_array($message, $messages), 'Error message was found.');
  }

  /**
   * Passes if a given warning message was found on the page.
   */
  protected function assertWarningMessage($message) {
    $messages = $this->getMessages('warning');
    $this->assertTrue(in_array($message, $messages), 'Warning message was found.');
  }

  /**
   * Passes if a given status message was found on the page.
   */
  protected function assertStatusMessage($message) {
    $messages = $this->getMessages('status');
    $this->assertTrue(in_array($message, $messages), 'Status message was found.');
  }

  /**
   * Passes if no error messages were found on the page.
   */
  protected function assertNoErrorMessages() {
    $messages = $this->getMessages('error');
    $this->assertTrue(count($messages) == 0, 'No error messages were found.');
  }

  /**
   * Passes if expected page title was found.
   */
  protected function assertPageTitle($title) {
    $this->assertEquals($title, trim(strip_tags($this->xpath('//h1[@class="page-title"]')[0]->getHtml(), '<em>')));
  }

}
