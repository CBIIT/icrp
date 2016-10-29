<?php

namespace Drupal\yamlform;

use Drupal\Component\Plugin\ConfigurablePluginInterface;
use Drupal\Component\Plugin\PluginInspectionInterface;
use Drupal\Core\Plugin\ContainerFactoryPluginInterface;
use Drupal\Core\Plugin\PluginFormInterface;

/**
 * Defines the interface for results exporters.
 *
 * @see \Drupal\yamlform\Annotation\YamlFormExporter
 * @see \Drupal\yamlform\YamlFormExporterBase
 * @see \Drupal\yamlform\YamlFormExporterManager
 * @see \Drupal\yamlform\YamlFormExporterManagerInterface
 * @see plugin_api
 */
interface YamlFormExporterInterface extends PluginInspectionInterface, ConfigurablePluginInterface, PluginFormInterface, ContainerFactoryPluginInterface {

  /**
   * Returns the results exporter label.
   *
   * @return string
   *   The results exporter label.
   */
  public function label();

  /**
   * Returns the results exporter description.
   *
   * @return string
   *   The results exporter description.
   */
  public function description();

  /**
   * Returns the results exporter status.
   *
   * @return bool
   *   TRUE is the results exporter is available.
   */
  public function getStatus();

  /**
   * Create export file.
   */
  public function createFile();

  /**
   * Open export file.
   */
  public function openFile();

  /**
   * Close export file.
   */
  public function closeFile();

  /**
   * Write export file header.
   *
   * @param array $header
   *   A array of headers.
   */
  public function writeHeader(array $header);

  /**
   * Write export file record.
   *
   * @param array $record
   *   A array of record values.
   */
  public function writeRecord(array $record);

  /**
   * Write export file footer.
   */
  public function writeFooter();

  /**
   * Get export file temp directory.
   *
   * @return string
   *   The export file temp directory..
   */
  public function getFileTempDirectory();

  /**
   * Get export file extension.
   *
   * @return string
   *   A file extension.
   */
  public function getFileExtension();

  /**
   * Get export base file name without an extension.
   *
   * @return string
   *   A base file name.
   */
  public function getBaseFileName();

  /**
   * Get export file name.
   *
   * @return string
   *   A file name.
   */
  public function getExportFileName();

  /**
   * Get export file path.
   *
   * @return string
   *   A file path.
   */
  public function getExportFilePath();

}
