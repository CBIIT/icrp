<?php

namespace Drupal\Tests\snippet_manager\Functional;

use Drupal\Core\PhpStorage\PhpStorageFactory;

/**
 * Template loader test.
 *
 * @group snippet_manager
 */
class TemplateLoaderTest extends TestBase {

  /**
   * Tests template loader context.
   */
  public function testTemplateLoader() {
    $edit = [
      'id' => 'base',
      'label' => 'Base',
    ];
    $this->drupalPostForm('admin/structure/snippet/add', $edit, 'Save');

    $edit = [
      'template[value]' => sprintf('<div class="snippet-base">{%% include "@snippet/%s" %%}</div>', $this->snippetId),
      'template[format]' => 'snippet_manager_test_basic_format',
    ];
    $this->drupalPostForm('admin/structure/snippet/base/edit/template', $edit, 'Save');

    $this->drupalGet('admin/structure/snippet/base');
    $this->assertByXpath('//div[@class="snippet-base"]/div[@class="snippet-test" and .="9"]');

    // Disable snippet and check that it is not longer included.
    $this->drupalGet('admin/structure/snippet');
    $this->click(sprintf('//td//a[contains(@href, "admin/structure/snippet/%s/disable")]', $this->snippetId));

    \Drupal::service('cache_tags.invalidator')->invalidateTags(['snippet_view']);
    PhpStorageFactory::get('twig')->deleteAll();

    $this->drupalGet('admin/structure/snippet/base');
    $this->assertByXpath('//div[@class="snippet-base" and .=""]');
  }

}
