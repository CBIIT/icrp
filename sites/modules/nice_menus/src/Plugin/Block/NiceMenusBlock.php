<?php

namespace Drupal\nice_menus\Plugin\Block;

use Drupal\Core\Block\BlockBase;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Block\BlockPluginInterface;

/**
 * Provides a Nice menus block.
 *
 * @Block(
 *   id = "nice_menus_block",
 *   admin_label = @Translation("Nice menus"),
 * )
 */
class NiceMenusBlock extends BlockBase implements BlockPluginInterface {

  /**
   * @param array                                $form
   * @param \Drupal\Core\Form\FormStateInterface $form_state
   *
   * @return array
   */
  public function blockForm($form, FormStateInterface $form_state) {
    $form = parent::blockForm($form, $form_state);
    $config = $this->getConfiguration();
    $form['nice_menus_name'] = array(
      '#type'          => 'textfield',
      '#title'         => $this->t('Menu name'),
      '#default_value' => isset($config['nice_menus_name']) ? $config['nice_menus_name'] : '',
    );
    $form['nice_menus_menu'] = array(
      '#type'          => 'select',
      '#title'         => $this->t('Menu parent'),
      '#description'   => $this->t('The menu parent from which to show a Nice menu.'),
      '#default_value' => isset($config['nice_menus_menu']) ? $config['nice_menus_menu'] : 'navigation:0',
      '#options'       => \Drupal::service('menu.parent_form_selector')
        ->getParentSelectOptions(),
    );
    $form['nice_menus_depth'] = array(
      '#type'          => 'select',
      '#title'         => $this->t('Menu depth'),
      '#description'   => $this->t('The depth of the menu, i.e. the number of child levels starting with the parent selected above. Leave set to -1 to display all children and use 0 to display no children.'),
      '#default_value' => isset($config['nice_menus_depth']) ? $config['nice_menus_depth'] : -1,
      '#options'       => array_combine(range(-1, 5), range(-1, 5)),
    );
    $form['nice_menus_type'] = array(
      '#type'          => 'select',
      '#title'         => $this->t('Menu style'),
      '#description'   => $this->t('right: menu items are listed on top of each other and expand to the right') . '<br />' . t('left: menu items are listed on top of each other and expand to the left') . '<br />' . t('down: menu items are listed side by side and expand down'),
      '#default_value' => isset($config['nice_menus_type']) ? $config['nice_menus_type'] : 'right',
      '#options'       => array_combine(array(
        'right',
        'left',
        'down',
      ), array('right', 'left', 'down')),
    );
    $form['nice_menus_respect_expand'] = array(
      '#type'          => 'select',
      '#title'         => $this->t('Respect "Show as expanded" option'),
      '#description'   => $this->t('Menu items have a "Show as expanded" option, which is disabled by default. Since menu items do NOT have this option checked by default, you should choose Yes here once you have configured the menu items that you DO want to expand.'),
      '#options'       => array(
        0 => $this->t('No'),
        1 => $this->t('Yes'),
      ),
      '#default_value' => isset($config['nice_menus_respect_expand']) ? $config['nice_menus_respect_expand'] : 0,
    );
    return $form;
  }

  /**
   * @param array                                $form
   * @param \Drupal\Core\Form\FormStateInterface $form_state
   */
  public function blockSubmit($form, FormStateInterface $form_state) {
    $this->setConfiguration([
      'nice_menus_name'           => $form_state->getValue('nice_menus_name'),
      'nice_menus_menu'           => $form_state->getValue('nice_menus_menu'),
      'nice_menus_depth'          => $form_state->getValue('nice_menus_depth'),
      'nice_menus_type'           => $form_state->getValue('nice_menus_type'),
      'nice_menus_respect_expand' => $form_state->getValue('nice_menus_respect_expand'),
    ]);
  }

  /**
   * // add 'menuparent' class.
   *
   * @param $items
   *
   * @return mixed
   */
  public function _build_sub_menu_menuparent($items) {
    foreach ($items as $k => &$item) {
      if ($item['below']) {
        $item['attributes']->addClass('menuparent');
        $item['below'] = $this->_build_sub_menu_menuparent($item['below']);
      }
    }
    return $items;
  }

  /**
   * add class to nice menus.
   *
   * @param $tree
   * @param $block_config
   *
   * @return mixed
   */
  public function _build_menu_style($tree, $block_config) {
    // add default class.
    $tree['#attributes']['class'][] = 'nice-menu';
    $tree['#attributes']['class'][] = 'nice-menu-' . $block_config['menu_name'];
    $tree['#attributes']['class'][] = 'nice-menu-' . $block_config['nice_menus_type'];

    // add 'menuparent' class.
    $tree['#items'] = $this->_build_sub_menu_menuparent($tree['#items']);
    return $tree;
  }

  /**
   * @return array
   */
  public function build() {
    $block_config = $this->getConfiguration();
    $nice_menus_menu = isset($block_config['nice_menus_menu']) ? $block_config['nice_menus_menu'] : 'admin:';
    list($block_config['menu_name'], $block_config['menu_mlid']) = explode(':', $nice_menus_menu);

    $config = \Drupal::config('nice_menus.settings');

    // attach library.
    $library = [];
    if ($config->get('nice_menus_js')) {
      $library[] = 'nice_menus/superfish';
      $library[] = 'nice_menus/jquery.hoverIntent';
      $library[] = 'nice_menus/nice_menus';
    }

    // load nice menus default css.
    if ($config->get('nice_menus_default_css')) {
      $library[] = 'nice_menus/nice_menus_default';
    }

    // get menu tree.
    $tree = nice_menus_build_tree($block_config);

    // build menu class.
    $tree = $this->_build_menu_style($tree, $block_config);

    return array(
      '#theme'       => 'nice_menus',
      '#attached'    => array(
        'library' => $library,
        'drupalSettings' => array(
          'nice_menus_options' => array(
            'delay' => $config->get('nice_menus_sf_delay'),
            'speed'=> $config->get('nice_menus_sf_speed')
          )
        )
      ),
      '#menu_output' => drupal_render($tree),
    );
  }
}
