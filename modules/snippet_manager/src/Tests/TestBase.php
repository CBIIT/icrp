<?php

namespace Drupal\snippet_manager\Tests;

use Drupal\simpletest\WebTestBase;

/**
 * Base class for Snippet manager tests.
 */
abstract class TestBase extends WebTestBase {

  /**
   * {@inheritdoc}
   *
   * @todo: Make the tests work with strict schema.
   */
  protected $strictConfigSchema = FALSE;

  /**
   * Extra permissions.
   *
   * @var array
   */
  protected $extraPermissions = [];

  /**
   * Modules to enable.
   *
   * @var array
   */
  public static $modules = [
    'snippet_manager',
    'snippet_manager_test',
    'views',
  ];

  /**
   * {@inheritdoc}
   */
  protected function setUp() {
    parent::setUp();

    $default_permissions = [
      'administer snippets',
      'use text format snippet_manager_test_restricted_format',
      'use text format snippet_manager_test_basic_format',
    ];
    $user = $this->drupalCreateUser(array_merge($default_permissions, $this->extraPermissions));
    $this->drupalLogin($user);
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

    $xpath = '//div[@aria-label="' . ucfirst($type) . ' message"]';
    // Error messages have one more wrapper.
    if ($type == 'error') {
      $xpath .= '/div[@role="alert"]';
    }
    $wrapper = $this->xpath($xpath);
    if (!empty($wrapper[0])) {
      // Multiple messages are rendered with an HTML list.
      if (isset($wrapper[0]->ul)) {
        foreach ($wrapper[0]->ul->li as $li) {
          $messages[] = trim(strip_tags($li->asXML(), '<em>'));
        }
      }
      else {
        unset($wrapper[0]->h2);
        $messages[] = trim(preg_replace('/\s+/', ' ', strip_tags($wrapper[0]->asXML(), '<em>')));
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
  protected function assertPageTitle($text) {
    $this->assertEqual(strip_tags($this->xpath('//h1[@class="page-title"]')[0]->asXML(), '<em>'), $text);
  }

  /**
   * Passes if given xpath exists.
   */
  protected function assertByXpath($xpath, $message = 'Valid xpath was found.') {
    $result = $this->xpath($xpath);
    $this->assertTrue(isset($result[0]), $message);
  }

}
