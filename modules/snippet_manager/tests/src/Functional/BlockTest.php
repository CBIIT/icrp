<?php

namespace Drupal\Tests\snippet_manager\Functional;

/**
 * Block test.
 *
 * @group snippet_manager
 */
class BlockTest extends TestBase {

  /**
   * {@inheritdoc}
   */
  public static $modules = ['snippet_manager', 'snippet_manager_test', 'block'];

  /**
   * {@inheritdoc}
   */
  protected $permissions = [
    'administer snippets',
    'use text format snippet_manager_test_restricted_format',
    'use text format snippet_manager_test_basic_format',
    'administer blocks',
    'administer themes',
  ];

  /**
   * Tests block plugin.
   */
  public function testDefaultContext() {

    $this->drupalGet($this->snippetUrl . '/edit');

    // Check block form appearance.
    $prefix = '//fieldset[legend/span[.="Block"]]';
    $this->assertByXpath($prefix . '//input[@name="block[status]" and not(@checked)]/following::label[.="Enable snippet block"]');
    $this->assertByXpath($prefix . '//label[.="Admin description"]/following::input[@name="block[name]"]');

    // Enable block.
    $edit = [
      'block[status]' => TRUE,
    ];
    $this->drupalPostForm(NULL, $edit, 'Save');
    $this->assertByXpath($prefix . '//input[@name="block[status]" and @checked]');

    // Check if the block appears on block administration page.
    $this->drupalGet('admin/structure/block/library/classy');
    $this->assertByXpath(sprintf('//td[.="%s"]/following::td[.="Snippet"]', $this->snippetLabel));

    // Set block name.
    $edit = [
      'block[name]' => 'Example',
    ];
    $this->drupalPostForm($this->snippetUrl . '/edit', $edit, 'Save');
    $this->assertByXpath($prefix . '//input[@name="block[name]" and @value="Example"]');

    // Check if block admin name has been changed.
    $this->drupalGet('admin/structure/block/library/classy');
    $this->assertByXpath('//td[.="Example"]/following::td[.="Snippet"]');

    // Create block instance and make sure it appears in a specified region.
    $edit = [
      'settings[label]' => 'Beer',
      'region' => 'sidebar_first',
    ];
    $this->drupalPostForm(sprintf('admin/structure/block/add/snippet:%s/classy', $this->snippetId), $edit, 'Save block');

    $active_block_xpath = implode([
      '//div[contains(@class, "region-sidebar-first")]',
      '/div[@id="block-example"]',
      '/h2[.="Beer"]/following::div[@class="snippet-test" and .="9"]',
    ]);
    $this->assertByXpath($active_block_xpath);

    // Disable block check that the respective block has disappeared on
    // on the block page.
    $edit = [
      'block[status]' => FALSE,
    ];
    $this->drupalPostForm($this->snippetUrl . '/edit', $edit, 'Save');

    $this->drupalGet('admin/structure/block/library/classy');
    $this->assertSession()->elementNotExists('xpath', '//td[.="Example"]/following::td[.="Snippet"]');

    // Make sure the block is degrading gracefully.
    $missing_block_xpath = implode([
      '//div[contains(@class, "region-sidebar-first")]',
      '/div[@id="block-example" and h2[.="Beer"] and contains(., "This block is broken or missing. You may be missing content or you might need to enable the original module.")]',
    ]);
    $this->assertByXpath($missing_block_xpath);

    // Enable block again and check of the block instance returned back.
    $edit = [
      'block[status]' => TRUE,
    ];
    $this->drupalPostForm($this->snippetUrl . '/edit', $edit, 'Save');

    // Broken block can be cached.
    \Drupal::service('cache_tags.invalidator')->invalidateTags(['block_view']);

    $this->drupalGet('admin/structure/block/library/classy');
    $this->assertByXpath('//td[.="Example"]/following::td[.="Snippet"]');
    $this->assertByXpath($active_block_xpath);

    // Disable snippet and check if the respective block is not available.
    $this->drupalGet('admin/structure/snippet');
    $this->click(sprintf('//td//a[contains(@href, "admin/structure/snippet/%s/disable")]', $this->snippetId));
    $this->assertByXpath($missing_block_xpath);
    $this->drupalGet('admin/structure/block/library/classy');
    $this->assertSession()->elementNotExists('xpath', '//td[.="Example"]/following::td[.="Snippet"]');

    // Enable block and delete the snippet.
    $this->drupalGet('admin/structure/snippet');
    $this->click(sprintf('//td//a[contains(@href, "admin/structure/snippet/%s/enable")]', $this->snippetId));
    $this->drupalPostForm(sprintf('admin/structure/snippet/%s/delete', $this->snippetId), [], 'Delete');
    $this->drupalGet('admin/structure/block/library/classy');
    $this->assertSession()->elementNotExists('xpath', '//td[.="Example"]/following::td[.="Snippet"]');
    $this->assertByXpath($missing_block_xpath);

  }

}
