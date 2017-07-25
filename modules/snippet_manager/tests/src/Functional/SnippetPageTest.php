<?php

namespace Drupal\Tests\snippet_manager\Functional;

/**
 * Snippet page test.
 *
 * @group snippet_manager
 */
class SnippetPageTest extends TestBase {

  /**
   * {@inheritdoc}
   */
  public static $modules = [
    'snippet_manager',
    'snippet_manager_test',
    'node',
  ];

  /**
   * {@inheritdoc}
   */
  protected function setUp() {
    parent::setUp();
    $this->createContentType(['type' => 'page']);
    $this->drupalCreateNode(['title' => 'Foo', 'body' => 'foo_content']);
    \Drupal::service('theme_handler')->install(['bartik']);
  }

  /**
   * Tests snippet pages.
   */
  public function testSnippetPages() {

    $edit = [
      'page[status]' => TRUE,
      'page[path]' => 'zoo',
    ];
    $this->drupalPostForm($this->snippetUrl . '/edit', $edit, 'Save');

    $this->drupalGet($this->snippetUrl . '/edit');
    $this->drupalGet('admin/structure/snippet');
    $this->click(sprintf('//td[a[text()="%s"]]/following-sibling::td/a[text()="zoo"]', $this->snippetLabel));
    $this->assertSession()->addressEquals('zoo');
    $this->assertPageTitle($this->snippetLabel);
    $this->assertXpath('//div[@class="snippet-test" and text()="9"]');

    // Check page title.
    $edit = [
      'page[title]' => 'Bar',
    ];
    $this->drupalPostForm($this->snippetUrl . '/edit', $edit, 'Save');
    $this->drupalGet('zoo');
    $this->assertPageTitle('Bar');

    /* @TODO: Test display variant here. */

    // Check page theme.
    $edit = [
      'page[theme]' => 'bartik',
    ];
    $this->drupalPostForm($this->snippetUrl . '/edit', $edit, 'Save');
    $this->drupalGet('zoo');
    $this->assertSession()->responseContains('core/themes/bartik/css/print.css');

    // Check path overriding.
    $edit = [
      'page[path]' => 'node/%node',
      'page[title]' => '',
    ];
    $this->drupalPostForm($this->snippetUrl . '/edit', $edit, 'Save');
    $this->drupalGet('node/1');
    // The page title comes from the node.
    $this->assertPageTitle('Foo');
    $this->assertXpath('//div[@class="snippet-test" and text()="9"]');

    // Check if a node can be loaded from request.
    $edit = [
      'template[value]' => '<h3>{{ node_title }}</h3>',
    ];
    $this->drupalPostForm($this->snippetUrl . '/edit/template', $edit, 'Save');
    $edit = [
      'plugin_id' => 'entity:node',
      'name' => 'node_title',
    ];
    $this->drupalPostForm($this->snippetUrl . '/edit/variable/add', $edit, 'Save and continue');
    $edit = [
      'configuration[render_mode]' => 'fields',
    ];
    $this->drupalPostForm(NULL, $edit, 'Save');
    $this->drupalGet('node/1');
    $this->assertXpath('//h3/span[text()="Foo"]');

  }

}
