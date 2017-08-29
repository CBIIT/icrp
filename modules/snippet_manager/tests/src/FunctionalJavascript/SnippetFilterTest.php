<?php

namespace Drupal\Tests\snippet_manager\FunctionalJavascript;

use Drupal\FunctionalJavascriptTests\JavascriptTestBase;

/**
 * Tests the functionality of the snippet filter.
 *
 * @group snippet_manager
 */
class SnippetFilterTest extends JavascriptTestBase {

  /**
   * {@inheritdoc}
   */
  public static $modules = ['snippet_manager_test'];

  /**
   * Tests if the snippet list can be filtered with JavaScript.
   */
  public function testSnippetFilter() {

    $admin_user = $this->drupalCreateUser(['administer snippets']);
    $this->drupalLogin($admin_user);

    $this->drupalGet('admin/structure/snippet');

    $total_snippets = 3;

    // Expect 3 snippets available.
    $this->assertTrue($this->getCountRows() == $total_snippets, 'Snippets are not filtered yet.');
    $this->assertEmptyRow(FALSE);

    $this->setSearchValue('beta');
    $this->assertEquals($this->getCountRows(), 1, 'Snippets are filtered.');
    $this->assertEmptyRow(FALSE);

    // Let's do search by snippet id only.
    $this->setSearchValue('alpha');
    $this->assertEquals($this->getCountRows(), 1, 'Alpha snippet was found.');

    $this->setSearchValue('non existing snippet');
    $this->assertEquals($this->getCountRows(), 0, 'All snippets are hidden.');
    $this->assertEmptyRow(TRUE);

    // Reset the search string and check that we are back to the initial stage.
    $this->setSearchValue('');
    $this->assertTrue($this->getCountRows() == $total_snippets, 'Snippets are not filtered.');
    $this->assertEmptyRow(FALSE);
  }

  /**
   * Sets search value.
   */
  protected function setSearchValue($value) {
    $page = $this->getSession()->getPage();
    $input = $page->find('css', '[data-drupal-selector="sm-snippet-filter"]');
    $input->setValue($value);
    if ($value == '') {
      // Some trick to fire keyUp event.
      // See Drupal\Tests\views_ui\FunctionalJavascript\ViewsListingTest.
      $input->keyUp(1);
    }
    // Wait until Drupal.debounce() has fired the callback.
    sleep(1);
  }

  /**
   * Returns total number of visible rows.
   */
  protected function getCountRows() {
    $page = $this->getSession()->getPage();
    $rows = $page->findAll('css', '[data-drupal-selector="sm-snippet-list"] tbody tr:not(.empty-row)');
    $rows = array_filter($rows, function ($row) {
      /** @var \Behat\Mink\Element\NodeElement $row */
      return $row->isVisible();
    });
    return count($rows);
  }

  /**
   * Passes if empty row has a valid visibility.
   */
  protected function assertEmptyRow($visible) {
    $page = $this->getSession()->getPage();
    /** @var \Behat\Mink\Element\NodeElement $empty_row */
    $empty_row = $page->findAll('css', '.empty-row')[0];
    $visible ?
      $this->assertTrue($empty_row->isVisible(), 'Empty row is visible.') :
      $this->assertFalse($empty_row->isVisible(), 'Empty row is hidden.');
  }

}
