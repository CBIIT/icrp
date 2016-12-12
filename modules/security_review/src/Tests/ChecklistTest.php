<?php

/**
 * @file
 * Contains \Drupal\security_review\Tests\ChecklistTest.
 */

namespace Drupal\security_review\Tests;

use Drupal\security_review\Checklist;
use Drupal\simpletest\KernelTestBase;

/**
 * Contains test for Checklist.
 *
 * @group security_review
 */
class ChecklistTest extends KernelTestBase {

  /**
   * Modules to enable.
   *
   * @var array
   */
  public static $modules = ['security_review', 'security_review_test'];

  /**
   * The security_review.checklist service.
   *
   * @var \Drupal\security_review\Checklist
   */
  protected $checklist;

  /**
   * The security checks defined by Security Review and Security Review Test.
   *
   * @var \Drupal\security_review\Check[]
   */
  protected $checks;

  /**
   * The security checks defined by Security Review.
   *
   * @var \Drupal\security_review\Check[]
   */
  protected $realChecks;

  /**
   * The security checks defined by Security Review Test.
   *
   * @var \Drupal\security_review\Check[]
   */
  protected $testChecks;

  /**
   * Array of the IDs of $checks.
   *
   * @var array
   */
  protected $checkIDs;

  /**
   * Sets up the environment, populates the $checks variable.
   */
  protected function setUp() {
    parent::setUp();

    $this->checklist = \Drupal::getContainer()
      ->get('security_review.checklist');
    $this->realChecks = security_review_security_review_checks();
    $this->testChecks = security_review_test_security_review_checks();
    $this->checks = array_merge($this->realChecks, $this->testChecks);

    Checklist::clearCache();
    $this->checkIDs = [];
    foreach ($this->checks as $check) {
      $this->checkIDs[] = $check->id();
    }
  }

  /**
   * Tests Checklist::getChecks().
   *
   * Tests whether getChecks() contains all the checks that
   * security_review_security_review_checks() and
   * security_review_test_security_review_checks() returns.
   */
  public function testChecksProvided() {
    foreach ($this->checklist->getChecks() as $check) {
      $this->assertTrue(in_array($check->id(), $this->checkIDs), $check->getTitle() . ' found.');
    }
  }

  /**
   * Tests whether checks returned by getEnabledChecks() are all enabled.
   */
  public function testEnabledChecks() {
    foreach ($this->checklist->getEnabledChecks() as $check) {
      $this->assertFalse($check->isSkipped(), $check->getTitle() . ' is enabled.');

      // Disable check.
      $check->skip();
    }
    Checklist::clearCache();
    $this->assertEqual(count($this->checklist->getEnabledChecks()), 0, 'Disabled all checks.');
  }

  /**
   * Tests Checklist's Check search functions.
   *
   * Tests the search functions of Checklist:
   *   getCheck().
   *   getCheckById().
   */
  public function testCheckSearch() {
    foreach ($this->checklist->getChecks() as $check) {
      // getCheck().
      $found = $this->checklist->getCheck($check->getMachineNamespace(), $check->getMachineTitle());
      $this->assertNotNull($found, 'Found a check.');
      $this->assertEqual($check->id(), $found->id(), 'Found ' . $check->getTitle() . '.');

      // getCheckById().
      $found = $this->checklist->getCheckById($check->id());
      $this->assertNotNull($found, 'Found a check.');
      $this->assertEqual($check->id(), $found->id(), 'Found ' . $check->getTitle() . '.');
    }
  }

}
