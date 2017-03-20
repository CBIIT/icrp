<?php

namespace Drupal\Tests\snippet_manager\Functional;

/**
 * Snippet form test.
 *
 * @group snippet_manager
 */
class SnippetFormTest extends TestBase {

  /**
   * Tests snippet add/edit form.
   */
  public function testSnippetForm() {
    $this->drupalGet('admin/structure/snippet/add');
    $this->assertPageTitle('Add snippet');

    $this->assertByXpath('//div[contains(@class, "form-item-label") and label[.="Label"] and input[@name="label"]]');
    $this->assertByXpath('//div[contains(@class, "form-item-id") and label[.="Machine-readable name"] and input[@name="id"]]');

    $this->assertByXpath('//div[contains(@class, "form-item-id") and label[.="Machine-readable name"] and input[@name="id"]]');

    $page_prefix = '//fieldset[legend/span[.="Page"]]';
    $this->assertByXpath($page_prefix . '//input[@name="page[status]" and not(@checked)]/following::label[.="Enable snippet page"]');
    $this->assertByXpath($page_prefix . '//label[.="Title"]/following::input[@name="page[title]"]');
    $this->assertByXpath($page_prefix . '//label[.="Path"]/following::input[@name="page[path]"]');
    $this->assertByXpath($page_prefix . '//label[.="Display variant"]/following::select[@name="page[display_variant][id]"]');
    $this->assertByXpath($page_prefix . '//label[.="Theme"]/following::select[@name="page[theme]"]');

    $access_prefix = '//fieldset[legend/span[.="Access"]]';
    $this->assertByXpath($access_prefix . '//input[@name="access[type]" and @value="all" and @checked]/following::label[.="Do not limit"]');
    $this->assertByXpath($access_prefix . '//input[@name="access[type]" and @value="permission"]/following::label[.="Permission"]');
    $this->assertByXpath($access_prefix . '//input[@name="access[type]" and @value="role"]/following::label[.="Role"]');
    $this->assertByXpath($access_prefix . '//label[.="Permission"]/following::select[@name="access[permission]"]');
    $this->assertByXpath($access_prefix . '//input[@name="access[role][anonymous]" and @value="anonymous"]/following::label[.="Anonymous user"]');
    $this->assertByXpath($access_prefix . '//input[@name="access[role][authenticated]" and @value="authenticated"]/following::label[.="Authenticated user"]');

    $this->assertByXpath('//div[contains(@class, "form-actions")]/input[@value="Save"]');

    // Submit form and check if the snippet is rendered.
    $snippet_label = $this->randomMachineName();
    $snippet_id = strtolower($this->randomMachineName());
    $edit = [
      'label' => $snippet_label,
      'id' => $snippet_id,
      'page[status]' => TRUE,
      'page[title]' => 'Foo',
      'page[path]' => '/foo',
      'page[display_variant][id]' => 'simple_page',
      'access[type]' => 'permission',
      'access[permission]' => 'administer modules',

    ];
    $this->drupalPostForm(NULL, $edit, t('Save'));

    $this->assertSession()->addressEquals("admin/structure/snippet/$snippet_id/edit");
    $this->assertPageTitle(t('Edit %label', ['%label' => $snippet_label]));
    $this->assertStatusMessage(t('Snippet %label has been created.', ['%label' => $snippet_label]));

    $this->assertByXpath(sprintf('//input[@name="label" and @value="%s"]', $snippet_label));
    $this->assertByXpath(sprintf('//input[@name="id" and @value="%s"]', $snippet_id));

    $this->assertByXpath($page_prefix . '//input[@name="page[status]" and @checked]');
    $this->assertByXpath($page_prefix . '//input[@name="page[title]" and @value="Foo"]');
    $this->assertByXpath($page_prefix . '//input[@name="page[path]" and @value="foo"]');
    $this->assertByXpath($page_prefix . '//select[@name="page[display_variant][id]"]/option[@value="simple_page" and @selected]');

    $this->assertByXpath($access_prefix . '//input[@name="access[type]" and @value="permission" and @checked]');
    $this->assertByXpath($access_prefix . '//select[@name="access[permission]"]//option[@value="administer modules" and @selected]');

    $this->assertByXpath(sprintf('//div[contains(@class, "form-actions")]/a[contains(@href, "/admin/structure/snippet/%s/delete") and .="Delete"]', $snippet_id));
  }

  /**
   * Tests snippet delete form.
   */
  public function testSnippetDeleteForm() {
    $this->drupalGet('admin/structure/snippet');
    $this->click(sprintf('//td[.="%s"]/../td//ul[@class="dropbutton"]/li/a[.="Delete"]', $this->snippetId));
    $this->assertPageTitle(t('Are you sure you want to delete the snippet %label?', ['%label' => $this->snippetLabel]));
    $this->assertByXpath('//form[contains(., "This action cannot be undone.")]');
    $this->assertByXpath('//form//a[.="Cancel"]');
    $this->assertByXpath('//form//a[contains(@href, "/admin/structure/snippet") and .="Cancel"]');
    $this->drupalPostForm(NULL, [], t('Delete'));
    $this->assertStatusMessage(t('The snippet %label has been deleted.', ['%label' => $this->snippetLabel]));
    $this->assertSession()->elementNotExists('xpath', sprintf('//a[contains(., "%s")]', $this->snippetLabel));
    $this->assertSession()->addressEquals('admin/structure/snippet');
  }

  /**
   * Tests duplication form.
   */
  public function testDuplicateForm() {
    // Add a variable to the cloning snippet to check it later.
    $edit = [
      'plugin_id' => 'text',
      'name' => 'foo',
    ];
    $this->drupalPostForm($this->snippetUrl . '/edit/variable/add', $edit, 'Save');

    $this->drupalGet('admin/structure/snippet');
    $this->click(sprintf('//td[.="%s"]/../td//ul[@class="dropbutton"]/li/a[.="Duplicate"]', $this->snippetLabel));
    $this->assertPageTitle('Duplicate snippet');
    $this->assertByXpath(sprintf('//input[@name = "label" and @value = "Duplicate of %s"]', $this->snippetLabel));
    $this->drupalPostForm(NULL, ['id' => $this->snippetId], 'Duplicate');
    $this->assertErrorMessage('The machine-readable name is already in use. It must be unique.');
    $this->drupalPostForm(NULL, ['id' => sprintf('duplicate_of_%s', $this->snippetId)], 'Duplicate');

    // Check configuration form.
    $this->assertPageTitle(t('Edit %label', ['%label' => 'Duplicate of ' . $this->snippetLabel]));
    $this->assertByXpath(sprintf('//input[@name = "label" and @value = "Duplicate of %s"]', $this->snippetLabel));
    $this->assertByXpath(sprintf('//input[@name = "id" and @value = "duplicate_of_%s"]', $this->snippetId));

    // Check template form.
    $this->drupalGet($this->snippetUrl . '/edit/template');
    $this->assertByXpath('//textarea[@name = "template[value]" and contains(., \'<div class="snippet-test">{{ 3 * 3 }}</div>\')]');
    $this->assertByXpath('//td/a[@class = "snippet-variable" and .= "foo"]');
  }

}
