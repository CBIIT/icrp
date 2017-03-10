<?php

namespace Drupal\snippet_manager\Tests;

/**
 * Tests entity variable plugin.
 *
 * @group snippet_manager
 */
class EntityVariableTest extends TestBase {

  /**
   * Modules to enable.
   *
   * @var array
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
    $this->drupalCreateNode(['title' => 'Bar', 'body' => 'bar_content']);

    // Presence snippet on all pages may break other tests. So let's display
    // it conditionally.
    // @see snippet_manager_test_page_bottom()
    \Drupal::state()->set('show_snippet', TRUE);
  }

  /**
   * Tests entity variable plugin.
   *
   * @todo Test operations.
   */
  public function testEntityVariable() {
    $edit = [
      'plugin_id' => 'entity:node',
      'name' => 'node',
    ];
    $this->drupalPostForm('admin/structure/snippet/alpha/edit/variable/add', $edit, 'Save and continue');

    $this->assertStatusMessage('The variable has been created.');

    $edit = [
      'configuration[entity_id]' => 'Bar',
    ];
    $this->drupalPostForm(NULL, $edit, 'Save');

    $this->assertStatusMessage('The variable has been updated.');

    $label = $this->xpath('//main//table/tbody/tr/td[position() = 1]/a[@href="#snippet-edit-form" and text() = "node"]');
    $this->assertTrue($label, 'Valid snippet variable label was found');

    $edit = [
      'template[value]' => '<div class="snippet-node">{{ node }}</div>',
    ];
    $this->drupalPostForm(NULL, $edit, 'Save');

    // Check specified node in the snippet.
    $this->drupalGet('node/1');
    $this->assertSnippetNode('Bar');

    $this->drupalGet('<front>');
    $this->assertSnippetNode('Bar');

    // Empty entity ID forces loading the node form route.
    $edit = [
      'configuration[entity_id]' => '',
    ];
    $this->drupalPostForm('admin/structure/snippet/alpha/edit/variable/node/edit', $edit, 'Save');

    $this->drupalGet('node/1');
    $this->assertSnippetNode('Foo');

    $this->drupalGet('node/2');
    $this->assertSnippetNode('Bar');

    $this->drupalGet('<front>');
    $this->assertSnippetNode(NULL);

    // Test view mode option.
    $this->assertNoLink('Read more');
    $edit = [
      'configuration[entity_id]' => 'Bar',
    ];
    $this->drupalPostForm('admin/structure/snippet/alpha/edit/variable/node/edit', $edit, 'Save');
    $edit = [
      'configuration[entity_id]' => 'Bar',
      'configuration[view_mode]' => 'teaser',
    ];
    $this->drupalPostForm('admin/structure/snippet/alpha/edit/variable/node/edit', $edit, 'Save');
    $this->assertLink('Read more');

    // Remove the node and make sure it doesn't cause any exceptions.
    $node = $this->getNodeByTitle('Bar');
    $node->delete();
    $this->drupalGet('<front>');
  }

  /**
   * Asserts that given node title presents in a snippet.
   *
   * @param string $expected_title
   *   Node title to check.
   */
  protected function assertSnippetNode($expected_title) {
    // Snippet output is cached by some reason.
    drupal_flush_all_caches();
    $result = $this->xpath('//div[@class="snippet-node"]/article/h2/a/span');
    $title = isset($result[0]) ? (string) $result[0] : NULL;
    $this->assertEqual($expected_title, $title, 'Expected node title was found');
  }

}
