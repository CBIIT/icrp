<?php

namespace Drupal\feeds\Exception;

use Drupal\Component\Render\FormattableMarkup;

/**
 * Thrown if the target values are invalid and cannot be recovered.
 */
class TargetValidationException extends \RuntimeException {

  /**
   * The un-formatted message string.
   *
   * @var strin
   */
  protected $messageString;

  /**
   * Message formatting arguments.
   *
   * @var array
   */
  protected $args;

  /**
   * Constructs a TargetValidationException object.
   *
   * @param string $message
   *   The un-formatted message.
   * @param array $args
   *   The formatting arguments.
   */
  public function __construct($message = '', array $args = []) {
    $this->messageString = $message;
    $this->message = new FormattableMarkup($message, $args);
    $this->args = $args;
    $this->code = 0;
  }

  /**
   * Returns the un-formatted message.
   *
   * @return string
   *   The un-formatted message.
   */
  public function getMessageString() {
    return $this->messageString;
  }

  /**
   * Returns the message formatting arguments.
   *
   * @return array
   *   The message formatting arguments.
   */
  public function getMessageArgs() {
    return $this->args;
  }

}
