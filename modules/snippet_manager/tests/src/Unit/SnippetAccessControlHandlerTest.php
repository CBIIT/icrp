<?php

namespace Drupal\Tests\snippet_manager\Unit;

use Drupal\Core\DependencyInjection\ContainerBuilder;
use Drupal\Core\Session\AccountInterface;
use Drupal\snippet_manager\SnippetAccessControlHandler;
use Drupal\snippet_manager\SnippetInterface;
use Drupal\Tests\UnitTestCase;

/**
 * Tests for the snippet access control handler.
 *
 * @coversDefaultClass \Drupal\snippet_manager\SnippetAccessControlHandler
 *
 * @group snippet_manager
 */
class SnippetAccessControlHandlerTest extends UnitTestCase {

  /**
   * The container builder.
   *
   * @var \Drupal\Core\DependencyInjection\ContainerBuilder
   */
  protected $container;

  /**
   * The snippet.
   *
   * @var \Drupal\snippet_manager\SnippetInterface
   */
  protected $snippet;

  /**
   * The snippet list builder to test.
   *
   * @var \Drupal\Core\Session\AccountInterface
   */
  protected $account;

  /**
   * The snippet access control handler to test.
   *
   * @var \Drupal\snippet_manager\SnippetAccessControlHandler
   */
  protected $accessControlHandler;

  /**
   * {@inheritdoc}
   */
  protected function setUp() {
    parent::setUp();

    $container = new ContainerBuilder();
    $module_handler = $this->getMock('Drupal\Core\Extension\ModuleHandlerInterface');
    $module_handler->method('invokeAll')->willReturn([]);
    $container->set('module_handler', $module_handler);

    // Mock cache context manager to satisfy assert() statement in
    // \Drupal\Core\Cache\Cache::mergeContexts().
    $cache_context_manager = $this->getMockBuilder('Drupal\Core\Cache\Context\CacheContextsManager')
      ->disableOriginalConstructor()
      ->getMock();
    $cache_context_manager->method('assertValidTokens')->willReturn(TRUE);
    $container->set('cache_contexts_manager', $cache_context_manager);

    \Drupal::setContainer($container);

    $this->account = $this->getMock('Drupal\Core\Session\AccountInterface');

    $entity_type = $this->getMock('Drupal\Core\Entity\EntityTypeInterface');
    $entity_type->method('getAdminPermission')->willReturn('administer snippets');

    /** @var \Drupal\Core\Entity\EntityTypeInterface $entity_type */
    $this->accessControlHandler = new SnippetAccessControlHandler($entity_type);
  }

  /**
   * Test callback.
   *
   * @param \Drupal\snippet_manager\SnippetInterface $snippet
   *   Mocked snipped object.
   * @param string $operation
   *   Mocked snipped object.
   * @param \Drupal\Core\Session\AccountInterface $account
   *   Mocked account object.
   * @param bool $expected_result
   *   The expected result of access check.
   *
   * @covers ::access
   *
   * @dataProvider getData
   */
  public function testAccessControlHandler(SnippetInterface $snippet, $operation, AccountInterface $account, $expected_result) {

    $is_object = (bool) mt_rand(0, 1);

    /** @var \Drupal\snippet_manager\SnippetInterface $snippet */
    $result = $this->accessControlHandler->access($snippet, $operation, $account, $is_object);
    $this->assertEquals($is_object ? $result->isAllowed() : $result, $expected_result);
  }

  /**
   * Data provider for AccessControlHandler test.
   *
   * @return array
   *   Mock data set.
   */
  public function getData() {

    $this->snippet = $this->getMock(SnippetInterface::CLASS);
    $this->snippet->method('getCacheTags')->willReturn([]);
    $language = $this->getMock('\Drupal\Core\Language\LanguageInterface');
    $this->snippet->method('language')->willReturn($language);

    $this->account = $this->getMock('Drupal\Core\Session\AccountInterface');

    // The conditions array represents all possible combinations of five boolean
    // conditions that will be checked in the access handler.
    // 0 - the snippet is enabled.
    // 1 - the snippet page is published.
    // 2 - the operation is 'view'.
    // 3 - the user has 'administer snippets' permission.
    // 4 - the user has 'view published snippets' permission.
    $data = [];
    for ($i = 0; $i < 32; $i++) {

      $snippet = clone $this->snippet;
      $account = clone $this->account;

      $conditions = str_split(str_pad(decbin($i), 5, 0, STR_PAD_LEFT));

      $snippet->method('status')->willReturn($conditions[0]);
      $snippet->method('pageIsPublished')->willReturn($conditions[1]);
      $operation = $conditions[2] ? 'view' : 'edit';

      $permission_map = [
        ['administer snippets', $conditions[3]],
        ['view published snippets', $conditions[4]],
      ];

      $account
        ->method('hasPermission')
        ->will($this->returnValueMap($permission_map));

      $result = ($conditions[2] && !$conditions[3]) ?
        $conditions[0] && $conditions[1] && $conditions[4] : (bool) $conditions[3];

      $data[] = [
        $snippet,
        $operation,
        $account,
        $result,
      ];

    }
    return $data;
  }

}
