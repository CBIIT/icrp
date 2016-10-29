<?php

namespace Drupal\yamlform;

use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Plugin\PluginBase;
use Psr\Log\LoggerInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * Provides a base class for a results exporter.
 *
 * @see \Drupal\yamlform\YamlFormExporterInterface
 * @see \Drupal\yamlform\YamlFormExporterManager
 * @see \Drupal\yamlform\YamlFormExporterManagerInterface
 * @see plugin_api
 */
abstract class YamlFormExporterBase extends PluginBase implements YamlFormExporterInterface {

  /**
   * {@inheritdoc}
   */
  public function label() {
    return $this->pluginDefinition['label'];
  }

  /**
   * {@inheritdoc}
   */
  public function description() {
    return $this->pluginDefinition['description'];
  }

  /**
   * {@inheritdoc}
   */
  public function getStatus() {
    return TRUE;
  }

  /**
   * A logger instance.
   *
   * @var \Psr\Log\LoggerInterface
   */
  protected $logger;

  /**
   * {@inheritdoc}
   */
  public function __construct(array $configuration, $plugin_id, $plugin_definition, LoggerInterface $logger) {
    parent::__construct($configuration, $plugin_id, $plugin_definition);

    $this->setConfiguration($configuration);
    $this->logger = $logger;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container, array $configuration, $plugin_id, $plugin_definition) {
    return new static(
      $configuration,
      $plugin_id,
      $plugin_definition,
      $container->get('logger.factory')->get('yamlform')
    );
  }

  /**
   * {@inheritdoc}
   */
  public function getConfiguration() {
    return $this->configuration;
  }

  /**
   * {@inheritdoc}
   */
  public function setConfiguration(array $configuration) {
    $this->configuration = $configuration + $this->defaultConfiguration();
    return $this;
  }

  /**
   * {@inheritdoc}
   */
  public function defaultConfiguration() {
    return [
      'yamlform' => NULL,
      'source_entity' => NULL,
    ];
  }

  /**
   * {@inheritdoc}
   */
  public function calculateDependencies() {
    return [];
  }

  /**
   * Get the form whose submissions are being exported.
   *
   * @return \Drupal\yamlform\YamlFormInterface
   *   A form.
   */
  protected function getYamlForm() {
    return $this->configuration['yamlform'];
  }

  /**
   * Get the form source entity whose submissions are being exported.
   *
   * @return \Drupal\Core\Entity\EntityInterface
   *   A form's source entity.
   */
  protected function getSourceEntity() {
    return $this->configuration['source_entity'];
  }

  /**
   * {@inheritdoc}
   */
  public function buildConfigurationForm(array $form, FormStateInterface $form_state) {
    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function validateConfigurationForm(array &$form, FormStateInterface $form_state) {}

  /**
   * {@inheritdoc}
   */
  public function submitConfigurationForm(array &$form, FormStateInterface $form_state) {}

  /**
   * {@inheritdoc}
   */
  public function createFile() {}

  /**
   * {@inheritdoc}
   */
  public function openFile() {}

  /**
   * {@inheritdoc}
   */
  public function closeFile() {}

  /**
   * {@inheritdoc}
   */
  public function writeHeader(array $header) {}

  /**
   * {@inheritdoc}
   */
  public function writeRecord(array $record) {}

  /**
   * {@inheritdoc}
   */
  public function writeFooter() {}

  /**
   * {@inheritdoc}
   */
  public function getFileTempDirectory() {
    return file_directory_temp();
  }

  /**
   * {@inheritdoc}
   */
  public function getFileExtension() {
    return 'txt';
  }

  /**
   * {@inheritdoc}
   */
  public function getBaseFileName() {
    $yamlform = $this->getYamlForm();
    $source_entity = $this->getSourceEntity();
    if ($source_entity) {
      return $yamlform->id() . '.' . $source_entity->getEntityTypeId() . '.' . $source_entity->id();
    }
    else {
      return $yamlform->id();
    }
  }

  /**
   * {@inheritdoc}
   */
  public function getExportFileName() {
    return $this->getBaseFileName() . '.' . $this->getFileExtension();
  }

  /**
   * {@inheritdoc}
   */
  public function getExportFilePath() {
    return $this->getFileTempDirectory() . '/' . $this->getExportFileName();
  }

}
