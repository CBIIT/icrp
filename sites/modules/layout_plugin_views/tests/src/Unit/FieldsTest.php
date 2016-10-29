<?php
/**
 * @file
 * Contains \Drupal\Tests\layout_plugin_views\Unit\FieldsTest.
 */

namespace Drupal\Tests\layout_plugin_views\Unit;

use Drupal\Core\Form\FormState;
use Drupal\Core\Render\RendererInterface;
use Drupal\Core\StringTranslation\TranslatableMarkup;
use Drupal\Core\StringTranslation\TranslationManager;
use Drupal\layout_plugin\Plugin\Layout\LayoutInterface;
use Drupal\layout_plugin\Plugin\Layout\LayoutPluginManager;
use Drupal\layout_plugin_views\Plugin\views\row\Fields;
use Drupal\views\Plugin\views\display\DisplayPluginBase;
use Drupal\views\Plugin\views\field\Field;
use Drupal\views\ResultRow;
use Drupal\views\ViewExecutable;
use Symfony\Component\DependencyInjection\IntrospectableContainerInterface;

/**
 * @coversDefaultClass \Drupal\layout_plugin_views\Plugin\views\row\Fields
 * @group Panels
 */
class FieldsTest extends \PHPUnit_Framework_TestCase {
  /** @var \PHPUnit_Framework_MockObject_MockObject */
  private $container;

  /** @var \Drupal\layout_plugin_views\Plugin\views\row\Fields $sut */
  protected $sut;

  protected function setUp() {
    $this->container = $this->getMockForAbstractClass(IntrospectableContainerInterface::class);
    $this->container->method('get')->willReturnCallback([
      $this,
      'containerGetCallback'
    ]);
    \Drupal::setContainer($this->container);

    $this->initializeSubjectUnderTest([], TRUE);
  }

  /**
   * @test
   */
  public function assertLayoutSelectionType() {
    $form = $this->buildOptionsFrom();

    $this->assertEquals('select', $form['layout']['#type']);
  }

  /**
   * @test
   */
  public function assertLayoutSelectionTitleIsSet() {
    $form = $this->buildOptionsFrom();

    $this->assertNotEmpty($form['layout']['#title']);
    $this->assertEquals(TranslatableMarkup::class, get_class($form['layout']['#title']));
  }

  /**
   * @test
   */
  public function assertLayoutSelectionOptions() {
    $form = $this->buildOptionsFrom();

    $this->assertEquals($this->availableLayoutOptions(), $form['layout']['#options']);
  }

  /**
   * @test
   */
  public function assertLayoutSelectionDefaultValue() {
    $form = $this->buildOptionsFrom();

    $this->assertEquals('onecol', $form['layout']['#default_value']);
  }

  /**
   * @test
   */
  public function assertDefaultRegionSelectionType() {
    $form = $this->buildOptionsFrom();

    $this->assertEquals('select', $form['default_region']['#type']);
  }

  /**
   * @test
   */
  public function assertDefaultRegionSelectionTitleIsSet() {
    $form = $this->buildOptionsFrom();

    $this->assertNotEmpty($form['default_region']['#title']);
    $this->assertEquals(TranslatableMarkup::class, get_class($form['default_region']['#title']));
  }

  /**
   * @test
   */
  public function assertDefaultRegionSelectionDescriptionIsSet() {
    $form = $this->buildOptionsFrom();

    $this->assertNotEmpty($form['default_region']['#description']);
    $this->assertEquals(TranslatableMarkup::class, get_class($form['default_region']['#description']));
  }

  /**
   * @test
   * @todo default value is temporarily an empty string. Make this something sensible.
   */
  public function assertDefaultRegionSelectionDefaultValue() {
    $form = $this->buildOptionsFrom();

    $this->assertEquals('', $form['default_region']['#default_value']);
  }

  /**
   * @test
   */
  public function defaultRegionSelectionOnlyContainsRegionsForTheCurrentLayout() {
    $form = $this->buildOptionsFrom();
    $this->assertEquals($this->availableRegions(), $form['default_region']['#options']);
  }

