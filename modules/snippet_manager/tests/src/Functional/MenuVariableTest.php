<?php

namespace Drupal\Tests\snippet_manager\Functional;

/**
 * Menu variable test.
 *
 * @group snippet_manager
 */
class MenuVariableTest extends TestBase {

  /**
   * Tests menu variable plugin.
   */
  public function testMenuVariable() {

    $edit = [
      'template[value]' => '<div class="snippet-content">{{ test_menu }}</div>',
    ];
    $this->drupalPostForm('admin/structure/snippet/alpha/edit/template', $edit, 'Save');

    // Create menu variable.
    $edit = [
      'plugin_id' => 'menu:snippet-manager-test',
      'name' => 'test_menu',
    ];
    $this->drupalPostForm('admin/structure/snippet/alpha/edit/variable/add', $edit, 'Save and continue');
    $this->assertStatusMessage('The variable has been created.');
    $this->assertPageTitle(t('Edit variable %name', ['%name' => 'test_menu']));

    $this->assertByXpath('//form/div/label[.="Initial visibility level"]/../select[@name="configuration[level]"]/option[@value="1" and @selected="selected"]');
    $this->assertByXpath('//form/div/label[.="Number of levels to display"]/../select[@name="configuration[depth]"]/option[@value="0" and @selected="selected" and .="Unlimited"]');

    // Test default menu configuration.
    $this->drupalPostForm('admin/structure/snippet/alpha/edit/variable/test_menu/edit', [], 'Save');

    $this->assertByXpath('//td/a[@class="snippet-variable" and .="test_menu"]');

    // The link does not exist because Menu UI module is not enabled.
    $this->assertSession()->linkNotExists('Edit menu');

    // Enable Menu UI and check it the link appears in dropdown widget.
    $this->container->get('module_installer')->install(['menu_ui']);
    $this->drupalGet('admin/structure/snippet/alpha/edit/template');
    $this->assertByXpath('//td[.="test_menu"]/../td//ul/li/a[contains(@href, "admin/structure/menu/manage/snippet-manager-test") and .="Edit menu"]');

    // Check if the menu is rendered correctly.
    $this->drupalGet('admin/structure/snippet/alpha');
    $this->assertByXpath('//div[@class = "snippet-content"]/ul[@class = "menu"]/li/a[. = "Link 1"]/../ul[@class = "menu"]/li/ul[@class = "menu"]/li/a[. = "Link 3"]');

    // Test level option.
    $edit = [
      'configuration[level]' => 2,
    ];
    $this->drupalPostForm('/admin/structure/snippet/alpha/edit/variable/test_menu/edit', $edit, 'Save');
    $this->drupalGet('/admin/structure/snippet/alpha');
    $this->assertByXpath('//div[@class = "snippet-content"]/ul[@class = "menu"]/li/a[. = "Link 2"]/../ul[@class = "menu"]/li/a[. = "Link 3"]');

    // Test depth option.
    $edit = [
      'configuration[level]' => 1,
      'configuration[depth]' => 1,
    ];
    $this->drupalPostForm('/admin/structure/snippet/alpha/edit/variable/test_menu/edit', $edit, 'Save');
    $this->drupalGet('/admin/structure/snippet/alpha');
    $this->assertByXpath('//div[@class = "snippet-content"]/ul[@class = "menu"]/li[not(ul)]/a[. = "Link 1"]');

  }

}
