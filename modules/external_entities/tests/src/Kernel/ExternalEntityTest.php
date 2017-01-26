<?php

namespace Drupal\Tests\external_entities\Kernel;

use Drupal\KernelTests\KernelTestBase;
use Drupal\external_entities\Entity\ExternalEntity;
use Drupal\external_entities\Entity\ExternalEntityType;
use Drupal\field\Tests\EntityReference\EntityReferenceTestTrait;
use Drupal\Core\Field\FieldStorageDefinitionInterface;
use Drupal\taxonomy\Entity\Term;
use Drupal\taxonomy\Entity\Vocabulary;
use Drupal\Component\Utility\Unicode;
use Drupal\Core\Language\LanguageInterface;

/**
 * Tests the external entity methods.
 *
 * @group external_entities
 */
class ExternalEntityTest extends KernelTestBase {

  use EntityReferenceTestTrait;

  /**
   * {@inheritdoc}
   */
  public static $modules = [
    'system',
    'field',
    'text',
    'taxonomy',
    'external_entities',
  ];

  /**
   * The taxonomy vocabulary to test with.
   *
   * @var \Drupal\taxonomy\VocabularyInterface
   */
  protected $vocabulary;

  /**
   * The first taxonomy term to test with.
   *
   * @var \Drupal\taxonomy\TermInterface
   */
  protected $term1;

  /**
   * The second taxonomy term to test with.
   *
   * @var \Drupal\taxonomy\TermInterface
   */
  protected $term2;

  /**
   * {@inheritdoc}
   */
  protected function setUp() {
    parent::setUp();

    $this->installEntitySchema('taxonomy_term');

    ExternalEntityType::create([
      'type' => 'test',
      'field_mappings' => [
        'id' => 'test_id',
        'title' => 'test_name',
        'field_test_taxonomy_term' => 'test_terms',
      ],
    ])->save();

    $this->vocabulary = Vocabulary::create([
      'name' => $this->randomMachineName(),
      'vid' => Unicode::strtolower($this->randomMachineName()),
      'langcode' => LanguageInterface::LANGCODE_NOT_SPECIFIED,
    ]);
    $this->vocabulary->save();

    $this->term1 = Term::create([
      'name' => $this->randomMachineName(),
      'vid' => $this->vocabulary->id(),
      'langcode' => LanguageInterface::LANGCODE_NOT_SPECIFIED,
    ]);
    $this->term1->save();

    $this->term2 = Term::create([
      'name' => $this->randomMachineName(),
      'vid' => $this->vocabulary->id(),
      'langcode' => LanguageInterface::LANGCODE_NOT_SPECIFIED,
    ]);
    $this->term2->save();

    $this->createEntityReferenceField('external_entity', 'test', 'field_test_taxonomy_term', 'Test content entity reference', 'taxonomy_term', 'default', [], FieldStorageDefinitionInterface::CARDINALITY_UNLIMITED);
  }

  /**
   * Tests the mapping functions.
   */
  public function testMappings() {
    $externalEntity = ExternalEntity::create([
      'type' => 'test',
    ]);
    $object = new \stdClass();
    $object->test_id = $this->randomString();
    $object->test_name = $this->randomString();
    $object->test_terms = [
      $this->term2->id(),
      $this->term2->id(),
    ];

    // Map the object to the entity.
    $externalEntity->mapObject($object);
    // Get back the object.
    $mappedObject = $externalEntity->getMappedObject();

    // The retrieved object and our original object should be the same.
    $this->assertEquals($object, $mappedObject);
  }

}
