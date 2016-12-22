<?php

namespace Drupal\snippet_manager\Tests;

/**
 * Tests snippet access.
 *
 * @group snippet_manager
 */
class SnippetAccessTest extends TestBase {

  /**
   * Tests snippet access.
   */
  public function testAccess() {

    $pages = [
      'admin/structure/snippet',
      'admin/structure/snippet/settings',
      'snippet/add',
      'snippet/alpha',
      'snippet/alpha/html-source',
      'snippet/alpha/edit',
      'snippet/alpha/edit/variable/add',
      'snippet/alpha/edit/variable/foo/edit',
      'snippet/alpha/edit/variable/foo/delete',
      'snippet/alpha/delete',
      'snippet/alpha/duplicate',
      'snippet-manager/path-autocomplete',
    ];

    // Ensure that admin user has access to all module pages.
    foreach ($pages as $page) {
      $this->drupalGet($page);
      $this->assertResponse(200, 'The page is accessible.');
    }

    // Test that unprilivged user has no access to snippet manager pages.
    $web_user = $this->drupalCreateUser(['view published snippets']);
    $this->drupalLogin($web_user);
    foreach ($pages as $page) {
      $this->drupalGet($page);
      $this->assertResponse(403, 'The page is not accessible.');
    }

    // Let's publish the page and check if the user has access to it.
    $this->setSnippetPageStatus(TRUE);
    $this->drupalGet('snippet/alpha');
    $this->assertResponse(200, 'The page is accessible.');

    // Ensure that the access is not cached.
    $this->setSnippetPageStatus(FALSE);
    $this->drupalGet('snippet/alpha');
    $this->assertResponse(403, 'The page is not accessible.');

    $this->setSnippetPageStatus(TRUE);
    $this->drupalGet('snippet/alpha');
    $this->assertResponse(200, 'The page is accessible.');

    // Anonymous user should not has access even to published pages.
    $this->drupalLogout();
    $this->drupalGet('snippet/alpha');
    $this->assertResponse(403, 'The page is not accessible.');
  }

  /**
   * Sets snippet page status.
   *
   * @param bool $status
   *   New page status.
   */
  protected function setSnippetPageStatus($status) {
    /** @var \Drupal\snippet_manager\SnippetInterface $snippet */
    $snippet = \Drupal::entityTypeManager()->getStorage('snippet')->load('alpha');
    $snippet_page = $snippet->get('page');
    $snippet_page['status'] = $status;
    $snippet->set('page', $snippet_page);
    $snippet->save();
  }

}
