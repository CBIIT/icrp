<?php

/**
 * @file
 * Contains \Drupal\faq\Controller\FaqController.
 */

namespace Drupal\faq\Controller;

use Drupal\Component\Render\FormattableMarkup;
use Drupal\Core\Controller\ControllerBase;
use Drupal\Core\Database\Query\Condition;
use Drupal\Core\Url;
use Drupal\taxonomy\Entity\Vocabulary;
use Drupal\node\Entity\Node;
use Drupal\taxonomy\Entity\Term;
use Drupal\faq\FaqHelper;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

/**
 * Controller routines for FAQ routes.
 */
class FaqController extends ControllerBase {

  /**
   * Function to display the faq page.
   *
   * @param int $tid
   *   Default is 0, determines if the questions and answers on the page
   *   will be shown according to a category or non-categorized.
   * @param string $faq_display
   *   Optional parameter to override default question layout setting.
   * @param string $category_display
   *   Optional parameter to override default category layout setting.
   * @return
   *   The page with FAQ questions and answers.
   * @throws NotFoundHttpException
   */
  public function faqPage($tid = 0, $faq_display = '', $category_display = '') {
    $faq_settings = \Drupal::config('faq.settings');

    $output = $output_answers = '';

    $build = array();
    $build['#type'] = 'markup';
    $build['#attached']['library'][] = 'faq/faq-css';

    $build['#title'] = $faq_settings->get('title');

    if (!$this->moduleHandler()->moduleExists('taxonomy')) {
      $tid = 0;
    }

    $faq_display = $faq_settings->get('display');
    $use_categories = $faq_settings->get('use_categories');
    $category_display = $faq_settings->get('category_display');
    // if taxonomy doesn't installed, do not use categories
    if (!$this->moduleHandler()->moduleExists('taxonomy')) {
      $use_categories = FALSE;
    }

    if (($use_categories && $category_display == 'hide_qa') || $faq_display == 'hide_answer') {
      $build['#attached']['library'][] = 'faq/faq-scripts';
      $build['#attached']['drupalSettings']['faqSettings']['hide_qa_accordion'] = $faq_settings->get('hide_qa_accordion');
      $build['#attached']['drupalSettings']['faqSettings']['category_hide_qa_accordion'] = $faq_settings->get('category_hide_qa_accordion');
    }

    // Non-categorized questions and answers.
    if (!$use_categories || ($category_display == 'none' && empty($tid))) {
      if (!empty($tid)) {
        throw new NotFoundHttpException();
      }
      $langcode = \Drupal::languageManager()->getCurrentLanguage()->getId();
      $default_sorting = $faq_settings->get('default_sorting');
      $query = \Drupal::database()->select('node', 'n');
      $weight_alias = $query->leftJoin('faq_weights', 'w', '%alias.nid=n.nid');
      $query->leftJoin('node_field_data', 'd', 'd.nid=n.nid');
      $db_or = new Condition('OR');
      $db_or->condition("$weight_alias.tid", 0)->isNull("$weight_alias.tid");
      $query
        ->fields('n', ['nid'])
        ->condition('n.type', 'faq')
        ->condition('d.langcode', $langcode)
        ->condition('d.status', 1)
        ->condition($db_or)
        ->addTag('node_access');

      $default_weight = 0;
      if ($default_sorting == 'ASC') {
        $default_weight = 1000000;
      }
      // Works, but involves variable concatenation - safe though, since
      // $default_weight is an integer.
      $query->addExpression("COALESCE(w.weight, $default_weight)", 'effective_weight');
      // Doesn't work in Postgres.
      //$query->addExpression('COALESCE(w.weight, CAST(:default_weight as SIGNED))', 'effective_weight', array(':default_weight' => $default_weight));
      $query->orderBy('effective_weight', 'ASC')
        ->orderBy('d.sticky', 'DESC');
      if ($default_sorting == 'ASC') {
        $query->orderBy('d.created', 'ASC');
      }
      else {
        $query->orderBy('d.created', 'DESC');
      }

      // Only need the nid column.
      $nids = $query->execute()->fetchCol();
      $data = Node::loadMultiple($nids);
      foreach ($data as $key => &$node) {
        $node =  ($node->hasTranslation($langcode)) ? $node->getTranslation($langcode) : $node;
      }

      $questions_to_render = array();
      $questions_to_render['#data'] = $data;

      switch ($faq_display) {
        case 'questions_top':
          $questions_to_render['#theme'] = 'faq_questions_top';
          break;

        case 'hide_answer':
          $questions_to_render['#theme'] = 'faq_hide_answer';
          break;

        case 'questions_inline':
          $questions_to_render['#theme'] = 'faq_questions_inline';
          break;

        case 'new_page':
          $questions_to_render['#theme'] = 'faq_new_page';
          break;
      } // End of switch.
      $output = \Drupal::service('renderer')->render($questions_to_render);
    }

    // Categorize questions.
    else {
      $hide_child_terms = $faq_settings->get('hide_child_terms');

      // If we're viewing a specific category/term.
      if (!empty($tid)) {
        if ($term = Term::load($tid)) {
          $title = $faq_settings->get('title');

          $build['#title'] = ($title . ($title ? ' - ' : '') . $this->t($term->getName()));
          
          $this->_displayFaqByCategory($faq_display, $category_display, $term, 0, $output, $output_answers);
          $to_render = array(
            '#theme' => 'faq_page',
            '#content' => new FormattableMarkup($output, []),
            '#answers' => new FormattableMarkup($output_answers, []),
          );
          $build['#markup'] = drupal_render($to_render);
          return $build;
        }
        else {
          throw new NotFoundHttpException();
        }
      }

      $list_style = $faq_settings->get('category_listing');
      $vocabularies = Vocabulary::loadMultiple();
      $vocab_omit = $faq_settings->get('omit_vocabulary');
      $items = array();
      $vocab_items = array();
      foreach ($vocabularies as $vid => $vobj) {
        if (isset($vocab_omit[$vid]) && ($vocab_omit[$vid] !== 0)) {
          continue;
        }

        if ($category_display == "new_page") {
          $vocab_items = $this->_getIndentedFaqTerms($vid, 0);
          $items = array_merge($items, $vocab_items);
        }
        // Not a new page.
        else {
          if ($hide_child_terms && $category_display == 'hide_qa') {
            $tree = \Drupal::entityManager()->getStorage('taxonomy_term')->loadTree($vid, 0, 1, TRUE);
          }
          else {
            $tree = \Drupal::entityManager()->getStorage('taxonomy_term')->loadTree($vid, 0, NULL, TRUE);
          }
          foreach ($tree as $term) {
            switch ($category_display) {
              case 'hide_qa':
              case 'categories_inline':
                if (FaqHelper::taxonomyTermCountNodes($term->id())) {
                  $this->_displayFaqByCategory($faq_display, $category_display, $term, 1, $output, $output_answers);
                }
                break;
            }
          }
        }
      }

      if ($category_display == "new_page") {
        $output = $this->_renderCategoriesToList($items, $list_style);
      }
    }

    $faq_description = $faq_settings->get('description');
    
    $markup = array(
      '#theme' => 'faq_page',
      '#content' => new FormattableMarkup($output, []),
      '#answers' => new FormattableMarkup($output_answers, []),
      '#description' => new FormattableMarkup($faq_description, []),
    );
    $build['#markup'] = drupal_render($markup);

    return $build;
  }

