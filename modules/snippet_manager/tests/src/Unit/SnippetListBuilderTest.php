<?php

namespace Drupal\Tests\snippet_manager\Unit;

use Drupal\Core\DependencyInjection\ContainerBuilder;
use Drupal\Core\StringTranslation\TranslatableMarkup;
use Drupal\snippet_manager\SnippetInterface;
use Drupal\snippet_manager\SnippetListBuilder;
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

    $this->listBuilder = new SnippetListBuilder($entity_type, $entity_storage);
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
      'label' => 'Label',
      'id' => 'Machine name',
      'status' => 'Status',
      'page' => 'Page',
    ];

    foreach ($expected_header as $key => $value) {
      // @codingStandardsIgnoreStart
      $this->assertEquals($header[$key], new TranslatableMarkup($value, [], [], $this->stringTranslation));
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

    $this->assertEquals($row['label'], $snippet->toLink());
    $this->assertEquals($row['id'], $snippet->id());
    $this->assertEquals($row['status'], $snippet->status() ? $this->trans('Enabled') : $this->trans('Disabled'));
    $this->assertEquals($row['page'], $snippet->pageIsPublished() ? $this->trans('Published') : $this->trans('Not published'));
  }

  /**
   * Data provider for buildRow test.
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
      $snippet->method('pageIsPublished')->willReturn(mt_rand(0, 1));
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
