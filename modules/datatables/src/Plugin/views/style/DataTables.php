<?php

namespace Drupal\datatables\Plugin\views\style;

use Drupal\Component\Utility\Html;
use Drupal\Core\Form\FormStateInterface;
use Drupal\views\Plugin\views\style\Table;

/**
 * Style plugin to render a table as a FooTable.
 *
 * @ingroup views_style_plugins
 *
 * @ViewsStyle(
 *   id = "datatables",
 *   title = @Translation("DataTables"),
 *   help = @Translation("Render a table as a DataTable."),
 *   theme = "views_view_datatables",
 *   display_types = { "normal" }
 * )
 */
class DataTables extends Table {

  /**
   * {@inheritdoc}
   */
  protected $usesFields = TRUE;

  /**
   * {@inheritdoc}
   */
  protected $usesRowPlugin = FALSE;

  /**
   * {@inheritdoc}
   */
  protected $usesRowClass = TRUE;

  /**
   * {@inheritdoc}
   */
  protected function defineOptions() {
    $options = parent::defineOptions();

    unset($options['sticky']);
    unset($options['override']);

    $options['elements'] = [
      'default' => [
        'search_box' => TRUE,
        'table_info' => TRUE,
        'save_state' => FALSE,
      ],
    ];

    $options['layout'] = [
      'default' => [
        'autowidth' => FALSE,
        'themeroller' => FALSE,
        'sdom' => '',
      ],
    ];

    $options['pages'] = [
      'default' => [
        'pagination_style' => 0,
        'length_change' => 0,
        'display_length' => 10,
      ],
    ];

    $options['hidden_columns'] = [
      'default' => [],
    ];

    return $options;
  }

  /**
   * {@inheritdoc}
   */
  public function buildOptionsForm(&$form, FormStateInterface $form_state) {
    parent::buildOptionsForm($form, $form_state);

    unset($form['sticky']);
    unset($form['override']);

    $form['description_markup']['#markup'] = '<div class="description form-item">' . $this->t('DataTables works best if you set the pager to display all items, since DataTabels contains its own pager implementation.<br/><br/>Place fields into columns; you may combine multiple fields into the same column. If you do, the separator in the column specified will be used to separate the fields. Check the sortable box to make that column click sortable, and check the default sort radio to determine which column will be sorted by default, if any. You may control column order and field labels in the fields section.') . '</div>';

    $form['elements'] = [
      '#type' => 'details',
      '#title' => $this->t('Widgets & Elements'),
      '#open' => FALSE,
    ];

    $form['elements']['search_box'] = [
      '#type' => 'checkbox',
      '#title' => $this->t('Enable the search filter box.'),
      '#description' => $this->t('The search filter box allows users to dynamically filter the results in the table.  Disabling this option will hide the search filter box from users.'),
      '#default_value' => $this->options['elements']['search_box'],
    ];

    $form['elements']['table_info'] = [
      '#type' => 'checkbox',
      '#title' => $this->t('Enable the table information display.'),
      '#description' => $this->t('This shows information about the data that is currently visible on the page, including information about filtered data if that action is being performed.'),
      '#default_value' => $this->options['elements']['table_info'],
    ];

    $form['elements']['save_state'] = [
      '#type' => 'checkbox',
      '#title' => $this->t('Save State'),
      '#description' => $this->t("DataTables can use cookies in the end user's web-browser in order to store it's state after each change in drawing. What this means is that if the user were to reload the page, the table should remain exactly as it was (length, filtering, pagination and sorting)"),
      '#default_value' => $this->options['elements']['save_state'],
    ];

    $form['elements']['table_tools'] = [
      '#type' => 'checkbox',
      '#title' => $this->t('Table Tools'),
      '#description' => $this->t('Table Tools is a plugin that adds a powerful button toolbar with copy, save, and print capabilities. See <a href="http://datatables.net/extras/tabletools/">TableTools Help</a> for more information.  Note that if you have custom sDom settings, TableTools can be included by inserting the "T" character.'),
      '#default_value' => $this->options['elements']['table_tools'],
    ];

    $form['layout'] = [
      '#type' => 'details',
      '#title' => $this->t('Layout and Display'),
      '#open' => FALSE,
    ];

    $form['layout']['autowidth'] = [
      '#type' => 'checkbox',
      '#title' => $this->t('Enable auto-width calculation.'),
      '#description' => $this->t('Enable or disable automatic column width calculation. This can be disabled as an optimisation (it takes some time to calculate the widths).'),
      '#default_value' => $this->options['layout']['autowidth'],
    ];

    $form['layout']['themeroller'] = [
      '#type' => 'checkbox',
      '#title' => $this->t('Enable jQuery UI ThemeRoller Support'),
      '#description' => $this->t("Create markup and classes to support jQuery UI's ThemeRoller"),
      '#default_value' => $this->options['layout']['themeroller'],
    ];

    $form['layout']['sdom'] = [
      '#type' => 'textfield',
      '#title' => $this->t('Set sDOM Initialization Parameter'),
      '#description' => $this->t("Use the sDOM parameter to rearrange the interface elements. See the <a href='@sdom_documentation_url'>Datatables sDOM documentation</a> for details on how to use this feature", ['@sdom_documentation_url' => 'http://www.datatables.net/examples/basic_init/dom.html']),
      '#default_value' => $this->options['layout']['sdom'],
    ];

    $form['pages'] = [
      '#type' => 'details',
      '#title' => $this->t('Pagination and Page Length'),
      '#open' => FALSE,
    ];

    $form['pages']['pagination_style'] = [
      '#type' => 'select',
      '#title' => $this->t('Pagination Style'),
      '#description' => $this->t('Selects which pagination style should be used.'),
      '#options' => [
        0 => $this->t('Two-Button (Default)'),
        'full_numbers' => $this->t('Full Numbers'),
        'no_pagination' => $this->t('No Pagination'),
      ],
      '#default_value' => $this->options['pages']['pagination_style'],
    ];

    $form['pages']['length_change'] = [
      '#type' => 'checkbox',
      '#title' => $this->t('Enable Length Change Selection Box'),
      '#description' => $this->t('Enable or page length selection menu'),
      '#default_value' => $this->options['pages']['length_change'],
    ];

    $form['pages']['display_length'] = [
      '#type' => 'number',
      '#title' => $this->t('Default Page Length'),
      '#description' => $this->t('Default number of records to show per page. May be adjusted by users if Length Selection is enabled'),
      '#min' => 1,
      '#default_value' => $this->options['pages']['display_length'],
    ];

    $form['hidden_columns'] = [
      '#type' => 'details',
      '#title' => $this->t('Hidden and Expandable Columns'),
      '#open' => FALSE,
    ];

    foreach ($this->displayHandler->getFieldLabels() as $name => $label) {
      $form['hidden_columns'][$name] = [
        '#type' => 'select',
        '#title' => Html::escape($label),
        '#options' => [
          0 => $this->t('Visible'),
          'hidden' => $this->t('Hidden'),
          'expandable' => $this->t('Hidden and Expandable'),
        ],
        '#default_value' => isset($this->options['hidden_columns'][$name]) ? $this->options['hidden_columns'][$name] : 0,
      ];
    }
  }

}