<?php
/**
 * @file
 * Contains \Drupal\external_entities\ResponseDecoderFactory.
 */

namespace Drupal\external_entities;

use Drupal\Component\Serialization\SerializationInterface;

/**
 * Factory for response decoders.
 */
interface ResponseDecoderFactoryInterface {

  /**
   * Add a decoder.
   *
   * @param \Drupal\Component\Serialization\SerializationInterface $decoder
   *   The decoder.
   */
  public function addDecoder(SerializationInterface $decoder);

  /**
   * Get a decoder for a certain format.
   *
   * @param string $format
   *   The format to get the decoder for.
   *
   * @return \Drupal\Component\Serialization\SerializationInterface|bool
   *   The decoder if it exists, FALSE otherwise.
   */
  public function getDecoder($format);

  /**
   * Checks if a format is supported.
   *
   * @param string $format
   *   The format to check.
   *
   * @return bool
   *   Whether or not the given format is supported.
   */
  public function supportsFormat($format);

  /**
   * Gets the supported formats.
   *
   * @return string[]
   *   An array with the supported formats.
   */
  public function supportedFormats();
}
