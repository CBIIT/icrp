<?php

namespace Drupal\yamlform\Plugin\YamlFormExporter;

use Drupal\Core\Form\FormStateInterface;

/**
 * Defines a delimited text exporter.
 *
 * @YamlFormExporter(
 *   id = "delimited",
 *   label = @Translation("Delimited text"),
 *   description = @Translation("Exports results as delimited text file."),
 * )
 */
class DelimitedYamlFormExporter extends FileHandleBaseYamlFormExporter {

  /**
   * {@inheritdoc}
   */
  public function defaultConfiguration() {
    return parent::defaultConfiguration() + [
      'delimiter' => ',',
    ];
  }

  /**
   * {@inheritdoc}
   */
  public function setConfiguration(array $configuration) {
    parent::setConfiguration($configuration);
    if ($this->configuration['delimiter'] == '\t') {
      $this->configuration['delimiter'] = "\t";
    }
    return $this;
  }

  /**
   * {@inheritdoc}
   */
  public function buildConfigurationForm(array $form, FormStateInterface $form_state) {
    $form['warning'] = [
      '#type' => 'yamlform_message',
      '#message_type' => 'warning',
      '#message_message' => $this->t('<strong>Warning:</strong> Opening delimited text files with spreadsheet applications may expose you to <a href=":href">formula injection</a> or other security vulnerabilities. When the submissions contain data from untrusted users and the downloaded file will be used with spreadsheets, use Microsoft Excel format.', [':href' => 'https://www.google.com/search?q=spreadsheet+formula+injection']),
    ];
    $form['delimiter'] = [
      '#type' => 'select',
      '#title' => $this->t('Delimiter text format'),
      '#description' => $this->t('This is the delimiter used in the CSV/TSV file when downloading form results. Using tabs in the export is the most reliable method for preserving non-latin characters. You may want to change this to another character depending on the program with which you anticipate importing results.'),
      '#required' => TRUE,
      '#options' => [
        ','  => $this->t('Comma (,)'),
        '\t' => $this->t('Tab (\t)'),
        ';'  => $this->t('Semicolon (;)'),
        ':'  => $this->t('Colon (:)'),
        '|'  => $this->t('Pipe (|)'),
        '.'  => $this->t('Period (.)'),
        ' '  => $this->t('Space ( )'),
      ],
      '#default_value' => $this->configuration['delimiter'],
    ];
    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function getFileExtension() {
    switch ($this->configuration['delimiter']) {
      case "\t":
        return 'tsv';

      default:
        return 'csv';
    }
  }

  /**
   * {@inheritdoc}
   */
  public function writeHeader(array $header) {
    fputcsv($this->fileHandle, $header, $this->configuration['delimiter']);
  }

  /**
   * {@inheritdoc}
   */
  public function writeRecord(array $record) {
    fputcsv($this->fileHandle, $record, $this->configuration['delimiter']);
  }

}
