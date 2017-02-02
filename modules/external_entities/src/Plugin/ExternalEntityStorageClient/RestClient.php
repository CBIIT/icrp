<?php

/**
 * @file
 * Contains \Drupal\external_entities\Plugin\ExternalEntityStorageClient\RestClient.
 */

namespace Drupal\external_entities\Plugin\ExternalEntityStorageClient;

use Drupal\external_entities\ExternalEntityStorageClientBase;

/**
 * REST implementation of an external entity storage client.
 *
 * @ExternalEntityStorageClient(
 *   id = "rest_client",
 *   name = "REST"
 * )
 */
class RestClient extends ExternalEntityStorageClientBase {

  /**
   * {@inheritdoc}
   */
  public function delete(\Drupal\external_entities\ExternalEntityInterface $entity) {
    $this->httpClient->delete(
      $this->configuration['endpoint'] . '/' . $entity->externalId(),
      ['headers' => $this->getHttpHeaders()]
    );
  }

  /**
   * {@inheritdoc}
   */
  public function load($id) {
    $response = $this->httpClient->get(
      $this->configuration['endpoint'] . '/' . $id,
      ['headers' => $this->getHttpHeaders()]
    );
    return (object) $this->decoder->getDecoder($this->configuration['format'])->decode($response->getBody());
  }

  /**
   * {@inheritdoc}
   */
  public function save(\Drupal\external_entities\ExternalEntityInterface $entity) {
    if ($entity->externalId()) {
      $response = $this->httpClient->put(
        $this->configuration['endpoint'] . '/' . $entity->externalId(),
        [
          'form_params' => (array) $entity->getMappedObject(),
          'headers' => $this->getHttpHeaders()
        ]
      );
      $result = SAVED_UPDATED;
    }
    else {
      $response = $this->httpClient->post(
        $this->configuration['endpoint'],
        [
          'form_params' => (array) $entity->getMappedObject(),
          'headers' => $this->getHttpHeaders()
        ]
      );
      $result = SAVED_NEW;
    }

    // @todo: is it standard REST to return the new entity?
    $object = (object) $this->decoder->getDecoder($this->configuration['format'])->decode($response->getBody());
    $entity->mapObject($object);
    return $result;
  }

  /**
   * {@inheritdoc}
   */
  public function query(array $parameters) {
    $response = $this->httpClient->get(
      $this->configuration['endpoint'],
      [
        'query' => $parameters,
        'headers' => $this->getHttpHeaders()
      ]
    );
    $results = $this->decoder->getDecoder($this->configuration['format'])->decode($response->getBody());
    foreach ($results as &$result) {
      $result = ((object) $result);
    }
    return $results;
  }

}
