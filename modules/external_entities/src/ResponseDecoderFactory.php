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
class ResponseDecoderFactory implements ResponseDecoderFactoryInterface {
  /**
   * The decoders.
   *
   * @var \Drupal\Component\Serialization\SerializationInterface[]
   */
  protected $decoders = [];

  /**
   * {@inheritdoc}
   */
  public function addDecoder(SerializationInterface $decoder) {
    $this->decoders[$decoder->getFileExtension()] = $decoder;
  }

  /**
   * {@inheritdoc}
   */
  public function getDecoder($format) {
    return isset($this->decoders[$format]) ? $this->decoders[$format] : FALSE;
  }

  /**
   * {@inheritdoc}
   */
  public function supportsFormat($format) {
    return isset($this->decoders[$format]);
  }

  /**
   * {@inheritdoc}
   */
  public function supportedFormats() {
    return array_keys($this->decoders);
  }
}
