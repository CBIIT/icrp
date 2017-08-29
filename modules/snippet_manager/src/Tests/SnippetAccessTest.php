<?php

namespace Drupal\snippet_manager\Tests;

/**
 * Snippet access test.
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
      'admin/structure/snippet/add',
      'admin/structure/snippet/alpha',
      'admin/structure/snippet/alpha/source',
      'admin/structure/snippet/alpha/edit',
      'admin/structure/snippet/alpha/edit/variable/add',
      'admin/structure/snippet/alpha/edit/variable/foo/edit',
      'admin/structure/snippet/alpha/edit/variable/foo/delete',
      'admin/structure/snippet/alpha/delete',
      'admin/structure/snippet/alpha/duplicate',
      'snippet-manager/path-autocomplete',
    ];

    // Ensure that admin user has access to all module pages.
    foreach ($pages as $page) {
      $this->drupalGet($page);
      $this->assertResponse(200, 'The page is accessible.');
    }

    // Test that unprilivged user has no access to snippet manager pages.
    $web_user = $this->drupalCreateUser();
    $this->drupalLogin($web_user);
    foreach ($pages as $page) {
      $this->drupalGet($page);
      $this->assertResponse(403, 'The page is not accessible.');
    }

  }

}
