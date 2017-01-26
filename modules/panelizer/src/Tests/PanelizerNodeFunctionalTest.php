<?php

/**
 * @file
 * Contains \Drupal\panelizer\Tests\PanelizerNodeFunctionalTest.
 */

namespace Drupal\panelizer\Tests;

use Drupal\simpletest\WebTestBase;

/**
 * Basic functional tests of using Panelizer with nodes.
 *
 * @group panelizer
 */
class PanelizerNodeFunctionalTest extends WebTestBase {

  use PanelizerTestTrait;

  /**
   * {@inheritdoc}
   */
  protected $profile = 'standard';

  /**
   * {@inheritdoc}
   */
  public static $modules = [
    'block',
    'ctools',
    'ctools_block',
    'layout_plugin',
    'node',
    'panelizer',
    'panelizer_test',
    'panels',
    'panels_ipe',
  ];

  /**
   * {@inheritdoc}
   */
  protected function setUp() {
    parent::setUp();

    $user = $this->drupalCreateUser([
      'administer node display',
      'administer nodes',
      'administer content types',
      'create page content',
      'create article content',
      'administer panelizer',
      'access panels in-place editing',
      'view the administration theme',
    ]);
    $this->drupalLogin($user);
  }

  /**
   * Tests the admin interface to set a default layout for a bundle.
   */
  public function testWizardUI() {
    $this->panelize('article', NULL, [
      'panelizer[custom]' => TRUE,
    ]);

    // Enter the wizard.
    $this->drupalGet('/admin/structure/panelizer/edit/node__article__default__default');

    // Contexts step.
    $this->clickLink('Contexts');
    $this->assertText('@panelizer.entity_context:entity', 'The current entity context is present.');

    // Layout selection step.
    $this->clickLink('Layout');

    // Content step. Add the Node block to the top region.
    $this->clickLink('Content');
    $this->clickLink('Add new block');
    $this->clickLink('Title');
    $edit = [
      'region' => 'middle',
    ];
    $this->drupalPostForm(NULL, $edit, 'Add block');

    // Finish the wizard.
    $this->drupalPostForm(NULL, [], 'Update and save');
    // Return to the Manage Display page, which is where the Cancel button
    // currently sends you. That's a UX WTF and should be fixed...
    $this->drupalPostForm(NULL, [], 'Cancel');

    // Check that the general setting was saved.
    $this->assertFieldChecked('edit-panelizer-custom');

    // Now change and save the general setting.
    $this->drupalPostForm(NULL, ['panelizer[custom]' => FALSE], 'Save');
    $this->assertNoFieldChecked('edit-panelizer-custom');

    // Add another block at the Content step and then save changes.
    $this->drupalGet('/admin/structure/panelizer/edit/node__article__default__default/content');
    $this->clickLink('Add new block');
    $this->clickLink('Body');
    $edit = [
      'region' => 'middle',
    ];
    $this->drupalPostForm(NULL, $edit, 'Add block');
    $this->assertText('entity_field:node:body', 'The body block was added successfully.');
    $this->drupalPostForm(NULL, [], 'Save');
    $this->clickLink('Content');
    $this->assertText('entity_field:node:body', 'The body block was saved successfully.');

    // Check that the Manage Display tab changed now that Panelizer is set up.
    // Also, the field display table should be hidden.
    $this->assertNoRaw('<div id="field-display-overview-wrapper">');

    // Disable Panelizer for the default display mode. This should bring back
    // the field overview table at Manage Display and not display the link to
    // edit the default Panelizer layout.
    $this->unpanelize('article');
    $this->assertNoLinkByHref('admin/structure/panelizer/edit/node__article__default');
    $this->assertRaw('<div id="field-display-overview-wrapper">');
  }

  /**
   * Tests rendering a node with Panelizer default.
   */
  public function testPanelizerDefault() {
    $this->panelize('page', NULL, ['panelizer[custom]' => TRUE]);
    /** @var \Drupal\panelizer\PanelizerInterface $panelizer */
    $panelizer = $this->container->get('panelizer');
    $displays = $panelizer->getDefaultPanelsDisplays('node', 'page', 'default');
    $display = $displays['default'];
    $display->addBlock([
      'id' => 'panelizer_test',
      'label' => 'Panelizer test',
      'provider' => 'block_content',
      'region' => 'middle',
    ]);
    $panelizer->setDefaultPanelsDisplay('default', 'node', 'page', 'default', $display);

    // Create a node, and check that the IPE is visible on it.
    $node = $this->drupalCreateNode(['type' => 'page']);
    $out = $this->drupalGet('node/' . $node->id());
    $this->verbose($out);
    $elements = $this->xpath('//*[@id="panels-ipe-content"]');
    if (is_array($elements)) {
      $this->assertIdentical(count($elements), 1);
    }
    else {
      $this->fail('Could not parse page content.');
    }

    // Check that the block we added is visible.
    $this->assertText('Panelizer test');
    $this->assertText('Abracadabra');
  }

}
