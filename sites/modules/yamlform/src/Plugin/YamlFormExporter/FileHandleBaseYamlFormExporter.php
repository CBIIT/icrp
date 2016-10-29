<?php

namespace Drupal\yamlform\Plugin\YamlFormExporter;

use Drupal\yamlform\YamlFormExporterBase;

/**
 * Defines abstract file handle exporter.
 */
abstract class FileHandleBaseYamlFormExporter extends YamlFormExporterBase {

  /**
   * A file handler resource.
   *
   * @var resource
   */
  protected $fileHandle;

  /**
   * {@inheritdoc}
   */
  public function createFile() {
    $this->fileHandle = fopen($this->getExportFilePath(), 'w');
  }

  /**
   * {@inheritdoc}
   */
  public function openFile() {
    $this->fileHandle = fopen($this->getExportFilePath(), 'a');
  }

  /**
   * {@inheritdoc}
   */
  public function closeFile() {
    fclose($this->fileHandle);
  }

}
