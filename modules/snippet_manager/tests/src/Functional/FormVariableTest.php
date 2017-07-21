<?php

namespace Drupal\Tests\snippet_manager\Functional;

/**
 * Form variable test.
 *
 * @group snippet_manager
 */
class FormVariableTest extends TestBase {

  /**
   * Tests form variable plugin.
   */
  public function testFormVariable() {
    $edit = [
      'plugin_id' => 'form:user_login',
      'name' => 'user_login_form',
    ];
    $this->drupalPostForm($this->snippetUrl . '/edit/variable/add', $edit, 'Save and continue');
    $this->assertStatusMessage('The variable has been created.');

    $this->drupalPostForm(NULL, [], 'Save');
    $this->assertStatusMessage('The variable has been updated.');

    $edit = [
      'template[value]' => '<div class="snippet-form">{{ user_login_form }}</div>',
    ];
    $this->drupalPostForm(NULL, $edit, 'Save');
    $this->drupalGet($this->snippetUrl);

    $this->assertXpath('//div[@class="snippet-form"]/form//input[@type="submit" and @value="Log in"]');
  }

}
