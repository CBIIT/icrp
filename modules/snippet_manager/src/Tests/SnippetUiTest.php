<?php

namespace Drupal\snippet_manager\Tests;

/**
 * Tests the Snippet manager user interface.
 *
 * @group snippet_manager
 *
 * @TODO: Turn this to browser test case.
 */
class SnippetUiTest extends TestBase {

  /**
   * Tests snippets list.
   */
  public function testSnippetsList() {
    $this->drupalGet('admin/structure/snippet');
    $this->assertPageTitle(t('Snippets'));

    $search_input = $this->xpath('//main//input[@type="search" and @data-drupal-selector="sm-snippet-filter" and @placeholder="Filter by snippet name or ID"]');
    $this->assertTrue($search_input, 'Snippet search input was found');

    $expected_header = [
      t('Name'),
      t('ID'),
      t('Status'),
      t('Size'),
      t('Format'),
      t('Page'),
      t('Block'),
      t('Operations'),
    ];

    foreach ($this->xpath('//main//table//th') as $key => $th) {
      $this->assertTrue($expected_header[$key] == $th, 'Table header was found.');
    }

    $alpha_row_prefix = '//main//table/tbody/tr';

    $label = $this->xpath($alpha_row_prefix . '/td[position() = 1]/a[contains(@href, "/admin/structure/snippet/alpha") and text() = "Alpha"]');
    $this->assertTrue($label, 'Snippet label was found');

    $machine_name = $this->xpath($alpha_row_prefix . '/td[position() = 2 and text() = "alpha"]');
    $this->assertTrue($machine_name, 'Snippet machine name was found');

    $status = $this->xpath($alpha_row_prefix . '/td[position() = 3 and text() = "Enabled"]');
    $this->assertTrue($status, 'Snippet status was found');

    $status = $this->xpath($alpha_row_prefix . '/td[position() = 4 and text() = "58 bytes"]');
    $this->assertTrue($status, 'Snippet size was found');

    $status = $this->xpath($alpha_row_prefix . '/td[position() = 5 and text() = "Snippet manager test basic format"]');
    $this->assertTrue($status, 'Snippet format was found');

    $status = $this->xpath($alpha_row_prefix . '/td[position() = 6]/a[contains(@href, "/alpha-page") and text() = "alpha-page"]');
    $this->assertTrue($status, 'Snippet page was found');

    $status = $this->xpath($alpha_row_prefix . '/td[position() = 7 and text() = "Alpha block"]');
    $this->assertTrue($status, 'Snippet block was found');

    $links_prefix = $alpha_row_prefix . '/td[position() = 8]//ul[@class="dropbutton"]/li';

    $edit_link = $this->xpath($links_prefix . '/a[contains(@href, "/admin/structure/snippet/alpha/edit") and text() = "Edit"]');
    $this->assertTrue($edit_link, 'Snippet edit link was found');

    $delete_link = $this->xpath($links_prefix . '/a[contains(@href, "/admin/structure/snippet/alpha/delete") and text() = "Delete"]');
    $this->assertTrue($delete_link, 'Snippet delete link was found');
  }

  /**
   * Tests snippet variable form.
   */
  protected function testSnippetVariableForm() {

    $this->drupalGet('admin/structure/snippet/alpha/edit/template');
    $this->assertLink(t('Add variable'));
    $this->assertLinkByHref('/admin/structure/snippet/alpha/edit/variable/add');

    $this->drupalGet('/admin/structure/snippet/alpha/edit/variable/add');
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

    $this->assertUrl('/admin/structure/snippet/alpha/edit/variable/bar/edit');

    $this->drupalGet('admin/structure/snippet/alpha/edit/template');

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

    $this->drupalGet('/admin/structure/snippet/alpha/edit/variable/not-existing-variable/edit');
    $this->assertResponse(404);
  }

  /**
   * Tests snippet variable delete form.
   */
  protected function testSnippetVariableDeleteForm() {
    $this->drupalGet('/admin/structure/snippet/alpha/edit/variable/foo/delete');
    $this->assertPageTitle(t('Are you sure you want to delete the variable %variable?', ['%variable' => 'foo']));
    $this->assertText('This action cannot be undone.');
    $this->assertLink(t('Cancel'));
    $this->assertLinkByHref('/admin/structure/snippet/alpha/edit');
    $this->drupalPostForm(NULL, [], t('Delete'));
    $this->assertStatusMessage(t('The variable has been removed.'));
    $this->assertUrl('/admin/structure/snippet/alpha/edit/template');
    $this->assertText(t('Variables are not configured yet.'));
  }

  /**
   * Tests snippet view pages.
   */
  protected function testSnippetViewPages() {
    $this->drupalGet('/admin/structure/snippet/alpha');
    $this->assertPageTitle('Alpha');
    $this->assertText('Hello world');
    $this->assertText('3 + 5 = 8');
    $this->drupalGet('/admin/structure/snippet/alpha/source');
    $this->assertPageTitle('Alpha');
    $textarea = $this->xpath('//textarea[contains(@class, "snippet-html-source")]')[0];
    $this->assertEqual($textarea->h3[0], 'Hello world!');
    $this->assertEqual($textarea->div->b[0], 8);
    $this->assertPattern('#<div class="snippet-render-time">Render time: <em class="placeholder">.*</em> ms</div>#');
  }

}
