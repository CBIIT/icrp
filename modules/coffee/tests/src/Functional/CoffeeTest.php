<?php

namespace Drupal\Tests\coffee\Functional;

use Drupal\Tests\BrowserTestBase;

/**
 * Tests Coffee module functionality.
 *
 * @group coffee
 */
class CoffeeTest extends BrowserTestBase {

  /**
   * Modules to enable.
   *
   * @var array
   */
  public static $modules = ['coffee'];

  /**
   * The user for tests.
   *
   * @var \Drupal\user\UserInterface
   */
  protected $webUser;

  /**
   * The user for tests.
   *
   * @var \Drupal\user\UserInterface
   */
  protected $coffeeUser;

  /**
   * The user for tests.
   *
   * @var \Drupal\user\UserInterface
   */
  protected $coffeeAdmin;

  /**
   * {@inheritdoc}
   */
  public function setUp() {
    parent::setUp();

    $this->webUser = $this->drupalCreateUser();
    $this->coffeeUser = $this->drupalCreateUser(['access coffee']);
    $this->coffeeAdmin = $this->drupalCreateUser(['administer coffee']);
  }

  /**
   * Tests coffee configuration form.
   */
  public function testCoffeeConfiguration() {
    $this->drupalGet('admin/config/user-interface/coffee');
    $this->assertSession()->statusCodeEquals(403);

    $this->drupalLogin($this->coffeeAdmin);
    $this->drupalGet('admin/config/user-interface/coffee');
    $this->assertSession()->statusCodeEquals(200);
    $this->assertSession()->checkboxChecked('edit-coffee-menus-admin');
    $this->assertSession()->fieldValueEquals('edit-max-results', 7);

    $edit = [
      'coffee_menus[tools]' => 'tools',
      'coffee_menus[account]' => 'account',
      'max_results' => 15,
    ];
    $this->drupalPostForm('admin/config/user-interface/coffee', $edit, t('Save configuration'));
    $this->assertSession()->pageTextContains(t('The configuration options have been saved.'));

    $expected = [
      'admin' => 'admin',
      'tools' => 'tools',
      'account' => 'account',
    ];
    $config = \Drupal::config('coffee.configuration')->get('coffee_menus');
    $this->assertEquals($expected, $config, 'The configuration options have been properly saved');

    $config = \Drupal::config('coffee.configuration')->get('max_results');
    $this->assertEquals(15, $config, 'The configuration options have been properly saved');
  }

  /**
   * Tests coffee configuration cache tags invalidation.
   */
  public function testCoffeeCacheTagsInvalidation() {
    $coffee_cache_tag = 'config:coffee.configuration';
    // Coffee is not loaded for users without the adequate permission,
    // so no cache tags for coffee configuration are added.
    $this->drupalGet('');
    $this->assertSession()->responseHeaderNotContains('X-Drupal-Cache-Tags', $coffee_cache_tag);

    // Make sure that the coffee configuration cache tags are present
    // for users with the adequate permission.
    $this->drupalLogin($this->coffeeUser);
    $this->drupalGet('');
    $this->assertSession()->responseHeaderContains('X-Drupal-Cache-Tags', $coffee_cache_tag);
    $settings = $this->getDrupalSettings();
    $this->assertEquals(7, $settings['coffee']['maxResults']);

    // Trigger a config save which should clear the page cache, so we should get
    // the fresh configuration settings.
    $max_results = 10;
    $this->config('coffee.configuration')
      ->set('max_results', $max_results)
      ->save();

    $this->drupalGet('');
    $this->assertSession()->responseHeaderContains('X-Drupal-Cache-Tags', $coffee_cache_tag);
    $settings = $this->getDrupalSettings();
    $this->assertEquals($max_results, $settings['coffee']['maxResults']);
  }

  /**
   * Tests that the coffee assets are loaded properly.
   */
  public function testCoffeeAssets() {
    // Ensure that the coffee assets are not loaded for users without the
    // adequate permission.
    $this->drupalGet('');
    $this->assertSession()->responseNotContains('coffee/js/coffee.js');

    // Ensure that the coffee assets are loaded properly for users with the
    // adequate permission.
    $this->drupalLogin($this->coffeeUser);
    $this->drupalGet('');
    $this->assertSession()->responseContains('coffee/js/coffee.js');

    // Ensure that the coffee assets are not loaded for users without the
    // adequate permission.
    $this->drupalLogin($this->webUser);
    $this->drupalGet('');
    $this->assertSession()->responseNotContains('coffee/js/coffee.js');
  }

  /**
   * Tests that the toolbar integration works properly.
   */
  public function testCoffeeToolbarIntegration() {
    \Drupal::service('module_installer')->install(['toolbar']);
    $tab_xpath = '//nav[@id="toolbar-bar"]//div/a[contains(@class, "toolbar-icon-coffee")]';

    $toolbar_user = $this->drupalCreateUser(['access toolbar']);
    $this->drupalLogin($toolbar_user);
    $this->assertSession()->responseContains('id="toolbar-administration"');
    $this->assertSession()->elementNotExists('xpath', $tab_xpath);

    $coffee_toolbar_user = $this->drupalCreateUser(['access toolbar', 'access coffee']);
    $this->drupalLogin($coffee_toolbar_user);
    $this->assertSession()->responseContains('id="toolbar-administration"');
    $this->assertSession()->elementExists('xpath', $tab_xpath);
  }

}
