<?php
/**
 * @file
 * Contains \Drupal\views_templates\Plugin\ViewsBuilderPluginInterface.
 */


namespace Drupal\views_templates\Plugin;


use Drupal\Component\Plugin\PluginInspectionInterface;
use Drupal\Core\Form\FormStateInterface;

/**
 * Creates a common interface for Views Builder classes.
 */
interface ViewsBuilderPluginInterface extends PluginInspectionInterface {

  /**
   * Returns base table id.
   *
   * @return string
   */
  public function getBaseTable();

  /**
   * Get template description.
   *
   * @return string
   */
  public function getDescription();


  /**
   * Get template admin label.
   *
   * @return string
   */
  public function getAdminLabel();

  /**
   * Get a value from the plugin definition.
   *
   * @param $key
   *
   * @return mixed
   */
  public function getDefinitionValue($key);

  /**
   * Create a View. Don't save it.
   *
   * @param null $options
   *
   * @return \Drupal\views\ViewEntityInterface
   */
  public function createView($options = NULL);

  /**
   * Return form elements of extra configuration when adding View from template.
   *
   * @param $form
   * @param \Drupal\Core\Form\FormStateInterface $form_state
   *
   * @return mixed
   */
  public function buildConfigurationForm($form, FormStateInterface $form_state);

  /**
   * Determine if a template exists.
   *
   * @return boolean
   */
  public function templateExists();

}
