<?php

namespace Drupal\Tests\snippet_manager\Unit;

use Drupal\Core\DependencyInjection\ContainerBuilder;
use Drupal\Core\StringTranslation\TranslatableMarkup;
use Drupal\snippet_manager\SnippetInterface;
use Drupal\Tests\UnitTestCase;

/**
 * Tests for the snippet list builder.
 *
 * @coversDefaultClass \Drupal\snippet_manager\SnippetListBuilder
 *
 * @group snippet_manager
 */
class SnippetListBuilderTest extends UnitTestCase {

  /**
   * The mocked translator.
   *
   * @var \Drupal\Core\StringTranslation\TranslationInterface
   */
  protected $stringTranslation;

  /**
   * The container builder.
   *
   * @var \Drupal\Core\DependencyInjection\ContainerBuilder
   */
  protected $container;

  /**
   * The snippet list builder to test.
   *
   * @var \Drupal\snippet_manager\SnippetListBuilder
   */
  protected $listBuilder;

  /**
   * {@inheritdoc}
   */
  protected function setUp() {
    parent::setUp();

    $this->stringTranslation = $this->getMock('Drupal\Core\StringTranslation\TranslationInterface');

    $this->container = new ContainerBuilder();
    $module_handler = $this->getMock('Drupal\Core\Extension\ModuleHandlerInterface');
    $module_handler->method('invokeAll')->willReturn([]);
    $this->container->set('module_handler', $module_handler);
    \Drupal::setContainer($this->container);

    /** @var \Drupal\Core\Entity\EntityTypeInterface $entity_type */
    $entity_type = $this->getMock('Drupal\Core\Entity\EntityTypeInterface');

    /** @var \Drupal\Core\Entity\EntityStorageInterface $entity_storage */
    $entity_storage = $this->getMock('Drupal\Core\Entity\EntityStorageInterface');

    if (!defined('RESPONSIVE_PRIORITY_MEDIUM')) {
      define('RESPONSIVE_PRIORITY_MEDIUM', 'priority-medium');
    }

    if (!defined('RESPONSIVE_PRIORITY_LOW')) {
      define('RESPONSIVE_PRIORITY_LOW', 'priority-low');
    }

    $this->listBuilder = $this->getMock(
      'Drupal\snippet_manager\SnippetListBuilder',
      ['getFormatLabel', 'formatSize'],
      [$entity_type, $entity_storage]
    );

    $this->listBuilder->setStringTranslation($this->stringTranslation);
  }

  /**
   * Test callback.
   *
   * @covers ::buildHeader
   */
  public function testBuilderHeader() {

    $header = $this->listBuilder->buildHeader();

    $expected_header = [
      'name' => 'Name',
      'id' => 'ID',
      'status' => 'Status',
      'size' => 'Size',
      'format' => 'Format',
      'page' => 'Page',
      'block' => 'Block',
      'operations' => 'Operations',
    ];

    foreach ($expected_header as $key => $value) {
      $expected_value = is_array($header[$key]) ? $header[$key]['data'] : $header[$key];
      // @codingStandardsIgnoreStart
      $this->assertEquals($expected_value, new TranslatableMarkup($value, [], [], $this->stringTranslation));
      // @codingStandardsIgnoreEnd
    }

  }

  /**
   * Test callback.
   *
   * @param \Drupal\snippet_manager\SnippetInterface $snippet
   *   Mock snippet.
   *
   * @covers ::buildRow
   *
   * @dataProvider getData
   */
  public function testBuilderRow(SnippetInterface $snippet) {
    $row = $this->listBuilder->buildRow($snippet);

    $this->assertEquals($row['name'], $snippet->toLink());
    $this->assertEquals($row['id'], $snippet->id());
    $disabled_status_value = [
      'data' => $this->trans('Disabled'),
      'class' => ['sm-inactive'],
    ];
    $this->assertEquals($row['status'], $snippet->status() ? $this->trans('Enabled') : $disabled_status_value);

    $this->assertEquals($row['page'], $snippet->get('page')['status'] ? $snippet->get('page')['path'] : '');
    $this->assertEquals($row['block'], $snippet->get('block')['status'] ? $snippet->get('block')['name'] : '');
  }

  /**
   * Data provider for testBuilderRow().
   *
   * @return array
   *   Mock data set.
   */
  public function getData() {
    $snippet = $this->getMock(SnippetInterface::CLASS);

    $data = [];
    for ($i = 0; $i < 10; $i++) {
      $snippet->method('toLink')->willReturn($this->trans($this->randomMachineName()));
      $snippet->method('id')->willReturn($this->trans($this->randomMachineName()));

      $page = [
        'status' => mt_rand(0, 1),
        // Prefix with "%" to prevent link creation.
        'path' => '%' . $this->randomMachineName(),
      ];
      $block = [
        'status' => mt_rand(0, 1),
        'name' => $this->randomMachineName(),
      ];
      $snippet->method('get')->will(
        $this->returnValueMap(
          [
            ['page', $page],
            ['block', $block],
          ]
        )
      );

      $snippet->method('status')->willReturn(mt_rand(0, 1));
      $data[][] = $snippet;
    }

    return $data;
  }

  /**
   * Mocked translate function.
   *
   * @param string $string
   *   A string containing the English text to translate.
   *
   * @return \Drupal\Core\StringTranslation\TranslatableMarkup
   *   TranslatableMarkup object
   */
  protected function trans($string) {
    // @codingStandardsIgnoreStart
    return new TranslatableMarkup($string, [], [], $this->stringTranslation);
    // @codingStandardsIgnoreEnd
  }

}
