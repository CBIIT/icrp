<?php
/**
 * @file
 * Contains \Drupal\views_templates\ViewTemplateForm.
 */

namespace Drupal\views_templates;

use Drupal\Component\Plugin\PluginManagerInterface;
use Drupal\Core\Form\FormBase;
use Drupal\Core\Form\FormStateInterface;
use Drupal\views_templates\Plugin\ViewsBuilderPluginInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * Form controller for the view template entity add forms.
 */
class ViewTemplateForm extends FormBase {

  /**
   * @var \Drupal\Component\Plugin\PluginManagerInterface
   */
  protected $builder_manager;

  /**
   * Constructs a new \Drupal\views_templates\Controller\ViewsBuilderController
   * object.
   *
   * @param \Drupal\Component\Plugin\PluginManagerInterface
   *   The Views Builder Plugin Interface.
   */
  public function __construct(PluginManagerInterface $builder_manager) {
    $this->builder_manager = $builder_manager;
  }

  public static function create(ContainerInterface $container) {
    return new static(
      $container->get('plugin.manager.views_templates.builder')
    );
  }

  /**
   * {@inheritdoc}
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {
    $builder = $this->createBuilder($form_state->getValue('builder_id'));
    $values = $form_state->cleanValues()->getValues();
    $view = $builder->createView($values);
    $view->save();

    // Redirect the user to the view admin form.
    $form_state->setRedirectUrl($view->toUrl('edit-form'));
  }

  public function buildForm(array $form, FormStateInterface $form_state, $view_template = NULL) {
    $builder = $this->createBuilder($view_template);
    $form['#title'] = $this->t('Duplicate of @label', array('@label' => $builder->getAdminLabel()));

    $form['label'] = array(
      '#type' => 'textfield',
      '#title' => $this->t('View name'),
      '#required' => TRUE,
      '#size' => 32,
      '#maxlength' => 255,
      '#default_value' => $builder->getAdminLabel(),
    );
    $form['id'] = array(
      '#type' => 'machine_name',
      '#maxlength' => 128,
      '#machine_name' => array(
        'exists' => '\Drupal\views\Views::getView',
        'source' => array('label'),
      ),
      '#default_value' => '',
      '#description' => $this->t('A unique machine-readable name for this View. It must only contain lowercase letters, numbers, and underscores.'),
    );

    $form['description'] = [
      '#type' => 'textfield',
      '#title' => $this->t('Description'),
      '#default_value' => $builder->getDescription(),
    ];
    $form['builder_id'] = [
      '#type' => 'value',
      '#value' => $builder->getPluginId(),
    ];

    $form += $builder->buildConfigurationForm($form, $form_state);

    $form['submit'] = [
      '#type' => 'submit',
      '#value' => $this->t('Create View'),
    ];

    return $form;
  }

  public function getFormId() {
    return 'views_templates_add';
  }

  /**
   * @param $plugin_id
   *
   * @return ViewsBuilderPluginInterface;
   */
  public function createBuilder($plugin_id) {
    return $this->builder_manager->createInstance($plugin_id);
  }


}
