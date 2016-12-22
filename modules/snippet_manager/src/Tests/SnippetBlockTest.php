<?php

namespace Drupal\snippet_manager\Tests;

/**
 * Tests snippet block.
 *
 * @group snippet_manager
 */
class SnippetBlockTest extends TestBase {

  /**
   * {@inheritdoc}
   */
  public static $modules = [
    'snippet_manager',
    'snippet_manager_test',
    'block',
  ];

  /**
   * {@inheritdoc}
   */
  protected $extraPermissions = ['administer blocks', 'administer themes'];

  /**
   * Tests snippet block.
   */
  public function testSnippetBlock() {
    // Create new snippet and check if it appears on block library page.
    $edit = [
      'label' => 'Beer',
      'id' => 'beer',
      'code[value]' => '{{ "Beer is not wine!" | upper }}',
    ];
    $this->drupalPostForm('snippet/add', $edit, 'Save');

    $this->drupalGet('admin/structure/block/library/classy');
    $this->assertText('Beer');

    // Put the block to the layout and check if it is properly rendered.
    $this->drupalPostForm(
      'admin/structure/block/add/snippet:beer/classy',
      ['visibility[request_path][pages]' => '/user/*'],
      'Save block',
      ['query' => ['region' => 'sidebar_first']]
    );
    $this->drupalGet('user/' . $this->loggedInUser->id());
    $this->assertText('BEER IS NOT WINE!', 'Beer snippet is rendered.');

    // Remove the snippet and check that the respective block has disappeared on
    // on the block page.
    $this->drupalPostForm('snippet/beer/delete', [], 'Delete');
    $this->drupalGet('admin/structure/block/library/classy');
    $this->assertNoText('Beer');

    // Make sure that the block has degraded gracefully.
    $this->drupalGet('user/' . $this->loggedInUser->id());
    $this->assertNoErrorMessages();
    $this->assertNoText('BEER IS NOT WINE!', 'Beer snippet is not rendered.');
    $this->assertText('This block is broken or missing.');
  }

}
