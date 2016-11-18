<?php
/**
 * @file
 * Contains \Drupal\views_templates\ViewsTemplateLoader.
 */

namespace Drupal\views_templates;

use Drupal\Component\Serialization\Yaml;
use Drupal\views_templates\Plugin\ViewsDuplicateBuilderPluginInterface;
use Symfony\Component\HttpFoundation\File\Exception\FileNotFoundException;


/**
 * Service class to load templates from the file system.
 *
 *
 */
class ViewsTemplateLoader implements ViewsTemplateLoaderInterface {

  /**
   * {@inheritdoc}
   */
  public function load(ViewsDuplicateBuilderPluginInterface $builder) {
    $templates = &drupal_static(__FUNCTION__, array());

    $template_id = $builder->getViewTemplateId();
    if (!isset($templates[$template_id])) {
      $dir = drupal_get_path('module', $builder->getDefinitionValue('provider')) . '/views_templates';
      if (is_dir($dir)) {

        $file_path = $dir . '/' . $builder->getViewTemplateId() . '.yml';
        if (is_file($file_path)) {
          $templates[$template_id] = Yaml::decode(file_get_contents($file_path));
        }
        else {
          throw new FileNotFoundException($file_path);
        }
      }
    }
    return $templates[$template_id];
  }

}
