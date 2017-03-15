<?php

namespace Drupal\Tests\snippet_manager\Functional;

/**
 * Snippet template test.
 *
 * @group snippet_manager
 */
class SnippetTemplateTest extends TestBase {

  /**
   * Tests snippet template form.
   */
  public function testSnippetTemplate() {
    $this->drupalGet($this->snippetUrl . '/edit/template');
    $this->assertPageTitle(t('Edit %label', ['%label' => $this->snippetLabel]));

    $this->assertByXpath('//div[contains(@class, "form-item-template-value") and label[.="Template"] and //textarea[@name="template[value]"]]');
    $this->assertByXpath('//div[contains(@class, "form-item-template-format")]/label[.="Text format"]/../select/option[@selected="selected" and .="Snippet manager test basic format"]');

    $this->assertByXpath('//table[caption[.="Variables"]]/tbody//td[.="Variables are not configured yet."]');
    $this->assertByXpath('//div[contains(@class, "form-actions")]/input[@value="Save"]');
    $this->assertByXpath(sprintf('//div[contains(@class, "form-actions")]/a[contains(@href, "/%s/edit/variable/add") and .="Add variable"]', $this->snippetUrl));

    // Submit form and check form default values.
    $edit = [
      'template[value]' => '<div class="snippet-test">{{ 3 + 4 }}</div>',
      'template[format]' => 'snippet_manager_test_basic_format',
    ];
    $this->drupalPostForm($this->snippetUrl . '/edit/template', $edit, t('Save'));

    $this->assertStatusMessage(t('Snippet %label has been updated.', ['%label' => $this->snippetLabel]));

    $this->assertSession()->addressEquals($this->snippetUrl . '/edit/template');

    $this->assertByXpath('//textarea[@name="template[value]" and .=\'<div class="snippet-test">{{ 3 + 4 }}</div>\']');
    $this->assertByXpath('//select/option[@selected="selected" and .="Snippet manager test basic format"]');

    $this->drupalGet($this->snippetUrl);
    $this->assertByXpath('//div[@class="snippet-test" and .="7"]');
  }

}