  /**
   * Define the elements for the FAQ Settings page - order tab.
   *
   * @param $category
   *   The category id of the FAQ page to reorder.
   * @return
   *   The form code, before being converted to HTML format.
   */
  public function orderPage($tid = NULL) {

    $faq_settings = \Drupal::config('faq.settings');
    $build = array();

    $build['#attached']['library'][] = 'faq/faq-scripts';
    $build['#attached']['drupalSettings']['faqSettings']['hide_qa_accordion'] = $faq_settings->get('hide_qa_accordion');
    $build['#attached']['drupalSettings']['faqSettings']['category_hide_qa_accordion'] = $faq_settings->get('category_hide_qa_accordion');
    $build['#attached']['library'][] = 'faq/faq-css';

    $build['faq_order'] = $this->formBuilder()->getForm('Drupal\faq\Form\OrderForm');

    return $build;
  }

  /**
   * Renders the form for the FAQ Settings page - General tab.
   *
   * @return
   *   The form code inside the $build array.
   */
  public function generalSettings() {
    $build = array();

    $build['faq_general_settings_form'] = $this->formBuilder()->getForm('Drupal\faq\Form\GeneralForm');

    return $build;
  }

  /**
   * Renders the form for the FAQ Settings page - Questions tab.
   *
   * @return
   *   The form code inside the $build array.
   */
  public function questionsSettings() {
    $faq_settings = \Drupal::config('faq.settings');

    $build = array();

    $build['#attached']['library'][] = 'faq/faq-scripts';
    $build['#attached']['drupalSettings']['faqSettings']['hide_qa_accordion'] = $faq_settings->get('hide_qa_accordion');
    $build['#attached']['drupalSettings']['faqSettings']['category_hide_qa_accordion'] = $faq_settings->get('category_hide_qa_accordion');

    $build['faq_questions_settings_form'] = $this->formBuilder()->getForm('Drupal\faq\Form\QuestionsForm');

    return $build;
  }

