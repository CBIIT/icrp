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

    $default_item = [
      'status' => TRUE,
      'access' => [
        'type' => '',
        'permission' => [],
        'role' => [],
      ],
      'user' => [
        'roles' => [],
        'permissions' => [],
      ],
      'operation' => 'view-published',
    ];

    $item = [
      'access' => [
        'type' => 'all',
      ],
      'result' => TRUE,
    ];
    $items[] = $item + $default_item;

    $item = [
      'access' => [
        'type' => 'all',
      ],
      'status' => FALSE,
      'result' => FALSE,
    ];
    $items[] = $item + $default_item;

    $item = [
      'access' => [
        'type' => 'permission',
        'permission' => 'foo',
      ],
      'result' => FALSE,
    ];
    $items[] = $item + $default_item;

    $item = [
      'access' => [
        'type' => 'permission',
        'permission' => 'foo',
      ],
      'user' => [
        'permissions' => ['foo'],
      ],
      'result' => TRUE,
    ];
    $items[] = $item + $default_item;

    $item = [
      'access' => [
        'type' => 'role',
        'role' => ['foo'],
      ],
      'user' => [
        'roles' => [],
      ],
      'result' => FALSE,
    ];
    $items[] = $item + $default_item;

    $item = [
      'access' => [
        'type' => 'role',
        'role' => ['foo'],
      ],
      'user' => [
        'roles' => ['foo'],
      ],
      'result' => TRUE,
    ];
    $items[] = $item + $default_item;

    $item = [
      'access' => [
        'type' => 'all',
      ],
      'operation' => 'edit',
      'result' => FALSE,
    ];
    $items[] = $item + $default_item;

    $item = [
      'access' => [
        'type' => 'all',
      ],
      'user' => [
        'permissions' => ['administer snippets'],
      ],
      'operation' => 'edit',
      'result' => TRUE,
    ];
    $items[] = $item + $default_item;

    $data = [];
    foreach ($items as $item) {

      $item['user']['permissions'] = isset($item['user']['permissions']) ? $item['user']['permissions'] : [];
      $item['user']['roles'] = isset($item['user']['roles']) ? $item['user']['roles'] : [];

      $snippet = clone $this->snippet;
      $account = clone $this->account;

      $snippet->method('status')->willReturn($item['status']);

      $snippet->method('get')
        ->with('access')
        ->willReturn($item['access']);

      $account
        ->method('hasPermission')
        ->willReturnCallback(function ($permission) use ($item) {
          return in_array($permission, $item['user']['permissions']);
        });

      $account
        ->method('getRoles')
        ->willReturn($item['user']['roles']);

      $data[] = [
        $snippet,
        $item['operation'],
        $account,
        $item['result'],
      ];
    }

    return $data;
  }

}