  /**
   * @test
   */
  public function assertRegionAssignmentFieldset() {
    $form = $this->buildOptionsFrom();

    $this->assertEquals('fieldset', $form['assigned_regions']['#type']);
    $this->assertNotEmpty($form['assigned_regions']['#title']);
    $this->assertEquals(TranslatableMarkup::class, get_class($form['assigned_regions']['#title']));
    $this->assertNotEmpty($form['assigned_regions']['#description']);
    $this->assertEquals(TranslatableMarkup::class, get_class($form['assigned_regions']['#description']));
  }

  /**
   * @test
   */
  public function assertRegionAssignmentFields() {
    $form = $this->buildOptionsFrom();

    foreach ($this->fieldLabels() as $field_name => $field_label) {
      $this->assertEquals('select', $form['assigned_regions'][$field_name]['#type']);
      $this->assertNotEmpty($form['assigned_regions'][$field_name]['#empty_option']);
      $this->assertEquals($this->availableRegions(), $form['assigned_regions'][$field_name]['#options']);
      $this->assertEquals($field_label, $form['assigned_regions'][$field_name]['#title']);
      $this->assertEquals('', $form['assigned_regions'][$field_name]['#default_value']);
    }
  }

  /**
   * @test
   */
  public function emptyRowIsNotRendered() {
    $this->initializeSubjectUnderTest([], TRUE, FALSE);
    $render = $this->sut->render(new ResultRow([]));
    $this->assertEquals([], $render);
  }

  /**
   * @test
   */
  public function fieldIsRenderedInTheDefaultRegionWhenNoOtherRegionIsSpecified() {
    $expected = [
      '' => [
        '#markup' => 'render result',
      ]
    ];

    $this->assertEquals($expected, $this->sut->render(new ResultRow([])));
  }

  /**
   * @test
   */
  public function fieldIsRenderedInTheConfiguredRegion() {
    $this->initializeSubjectUnderTest([
      'assigned_regions' => [
        'somefield' => 'left',
        'some_other_field' => 'right',
      ],
    ]);

    $result = $this->sut->render(new ResultRow([]));
    $this->assertEquals(1, count($result['left']));
    $this->assertFalse(isset($result['middle']));
    $this->assertEquals(1, count($result['right']));
  }

  /**
   * @test
   */
  public function fieldIsRenderedInDefaultRegionIfSelectedRegionDoesNotExist() {
    $this->initializeSubjectUnderTest([
      'assigned_regions' => [
        'somefield' => 'left',
        'some_other_field' => 'this_region_does_not_exist',
      ],
    ]);

    $result = $this->sut->render(new ResultRow([]));
    $this->assertRenderedRegions(TRUE, TRUE, FALSE, $result);
  }

  /**
   * @test
   */
  public function excludedFieldIsNotRendered() {
    $this->initializeSubjectUnderTest([
      'assigned_regions' => [
        'somefield' => 'left',
        'some_other_field' => 'left',
      ],
    ]);
    $this->addFieldToMockedView('excluded_field', $this->getMockedView(), TRUE);
    $result = $this->sut->render(new ResultRow([]));
    $this->assertRenderedRegions(TRUE, FALSE, FALSE, $result);
  }

  /**
   * @return array
   */
  protected function buildOptionsFrom() {
    $form_state = new FormState();
    $form = [];

    $this->sut->buildOptionsForm($form, $form_state);
    return $form;
  }

  /**
   * @return array
   */
  protected function availableLayoutOptions() {
    return [
      'Group' => [
        'onecol' => 'One column',
        'twocol' => 'Two column',
      ],
    ];
  }

  /**
   * Callback for the get method of the mocked container. Creates and returns a
   * mock for every relevant service.
   *
   * @param string $argument
   *
   * @return \PHPUnit_Framework_MockObject_MockObject
   */
  public function containerGetCallback($argument) {
    switch ($argument) {
      case 'plugin.manager.layout_plugin':
        return $this->createLayoutPluginManagerMock();

      case 'string_translation':
        return $this->getMockBuilder(TranslationManager::class)
          ->disableOriginalConstructor()
          ->setMethods(NULL)
          ->getMock();

      case 'renderer':
        $mock = $this->getMockForAbstractClass(RendererInterface::class);
        $mock->method('executeInRenderContext')->willReturnCallback([
          $this,
          'rendererCallback'
        ]);
        return $mock;

      default:
        return NULL;
    }
  }