  /**
   * Renders the form for the FAQ Settings page - Categories tab.
   *
   * @return
   *   The form code inside the $build array.
   */
  public function categoriesSettings() {
    $faq_settings = \Drupal::config('faq.settings');

    $build = array();

    $build['#attached']['library'][] = 'faq/faq-scripts';
    $build['#attached']['drupalSettings']['faqSettings']['hide_qa_accordion'] = $faq_settings->get('hide_qa_accordion');
    $build['#attached']['drupalSettings']['faqSettings']['category_hide_qa_accordion'] = $faq_settings->get('category_hide_qa_accordion');

    if (!$this->moduleHandler()->moduleExists('taxonomy')) {
      drupal_set_message(t('Categorization of questions will not work without the "taxonomy" module being enabled.'), 'error');
    }

    $build['faq_categories_settings_form'] = $this->formBuilder()->getForm('Drupal\faq\Form\CategoriesForm');

    return $build;
  }

  /*   * ***************************************************************
   * PRIVATE HELPER FUCTIONS
   * *************************************************************** */

  /**
   * Display FAQ questions and answers filtered by category.
   *
   * @param $faq_display
   *   Define the way the FAQ is being shown; can have the values:
   *   'questions top',hide answers','questions inline','new page'.
   * @param $category_display
   *   The layout of categories which should be used.
   * @param $term
   *   The category / term to display FAQs for.
   * @param $display_header
   *   Set if the header will be shown or not.
   * @param &$output
   *   Reference which holds the content of the page, HTML formatted.
   * @param &$output_answer
   *   Reference which holds the answers from the FAQ, when showing questions
   *   on top.
   */
  private function _displayFaqByCategory($faq_display, $category_display, $term, $display_header, &$output, &$output_answers) {
    $langcode = \Drupal::languageManager()->getCurrentLanguage()->getId();
    $default_sorting = \Drupal::config('faq.settings')->get('default_sorting');

    $term_id = $term->id();

    $query = \Drupal::database()->select('node', 'n');
    $query->join('node_field_data', 'd', 'd.nid = n.nid');
    $query->innerJoin('taxonomy_index', 'ti', 'n.nid = ti.nid');
    $query->leftJoin('faq_weights', 'w', 'w.tid = ti.tid AND n.nid = w.nid');
    $query->fields('n', ['nid'])
      ->condition('n.type', 'faq')
      ->condition('d.langcode', $langcode)
      ->condition('d.status', 1)
      ->condition("ti.tid", $term_id)
      ->addTag('node_access');

    $default_weight = 0;
    if ($default_sorting == 'ASC') {
      $default_weight = 1000000;
    }
    // Works, but involves variable concatenation - safe though, since
    // $default_weight is an integer.
    $query->addExpression("COALESCE(w.weight, $default_weight)", 'effective_weight');
    // Doesn't work in Postgres.
    //$query->addExpression('COALESCE(w.weight, CAST(:default_weight as SIGNED))', 'effective_weight', array(':default_weight' => $default_weight));
    $query->orderBy('effective_weight', 'ASC')
      ->orderBy('d.sticky', 'DESC');
    if ($default_sorting == 'ASC') {
      $query->orderBy('d.created', 'ASC');
    }
    else {
      $query->orderBy('d.created', 'DESC');
    }

    // We only want the first column, which is nid, so that we can load all
    // related nodes.
    $nids = $query->execute()->fetchCol();
    $data = Node::loadMultiple($nids);
    foreach ($data as $key => &$node) {
      $node =  ($node->hasTranslation($langcode)) ? $node->getTranslation($langcode) : $node;
    }

    // Handle indenting of categories.
    $depth = 0;
    if (!isset($term->depth)) {
      $children = \Drupal::entityManager()->getStorage('taxonomy_term')->loadChildren($term->id());
      $term->depth = count($children);
    }
    while ($depth < $term->depth) {
      $display_header = 1;
      $indent = '<div class="faq-category-indent">';
      $output .= $indent;
      $depth++;
    }

    // Set up the class name for hiding the q/a for a category if required.
    $faq_class = "faq-qa";
    if ($category_display == "hide_qa") {
      $faq_class = "faq-qa-hide";
    }

    $output_render = $output_answers_render = array(
      '#data' => $data,
      '#display_header' => $display_header,
      '#category_display' => $category_display,
      '#term' => $term,
      '#class' => $faq_class,
      '#parent_term' => $term,
    );

    switch ($faq_display) {
      case 'questions_top':
        $output_render['#theme'] = 'faq_category_questions_top';
        $output .= drupal_render($output_render);
        $output_answers_render['#theme'] = 'faq_category_questions_top_answers';
        $output_answers .= drupal_render($output_answers_render);
        break;

      case 'hide_answer':
        $output_render['#theme'] = 'faq_category_hide_answer';
        $output .= drupal_render($output_render);
        break;

      case 'questions_inline':
        $output_render['#theme'] = 'faq_category_questions_inline';
        $output .= drupal_render($output_render);
        break;

      case 'new_page':
        $output_render['#theme'] = 'faq_category_new_page';
        $output .= drupal_render($output_render);
        break;
    }
    // Handle indenting of categories.
    while ($depth > 0) {
      $output .= '</div>';
      $depth--;
    }
  }

