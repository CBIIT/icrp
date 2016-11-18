<?php
/**
 * @file
 * Contains \Drupal\views_templates\Controller\ViewsBuilderController.
 */


namespace Drupal\views_templates\Controller;


use Drupal\Component\Plugin\PluginManagerInterface;
use Drupal\Core\Controller\ControllerBase;
use Drupal\Core\Url;
use Symfony\Component\DependencyInjection\ContainerInterface;

class ViewsBuilderController extends ControllerBase {

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

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container) {
    return new static(
      $container->get('plugin.manager.views_templates.builder')
    );
  }

  /**
   * Create template list table.
   *
   * @return array
   *  Render array of template list.
   */
  public function templateList() {
    $table = array(
      '#type' => 'table',
      '#header' => array(
        $this->t('Name'),
        $this->t('Description'),
        $this->t('Add'),
      ),
      '#empty' => $this->t('There are no available Views Templates'),
    );

    /** @var \Drupal\views_templates\Plugin\ViewsBuilderPluginInterface $definition */
    foreach ($this->builder_manager->getDefinitions() as $definition) {

      /** @var \Drupal\views_templates\Plugin\ViewsBuilderPluginInterface $builder */
      $builder = $this->builder_manager->createInstance($definition['id']);
      if ($builder->templateExists()) {
        $plugin_id = $builder->getPluginId();
        $row = [
          'name' => ['#plain_text' => $builder->getAdminLabel()],
          'description' => ['#plain_text' => $builder->getDescription()],
          'add' => [
            '#type' => 'link',
            '#title' => t('Add'),
            '#url' => Url::fromRoute('views_templates.create_from_template',
              [
                'view_template' => $plugin_id,
              ]
            ),
          ],
        ];
        $table[$plugin_id] = $row;
      }
    }

    return $table;
  }
}