  public function rendererCallback() {
    foreach ($this->sut->view->field as $field) {
      if (empty($field->options['exclude'])) {
        return 'render result';
      }
    }

    return '';
  }

  protected function initializeSubjectUnderTest($options = [], $reset_view = FALSE, $add_fields = TRUE) {
    $this->sut = Fields::create($this->container, [], '', []);

    $display_handler = $this->getMockBuilder(DisplayPluginBase::class)
      ->disableOriginalConstructor()
      ->getMock();
    $display_handler->method('getFieldLabels')
      ->willReturn($this->fieldLabels());

    $this->sut->init($this->getMockedView($reset_view, $add_fields), $display_handler, $options);
  }

  /**
   * @return \PHPUnit_Framework_MockObject_MockObject
   */
  protected function createLayoutPluginManagerMock() {
    $layoutMock = $this->getMockForAbstractClass(LayoutInterface::class);
    $layoutMock->method('build')->willReturnArgument(0);
    $mock = $this->getMockBuilder(LayoutPluginManager::class)
      ->disableOriginalConstructor()
      ->getMock();
    $mock->method('getLayoutOptions')
      ->willReturn($this->availableLayoutOptions());
    $mock->method('createInstance')->willReturn($layoutMock);
    $mock->method('getDefinition')
      ->willReturn($this->createLayoutDefinition());
    $mock->method('getDefinitions')->willReturn(['something that is not empty']);
    $mock->method('hasDefinition')->willReturn(TRUE);

    return $mock;
  }

  /**
   * @return array
   */
  protected function createLayoutDefinition() {
    return [
      'region_names' => [
        'left' => 'Left',
        'middle' => 'Middle',
        'right' => 'Right',
      ],
      'id' => 'onecol',
    ];
  }

  /**
   * returns a static mocked view.
   *
   * @param bool $reset
   *   Set this to true if the view should be reset.
   *
   * @param bool $add_fields
   *   Set this to false if no fields should be added.
   *
   * @return \PHPUnit_Framework_MockObject_MockObject
   */
  protected function getMockedView($reset = FALSE, $add_fields = TRUE) {
    static $view;

    if (!$view || $reset) {
      $view = $this->getMockBuilder(ViewExecutable::class)
        ->disableOriginalConstructor()
        ->getMock();

      $view->field = [];

      if ($add_fields) {
        foreach (['somefield', 'some_other_field'] as $field_name) {
          $this->addFieldToMockedView($field_name, $view);
        }
      }
    }

    return $view;
  }

  /**
   * @return array
   */
  protected function availableRegions() {
    $expected = [
      'left' => 'Left',
      'middle' => 'Middle',
      'right' => 'Right',
    ];
    return $expected;
  }

  /**
   * @return array
   */
  protected function fieldLabels() {
    return [
      'somefield' => 'Some field',
      'some_other_field' => 'Some other field'
    ];
  }

  /**
   * @param $field_name
   * @param $view
   * @param bool $exclude
   *  Set this to true if the field should have its exclude option set.
   */
  protected function addFieldToMockedView($field_name, $view, $exclude = FALSE) {
    $field = $this->getMockBuilder(Field::class)
      ->disableOriginalConstructor()
      ->getMock();
    $field->method('getItems')
      ->willReturn([['rendered' => ['#markup' => $field_name]]]);

    if ($exclude) {
      $field->options['exclude'] = $exclude;
    }

    $view->field[$field_name] = $field;
  }

  /**
   * @param $result
   */
  protected function assertRenderedRegions($left, $default, $right, $result) {
    $this->assertEquals($left, isset($result['left']));
    $this->assertEquals($default, isset($result['']));
    $this->assertEquals($right, isset($result['right']));
  }
}