  /**
   * Return a structured array that consists a list of terms indented according to the term depth.
   *
   * @param $vid
   *   Vocabulary id.
   * @param $tid
   *   Term id.
   * @return
   *   Return an array of a list of terms indented according to the term depth.
   */
  private function _getIndentedFaqTerms($vid, $tid) {
    //if ($this->moduleHandler()->moduleExists('pathauto')) {
    // pathauto does't exists in D8 yet
    //}
    $faq_settings = \Drupal::config('faq.settings');

    $display_faq_count = $faq_settings->get('count');
    $hide_child_terms = $faq_settings->get('hide_child_terms');

    $items = array();
    $tree = \Drupal::entityManager()->getStorage('taxonomy_term')->loadTree($vid, $tid, 1, TRUE);

    foreach ($tree as $term) {
      $term_id = $term->id();
      $tree_count = FaqHelper::taxonomyTermCountNodes($term_id);

      if ($tree_count) {
        // Get term description.
        $desc = '';
        $term_description = $term->getDescription();
        if (!empty($term_description)) {
          $desc = '<div class="faq-qa-description">';
          $desc .= $term_description . "</div>";
        }


        $query = db_select('node', 'n');
        $query->join('node_field_data', 'd', 'n.nid = d.nid');
        $query->innerJoin('taxonomy_index', 'ti', 'n.nid = ti.nid');
        $term_node_count = $query->condition('d.status', 1)
          ->condition('n.type', 'faq')
          ->condition("ti.tid", $term_id)
          ->addTag('node_access')
          ->countQuery()
          ->execute()
          ->fetchField();


        if ($term_node_count > 0) {
          $path = URL::fromUserInput('/faq-page/' . $term_id);

          // pathauto is not exists in D8 yet
          //if (!\Drupal::service('path.alias_manager.cached')->getPathAlias(arg(0) . '/' . $tid) && $this->moduleHandler()->moduleExists('pathauto')) {
          //}

          if ($display_faq_count) {
            $count = $term_node_count;
            if ($hide_child_terms) {
              $count = $tree_count;
            }
            $cur_item = \Drupal::l($this->t($term->getName()), $path) . " ($count) " . $desc;
          }
          else {
            $cur_item = \Drupal::l($this->t($term->getName()), $path) . $desc;
          }
        }
        else {
          $cur_item = $this->t($term->getName()) . $desc;
        }
        if (!empty($term_image)) {
          $cur_item .= '<div class="clear-block"></div>';
        }

        $term_items = array();
        if (!$hide_child_terms) {
          $term_items = $this->_getIndentedFaqTerms($vid, $term_id);
        }
        $items[] = array(
          "item" => $cur_item,
          "children" => $term_items,
        );
      }
    }

    return $items;
  }

  /**
   * Renders the output of getIntendedFaqTerms to HTML list.
   * 
   * @param array $items
   *   The structured array made by getIntendedTerms function
   * @param string $list_style
   *   List style type: ul or ol.
   * @return string
   *   HTML formatted output.
   */
  private function _renderCategoriesToList($items, $list_style) {
    
    $list = array();
    
    foreach ($items as $item) {
      $pre = '';
      if (!empty($item['children'])) {
        $pre = $this->_renderCategoriesToList($item['children'], $list_style);
      }
      $list[] = new FormattableMarkup($item['item'] . $pre, []);
    }
    
    $render = array(
      '#theme' => 'item_list',
      '#items' => $list,
      '#list_style' => $list_style,
    );
    
    return drupal_render($render);
  }

}
