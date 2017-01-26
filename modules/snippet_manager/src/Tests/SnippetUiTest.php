<?php

namespace Drupal\snippet_manager\Tests;

/**
 * Tests the Snippet manager user interface.
 *
 * @group snippet_manager
 */
class SnippetUiTest extends TestBase {

  /**
   * Tests snippet form.
   */
  public function testSnippetForm() {

    // Add form.
    $this->drupalGet('snippet/add');
    $this->assertPageTitle(t('Add a snippet'));
    $this->assertField('label', 'Label field was found');
    $this->assertField('status', 'Status checkbox was found');
    $this->assertField('code[value]', 'Code textarea was found');
    $this->assertText(t('Snippet manager test basic format'), 'Test format is enabled');
    $this->assertText(t('Variables are not configured yet.'));
    $this->assertField('op', 'Submit button was found.');

    // Submit form and check if the snippet is rendered.
    $snippet_label = $this->randomMachineName();
    $snippet_id = strtolower($this->randomMachineName());
    $edit = [
      'label' => $snippet_label,
      'id' => $snippet_id,
      'code[value]' => '<div>2 + 3 = {{ 2 + 3 }}</div>',
    ];
    $this->drupalPostForm(NULL, $edit, t('Save'));

    $this->assertStatusMessage(t('Snippet %label has been created.', ['%label' => $snippet_label]));

    $this->assertUrl("snippet/$snippet_id");

    $this->assertText('2 + 3 = 5');

    // Edit form.
    $this->drupalGet("snippet/$snippet_id/edit");

    $this->assertPageTitle(t('Edit @label', ['@label' => $snippet_label]));

    $this->assertFieldByXPath('//input[@name="label"]', $snippet_label, 'Valid label field was found.');

    $this->assertFieldByXPath('//textarea[@name="code[value]"]', '<div>2 + 3 = {{ 2 + 3 }}</div>', 'Valid code field was found.');

    $this->assertText(t('Variables are not configured yet.'));

    $this->assertField('op', 'Submit button was found.');

    $this->assertLink(t('Add variable'));
    $this->assertLinkByHref("/snippet/$snippet_id/edit/variable/add");
    $this->assertLink(t('Delete'));
    $this->assertLinkByHref("/snippet/$snippet_id/delete");
  }

  /**
   * Tests snippet delete form.
   */
  public function testSnippetDeleteForm() {
    $this->drupalGet('admin/structure/snippet');
    $this->assertLink('Alpha');
    $this->drupalGet('snippet/alpha/delete');
    $this->assertPageTitle(t('Are you sure you want to delete the snippet %label?', ['%label' => 'Alpha']));
    $this->assertText(t('This action cannot be undone.'));
    $this->assertLink(t('Cancel'));
    $this->assertLinkByHref('/admin/structure/snippet');
    $this->drupalPostForm(NULL, [], t('Delete'));
    $this->assertStatusMessage(t('The snippet %label has been deleted.', ['%label' => 'Alpha']));
    $this->assertNoLink('Alpha');
    $this->assertUrl('admin/structure/snippet');
  }

  /**
   * Tests snippets list.
   */
  public function testSnippetsList() {
    $this->drupalGet('admin/structure/snippet');
    $this->assertPageTitle(t('Snippets'));

    $expected_header = [
      t('Label'),
      t('Machine name'),
      t('Status'),
      t('Size'),
      t('Format'),
      t('Page'),
      t('Operations'),
    ];

    foreach ($this->xpath('//main//table//th') as $key => $th) {
      if ($expected_header[$key] != $th) {
        $this->fail('Table header was found.');
        break;
      }
    }

    $alpha_row_prefix = '//main//table/tbody/tr';

    $label = $this->xpath($alpha_row_prefix . '/td[position() = 1]/a[contains(@href, "/snippet/alpha") and text() = "Alpha"]');
    $this->assertTrue($label, 'Snippet label was found');

    $machine_name = $this->xpath($alpha_row_prefix . '/td[position() = 2 and text() = "alpha"]');
    $this->assertTrue($machine_name, 'Snippet machine name was found');

    $status = $this->xpath($alpha_row_prefix . '/td[position() = 3 and text() = "Enabled"]');
    $this->assertTrue($status, 'Snippet status was found');

    $status = $this->xpath($alpha_row_prefix . '/td[position() = 4 and text() = "58 bytes"]');
    $this->assertTrue($status, 'Snippet size was found');

    $status = $this->xpath($alpha_row_prefix . '/td[position() = 5 and text() = "Snippet manager test basic format"]');
    $this->assertTrue($status, 'Snippet format was found');

    $status = $this->xpath($alpha_row_prefix . '/td[position() = 6 and text() = "Not published"]');
    $this->assertTrue($status, 'Snippet page status was found');

    $links_prefix = $alpha_row_prefix . '/td[position() = 7]//ul[@class="dropbutton"]/li';

    $edit_link = $this->xpath($links_prefix . '/a[contains(@href, "/snippet/alpha/edit") and text() = "Edit"]');
    $this->assertTrue($edit_link, 'Snippet edit link was found');

    $delete_link = $this->xpath($links_prefix . '/a[contains(@href, "/snippet/alpha/delete") and text() = "Delete"]');
    $this->assertTrue($delete_link, 'Snippet delete link was found');
  }

