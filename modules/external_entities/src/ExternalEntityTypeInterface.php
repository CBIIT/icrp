<?php

/**
 * @file
 * Contains \Drupal\external_entities\ExternalEntityTypeInterface.
 */

namespace Drupal\external_entities;

use Drupal\Core\Config\Entity\ConfigEntityInterface;

/**
 * Provides an interface defining a node type entity.
 */
interface ExternalEntityTypeInterface extends ConfigEntityInterface {

  /**
   * Gets the description.
   *
   * @return string
   *   The description of this external entity type.
   */
  public function getDescription();

  /**
   * Returns if entities of this external entity are read only.
   *
   * @return bool
   *   TRUE if the entities are read only, FALSE otherwise.
   */
  public function isReadOnly();

  /**
   * Returns the field mappings of this external entity type.
   *
   * @return array
   *   An array associative array:
   *     - key: The source property.
   *     - value: The destination field.
   */
  public function getFieldMappings();

  /**
   * Returns the field mapping for the given field of this external entity type.
   *
   * @return string|boolean
   *   The name of the property this field is mapped to. FALSE if the mapping
   *   doesn't exist.
   */
  public function getFieldMapping($field_name);

  /**
   * Returns the endpoint of this external entity type.
   *
   * @return string
   *   The endpoint for this external entity type.
   */
  public function getEndpoint();

  /**
   * Returns the id of the external entity storage client.
   *
   * @return string
   *   The external entity storage client id.
   */
  public function getClient();

  /**
   * Returns the format in which the storage client should make its requests.
   *
   * @return string
   *   The format in which the storage client should make its requests.
   */
  public function getFormat();

  /**
   * Returns the pager settings.
   *
   * @return array
   *   An array with following keys:
   *     - 'default_limit': Number of items per page.
   *     - 'page_parameter': The name of the page parameter.
   *     - 'page_size_parameter': The name of the page size parameter.
   *     - 'page_parameter_type': Either 'pagenum' or 'startitem'. Use 'pagenum'
   *       when the pager uses page numbers to determine the item to start at,
   *       use 'startitem' when the pager uses the item number to start at.
   *     - 'page_size_parameter_type': Either 'pagesize' or 'enditem'. Use
   *       'pagesize' when the pager uses this parameter to determine the amount
   *       of items on each page, use 'enditem' when the pager uses this
   *       parameter to determine the number of the last item on the page.
   */
  public function getPagerSettings();

  /**
   * Returns the API key settings.
   *
   * @return array
   *   An array with following keys:
   *     - 'header_name': The HTTP header name for the API key.
   *     - 'key': The value for the API key.
   */
  public function getApiKeySettings();

  /**
   * Returns the parameters of this external entity type.
   *
   * @return array
   *   An associative array with following keys:
   *     - list: An associative array with following keys:
   *       - key: The parameter name.
   *       - value: The parameter value.
   *     - single: An associative array with following keys:
   *       - key: The parameter name.
   *       - value: The parameter value.
   */
  public function getParameters();

  /**
   * Get the parameters for a certain type.
   *
   * @param string $type
   *   One of 'single' or 'list'.
   *
   * @return array
   *   An associative array with following keys:
   *     - key: The parameter name.
   *     - value: The parameter value.
   */
  public function getTypeParameters($type);

}
