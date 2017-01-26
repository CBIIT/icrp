<?php

namespace Drupal\webform_ui\Tests;

use Drupal\webform\Tests\WebformTestBase;
use Drupal\webform\Entity\Webform;

/**
 * Tests for webform UI element.
 *
 * @group WebformUi
 */
class WebformUiElementTest extends WebformTestBase {

  /**
   * Modules to enable.
   *
   * @var array
   */
  public static $modules = ['system', 'filter', 'user', 'webform', 'webform_test', 'webform_examples', 'webform_ui'];

  /**
   * Tests element.
   */
  public function testElements() {
    global $base_path;

    $this->drupalLogin($this->adminFormUser);

    /**************************************************************************/
    // Reordering
    /**************************************************************************/

    // Check reordered elements.
    $webform_contact = Webform::load('contact');

    // Check original contact element order.
    $this->assertEqual(['name', 'email', 'subject', 'message'], array_keys($webform_contact->getElementsDecodedAndFlattened()));

    // Check updated (reverse) contact element order.
    /** @var \Drupal\webform\WebformInterface $webform_contact */
    $edit = [
      'elements_reordered[message][weight]' => 0,
      'elements_reordered[subject][weight]' => 1,
      'elements_reordered[email][weight]' => 2,
      'elements_reordered[name][weight]' => 3,
    ];
    $this->drupalPostForm('admin/structure/webform/manage/contact', $edit, t('Save elements'));

    \Drupal::entityTypeManager()->getStorage('webform_submission')->resetCache();
    \Drupal::entityTypeManager()->getStorage('webform')->resetCache();
    $webform_contact = Webform::load('contact');
    $this->assertEqual(['message', 'subject', 'email', 'name'], array_keys($webform_contact->getElementsDecodedAndFlattened()));

    /**************************************************************************/
    // Required.
    /**************************************************************************/

    // Check name is required.
    $this->drupalGet('admin/structure/webform/manage/contact');
    $this->assertFieldChecked('edit-elements-reordered-name-required');

    // Check name is not required.
    $edit = [
      'elements_reordered[name][required]' => FALSE,
    ];
    $this->drupalPostForm('admin/structure/webform/manage/contact', $edit, t('Save elements'));
    $this->assertNoFieldChecked('edit-elements-reordered-name-required');

    /**************************************************************************/
    // CRUD
    /**************************************************************************/

    // Check create element.
    $this->drupalPostForm('admin/structure/webform/manage/contact/element/add/textfield', ['key' => 'test', 'properties[title]' => 'Test'], t('Save'));

    // Check read element.
    $this->drupalGet('webform/contact');
    $this->assertRaw('<label for="edit-test">Test</label>');
    $this->assertRaw('<input data-drupal-selector="edit-test" type="text" id="edit-test" name="test" value="" size="60" maxlength="255" class="form-text" />');

    // Check update element.
    $this->drupalPostForm('admin/structure/webform/manage/contact/element/test/edit', ['properties[title]' => 'Test 123', 'properties[default_value]' => 'This is a default value'], t('Save'));
    $this->drupalGet('webform/contact');
    $this->assertRaw('<label for="edit-test">Test 123</label>');
    $this->assertRaw('<input data-drupal-selector="edit-test" type="text" id="edit-test" name="test" value="This is a default value" size="60" maxlength="255" class="form-text" />');

    // Check that 'test' element is being added to the webform_submission_data table.
    $this->drupalPostForm('webform/contact/test', [], t('Send message'));
    $this->assertEqual(1, db_query("SELECT COUNT(sid) FROM {webform_submission_data} WHERE webform_id='contact' AND name='test'")->fetchField());

    // Check delete element.
    $this->drupalPostForm('admin/structure/webform/manage/contact/element/test/delete', [], t('Delete'));
    $this->drupalGet('webform/contact');
    $this->assertNoRaw('<label for="edit-test">Test 123</label>');
    $this->assertNoRaw('<input data-drupal-selector="edit-test" type="text" id="edit-test" name="test" value="This is a default value" size="60" maxlength="255" class="form-text" />');

    // Check that 'test' element values were deleted from the webform_submission_data table.
    $this->assertEqual(0, db_query("SELECT COUNT(sid) FROM {webform_submission_data} WHERE webform_id='contact' AND name='test'")->fetchField());

    /**************************************************************************/
    // Change type
    /**************************************************************************/

    // Check create element.
    $this->drupalPostForm('admin/structure/webform/manage/contact/element/add/textfield', ['key' => 'test', 'properties[title]' => 'Test'], t('Save'));

    // Check element type.
    $this->drupalGet('admin/structure/webform/manage/contact/element/test/edit');
    // Check change element type link.
    $this->assertRaw('Text field<a href="' . $base_path . 'admin/structure/webform/manage/contact/element/test/change" class="button button--small use-ajax" data-dialog-type="modal" data-dialog-options="{&quot;width&quot;:800}" data-drupal-selector="edit-change-type" id="edit-change-type">Change</a>');
    // Check text field has description.
    $this->assertRaw(t('A short description of the element used as help for the user when he/she uses the webform.'));

    // Check change element types.
    $this->drupalGet('admin/structure/webform/manage/contact/element/test/change');
    $this->assertRaw(t('Hidden'));
    $this->assertRaw('<a href="' . $base_path . 'admin/structure/webform/manage/contact/element/test/edit?type=hidden" class="use-ajax" data-dialog-type="modal" data-dialog-options="{&quot;width&quot;:800}">Change</a>');
    $this->assertRaw(t('value'));
    $this->assertRaw('<a href="' . $base_path . 'admin/structure/webform/manage/contact/element/test/edit?type=value" class="use-ajax" data-dialog-type="modal" data-dialog-options="{&quot;width&quot;:800}">Change</a>');
    $this->assertRaw(t('Search'));
    $this->assertRaw('<a href="' . $base_path . 'admin/structure/webform/manage/contact/element/test/edit?type=search" class="use-ajax" data-dialog-type="modal" data-dialog-options="{&quot;width&quot;:800}">Change</a>');
    $this->assertRaw(t('Telephone'));
    $this->assertRaw('<a href="' . $base_path . 'admin/structure/webform/manage/contact/element/test/edit?type=tel" class="use-ajax" data-dialog-type="modal" data-dialog-options="{&quot;width&quot;:800}">Change</a>');
    $this->assertRaw(t('URL'));
    $this->assertRaw('<a href="' . $base_path . 'admin/structure/webform/manage/contact/element/test/edit?type=url" class="use-ajax" data-dialog-type="modal" data-dialog-options="{&quot;width&quot;:800}">Change</a>');

    // Check change element type.
    $this->drupalGet('admin/structure/webform/manage/contact/element/test/edit', ['query' => ['type' => 'value']]);
    // Check value has no description.
    $this->assertNoRaw(t('A short description of the element used as help for the user when he/she uses the webform.'));
    $this->assertRaw('Value<a href="' . $base_path . 'admin/structure/webform/manage/contact/element/test/edit" class="button button--small use-ajax" data-dialog-type="modal" data-dialog-options="{&quot;width&quot;:800}" data-drupal-selector="edit-cancel" id="edit-cancel">Cancel</a>');
    $this->assertRaw('(Changing from <em class="placeholder">Text field</em>)');

    // Change the element type.
    $this->drupalPostForm('admin/structure/webform/manage/contact/element/test/edit', [], t('Save'), ['query' => ['type' => 'value']]);

    // Change the element type from 'textfield' to 'value'.
    $this->drupalGet('admin/structure/webform/manage/contact/element/test/edit');

    // Check change element type link.
    $this->assertRaw('Value<a href="' . $base_path . 'admin/structure/webform/manage/contact/element/test/change" class="button button--small use-ajax" data-dialog-type="modal" data-dialog-options="{&quot;width&quot;:800}" data-drupal-selector="edit-change-type" id="edit-change-type">Change</a>');

    // Check color element that does not have related type and return 404.
    $this->drupalPostForm('admin/structure/webform/manage/contact/element/add/color', ['key' => 'test_color', 'properties[title]' => 'Test color'], t('Save'));
    $this->drupalGet('admin/structure/webform/manage/contact/element/test_color/change');
    $this->assertResponse(404);

    /**************************************************************************/
    // Date
    /**************************************************************************/

    // Check GNU Date Input Format validation.
    $edit = [
      'properties[default_value]' => 'not a valid date',
    ];
    $this->drupalPostForm('admin/structure/webform/manage/test_element_dates/element/date_min_max_dynamic/edit', $edit, t('Save'));
    $this->assertRaw('The Default value could not be interpreted in <a href="https://www.gnu.org/software/tar/manual/html_chapter/tar_7.html#Date-input-formats">GNU Date Input Format</a>.');
  }

  /**
   * Tests permissions.
   */
  public function testPermissions() {
    $webform = $this->createWebform();

    // Check source page access not visible to user with 'administer webform'
    // permission.
    $account = $this->drupalCreateUser(['administer webform']);
    $this->drupalLogin($account);
    $this->drupalGet('admin/structure/webform/manage/' . $webform->id() . '/source');
    $this->assertResponse(403);
    $this->drupalLogout();

    // Check source page access not visible to user with 'edit webform source'
    // without 'administer webform' permission.
    $account = $this->drupalCreateUser(['edit webform source']);
    $this->drupalLogin($account);
    $this->drupalGet('admin/structure/webform/manage/' . $webform->id() . '/source');
    $this->assertResponse(403);
    $this->drupalLogout();

    // Check source page access visible to user with 'edit webform source'
    // and 'administer webform' permission.
    $account = $this->drupalCreateUser(['administer webform', 'edit webform source']);
    $this->drupalLogin($account);
    $this->drupalGet('admin/structure/webform/manage/' . $webform->id() . '/source');
    $this->assertResponse(200);
    $this->drupalLogout();
  }

}
