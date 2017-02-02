<?php

namespace Drupal\panelizer\Tests;

use Drupal\Core\Entity\Entity\EntityFormDisplay;
use Drupal\Core\Entity\Entity\EntityViewDisplay;

/**
 * Contains helper methods for writing functional tests of Panelizer.
 */
trait PanelizerTestTrait {

  /**
   * Panelizes a node type's default view display.
   *
   * @param string $node_type
   *   The node type ID.
   * @param string $display
   *   (optional) The view display to panelize.
   * @param array $values
   *   (optional) Additional form values.
   */
  protected function panelize($node_type, $display = NULL, array $values = []) {
    $this->drupalGet("admin/structure/types/manage/{$node_type}/display/{$display}");

    $values['panelizer[enable]'] = TRUE;
    $this->drupalPostForm(NULL, $values, 'Save');

    EntityFormDisplay::load('node.' . $node_type . '.default')
      ->setComponent('panelizer', [
        'type' => 'panelizer',
      ])
      ->save();
  }

  /**
   * Unpanelizes a node type's default view display.
   *
   * Panelizer is disabled for the display, but its configuration is retained.
   *
   * @param string $node_type
   *   The node type ID.
   * @param string $display
   *   (optional) The view display to unpanelize.
   * @param array $values
   *   (optional) Additional form values.
   */
  protected function unpanelize($node_type, $display = NULL, array $values = []) {
    $this->drupalGet("admin/structure/types/manage/{$node_type}/display/{$display}");

    $values['panelizer[enable]'] = FALSE;
    $this->drupalPostForm(NULL, $values, 'Save');

    EntityFormDisplay::load('node.' . $node_type . '.default')
      ->removeComponent('panelizer')
      ->save();
  }

  protected function addPanelizerDefault($node_type, $display = 'default') {
    $label = $this->getRandomGenerator()->word(16);
    $id = strtolower($label);
    $default_id = "node__{$node_type}__{$display}__{$id}";
    $options = array(
      'query' => array(
        'js' => 'nojs',
      ),
    );

    $this->drupalGet("admin/structure/types/manage/{$node_type}/display");
    $this->clickLink('Add panelizer default');

    // Step 1: Enter the default's label and ID.
    $this->drupalPostForm(NULL, [
      'id' => $id,
      'label' => $label,
    ], 'Next');

    // Step 2: Define contexts.
    $this->assertResponse(200);
    $this->assertUrl("admin/structure/panelizer/add/{$default_id}/contexts", $options);
    $this->drupalPostForm(NULL, [], 'Next');

    // Step 3: Select layout.
    $this->assertResponse(200);
    $this->assertUrl("admin/structure/panelizer/add/{$default_id}/layout", $options);
    $this->drupalPostForm(NULL, [], 'Next');

    // Step 4: Select content.
    $this->assertResponse(200);
    $this->assertUrl("admin/structure/panelizer/add/{$default_id}/content", $options);
    $this->drupalPostForm(NULL, [], 'Finish');

    return $id;
  }

  /**
   * Deletes a Panelizer default.
   *
   * @param string $node_type
   *   The node type ID.
   * @param string $display
   *   (optional) The view display ID.
   * @param string $id
   *   (optional) The default ID.
   */
  protected function deletePanelizerDefault($node_type, $display = 'default', $id = 'default') {
    $this->drupalGet("admin/structure/panelizer/delete/node__{$node_type}__{$display}__{$id}");
    $this->drupalPostForm(NULL, [], 'Confirm');
  }

  /**
   * Asserts that a Panelizer default exists.
   *
   * @param string $node_type
   *   The node type ID.
   * @param string $display
   *   (optional) The view display ID.
   * @param string $id
   *   (optional) The default ID.
   */
  protected function assertDefaultExists($node_type, $display = 'default', $id = 'default') {
    $settings = EntityViewDisplay::load("node.{$node_type}.{$display}")
      ->getThirdPartySettings('panelizer');

    $display_exists = isset($settings['displays'][$id]);
    $this->assertTrue($display_exists);
  }

  /**
   * Asserts that a Panelizer default does not exist.
   *
   * @param string $node_type
   *   The node type ID.
   * @param string $display
   *   The view display ID.
   * @param string $id
   *   The default ID.
   */
  protected function assertDefaultNotExists($node_type, $display = 'default', $id = 'default') {
    $settings = EntityViewDisplay::load("node.{$node_type}.{$display}")
      ->getThirdPartySettings('panelizer');

    $display_exists = isset($settings['displays'][$id]);
    $this->assertFalse($display_exists);
  }

}