  /**
   * Tests snippet variable form.
   */
  protected function testSnippetVariableForm() {

    $this->drupalGet('snippet/alpha/edit');
    $this->assertLink(t('Add variable'));
    $this->assertLinkByHref('/snippet/alpha/edit/variable/add');

    $this->drupalGet('/snippet/alpha/edit/variable/add');
    $this->assertPageTitle(t('Add variable'));
    $this->assertText(t('Type of the variable'));
    $select_prefix = '//select[@name="plugin_id" and @required]';

    $select_axes[] = '/option[@selected and text()="- Select -"]';
    $select_axes[] = '/optgroup[@label="Condition"]/option[@value="condition:request_path" and text()="Request Path"]';
    $select_axes[] = '/optgroup[@label="Condition"]/option[@value="condition:current_theme" and text()="Current Theme"]';
    $select_axes[] = '/optgroup[@label="Condition"]/option[@value="condition:user_role" and text()="User Role"]';
    $select_axes[] = '/optgroup[@label="Entity"]/option[@value="entity:snippet" and text()="Snippet"]';
    $select_axes[] = '/optgroup[@label="Entity"]/option[@value="entity:user" and text()="User"]';
    $select_axes[] = '/optgroup[@label="Other"]/option[@value="text" and text()="Text"]';
    $select_axes[] = '/optgroup[@label="Other"]/option[@value="url" and text()="Url"]';
    $select_axes[] = '/optgroup[@label="Other"]/option[@value="file" and text()="File"]';
    $select_axes[] = '/optgroup[@label="View"]/option[@value="view:user_admin_people" and text()="People"]';
    $select_axes[] = '/optgroup[@label="View"]/option[@value="view:who_s_new" and text()="Who\'s new"]';
    $select_axes[] = '/optgroup[@label="View"]/option[@value="view:who_s_online" and text()="Who\'s online block"]';

    foreach ($select_axes as $axis) {
      $this->assertByXpath($select_prefix . $axis);
    }

    $this->assertText(t('Name of the variable'));
    $this->assertByXpath('//input[@name="name" and @required]');

    $edit = [
      'plugin_id' => 'text',
      'name' => 'bar',
    ];
    $this->drupalPostForm(NULL, $edit, t('Save and continue'));

    $this->assertPageTitle(t('Edit variable %variable', ['%variable' => $edit['name']]));

    $this->assertUrl('/snippet/alpha/edit/variable/bar/edit');

    $this->drupalGet('snippet/alpha/edit');

    $expected_header = [
      t('Name'),
      t('Type'),
      t('Plugin'),
      t('Operations'),
    ];

    foreach ($this->xpath('//main//table//th') as $key => $th) {
      if ($expected_header[$key] != $th) {
        $this->fail('Valid table header was found.');
        break;
      }
    }

    $variable_row_prefix = '//main//table/tbody/tr';

    $label = $this->xpath($variable_row_prefix . '/td[position() = 1]/a[@href="#snippet-edit-form" and text() = "bar"]');
    $this->assertTrue($label, 'Valid snippet variable label was found');

    $label = $this->xpath($variable_row_prefix . '/td[position() = 2 and text() = "String"]');
    $this->assertTrue($label, 'Valid snippet variable type was found');

    $label = $this->xpath($variable_row_prefix . '/td[position() = 3 and text() = "text"]');
    $this->assertTrue($label, 'Valid snippet variable plugin was found');

    $links_prefix = $variable_row_prefix . '/td[position() = 4]//ul[@class="dropbutton"]/li';

    $edit_link = $this->xpath($links_prefix . '/a[contains(@href, "/snippet/alpha/edit/variable/bar/edit") and text() = "Edit"]');
    $this->assertTrue($edit_link, 'Valid snippet variable edit link was found');

    $delete_link = $this->xpath($links_prefix . '/a[contains(@href, "/snippet/alpha/edit/variable/bar/delete") and text() = "Delete"]');
    $this->assertTrue($delete_link, 'Valid snippet variable delete link was found');

    $this->drupalGet('/snippet/alpha/edit/variable/not-existing-variable/edit');
    $this->assertResponse(404);
  }

  /**
   * Tests snippet variable delete form.
   */
  protected function testSnippetVariableDeleteForm() {
    $this->drupalGet('snippet/alpha/edit/variable/foo/delete');
    $this->assertPageTitle(t('Are you sure you want to delete the variable %variable?', ['%variable' => 'foo']));
    $this->assertText('This action cannot be undone.');
    $this->assertLink(t('Cancel'));
    $this->assertLinkByHref('/snippet/alpha/edit');
    $this->drupalPostForm(NULL, [], t('Delete'));
    $this->assertStatusMessage(t('The variable has been removed.'));
    $this->assertUrl('/snippet/alpha/edit');
    $this->assertText(t('Variables are not configured yet.'));
  }

  /**
   * Tests snippet view pages.
   */
  protected function testSnippetViewPages() {
    $this->drupalGet('snippet/alpha');
    $this->assertPageTitle('Alpha');
    $this->assertText('Hello world');
    $this->assertText('3 + 5 = 8');
    $this->drupalGet('snippet/alpha/html-source');
    $this->assertPageTitle('Alpha');
    $textarea = $this->xpath('//textarea[contains(@class, "snippet-html-source")]')[0];
    $this->assertEqual($textarea->h3[0], 'Hello world!');
    $this->assertEqual($textarea->div->b[0], 8);
    $this->assertPattern('#<div class="snippet-render-time">Render time: <em class="placeholder">.*</em> ms</div>#');
  }

  /**
   * Tests snippet form redirect setting.
   */
  protected function testSnippetFormRedirectSetting() {
    $this->drupalPostForm('snippet/alpha/edit', [], t('Save'));
    $this->assertUrl('snippet/alpha');

    /** @var \Drupal\Core\Config\Config $config */
    $config = \Drupal::service('config.factory')
      ->getEditable('snippet_manager.settings');

    $config
      ->set('redirect_page', 'edit-form')
      ->save();

    $this->drupalPostForm('snippet/alpha/edit', [], t('Save'));
    $this->assertUrl('snippet/alpha/edit');

    $config
      ->set('redirect_page', 'admin')
      ->save();

    $this->drupalPostForm('snippet/alpha/edit', [], t('Save'));
    $this->assertUrl('snippet/alpha/html-source');
  }

  /**
   * Tests duplication form.
   */
  public function testDuplicateForm() {
    $this->drupalGet('admin/structure/snippet');
    $duplicate_link = $this->xpath('//td[. = "Alpha"]/..//a[. = "Duplicate"]');
    $this->drupalGet($this->getAbsoluteUrl($duplicate_link[0]['href']));
    $this->assertPageTitle('Duplicate snippet');
    $this->assertByXpath('//input[@name = "label" and @value = "Duplicate of Alpha"]');
    $this->drupalPostForm(NULL, ['id' => 'alpha'], 'Duplicate');
    $this->assertErrorMessage('The machine-readable name is already in use. It must be unique.');
    $this->drupalPostForm(NULL, ['id' => 'duplicate_of_alpha'], 'Duplicate');
    $this->assertPageTitle('Edit Duplicate of Alpha');
    $this->assertByXpath('//input[@name = "label" and @value = "Duplicate of Alpha"]');
    $this->assertByXpath('//input[@name = "id" and @value = "duplicate_of_alpha"]');
    $this->assertByXpath('//textarea[@name = "code[value]" and contains(., "<h3>{{ foo }}</h3>")]');
    $this->assertByXpath('//td/a[@class = "snippet-variable" and . = "foo"]');
  }

}
