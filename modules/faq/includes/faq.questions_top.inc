<?php

/**
 * @file
 * FAQ page callbacks for the "questions top" layouts.
 */

use Drupal\Core\Url;
use Drupal\faq\FaqHelper;
use Drupal\faq\FaqViewer;

/**
 * Create the structure of the page, when the questions are to be shown on top.
 *
 * @param &$variables
 *   Array reference of arguments given to the theme() function.
 * @return
 *   A variable holding the HTML formatted page.
 */
function template_preprocess_faq_questions_top(&$variables) {
  $faq_settings = \Drupal::config('faq.settings');
  $data = $variables['data'];

  // Fetch configuration.
  $teaser = $faq_settings->get('use_teaser');

  // Configure labels.
  $variables['question_label'] = '';
  $variables['answer_label'] = '';
  if ($faq_settings->get('qa_mark')) {
    $variables['question_label'] = $faq_settings->get('question_label');
    $variables['answer_label'] = $faq_settings->get('answer_label');
  }

  $this_page = Url::fromRoute('<current>');

  // Loop through results.
  $questions = array();
  $answers = array();
  $key = 0;
  foreach ($data as $node) {
    $anchor = 'n' . $node->id();
    $this_page->setOptions(array('fragment' => $anchor));
    $questions[$key] = \Drupal::l($node->getTitle(), $this_page);
    FaqViewer::viewQuestion($answers[$key], $node, NULL, $anchor);
    FaqViewer::viewAnswer($answers[$key], $node, $teaser);
    $key++;
  }
  $variables['limit'] = $key;

  $list_style = $faq_settings->get('question_listing');
  $variables['list_style'] = $list_style;
  $variables['use_teaser'] = $teaser;
  $variables['questions'] = $questions;
  $variables['answers'] = $answers;
  $item_list = array(
    '#theme' => 'item_list',
    '#items' => $questions,
    '#title' => t('Content'),
    '#list_type' => $list_style,
  );
  $variables['questions_list'] = drupal_render($item_list);
}

/**
 * Create categorized questions for FAQ page if set to show questions on top.
 *
 * @param &$variables
 *   Array reference of arguments given to the theme() function.
 */
function template_preprocess_faq_category_questions_top(&$variables) {

  $faq_settings = \Drupal::config('faq.settings');

  $data = $variables['data'];
  $category_display = $variables['category_display'];
  $term = $variables['term'];
  $parent_term = $variables['parent_term'];
  $class = $variables['class'];

  // Fetch configuration.
  $teaser = $faq_settings->get('use_teaser');
  $display_faq_count = $faq_settings->get('count');
  $hide_child_terms = $faq_settings->get('hide_child_terms');
  $show_term_page_children = $faq_settings->get('show_term_page_children');
  $group_questions_top = $faq_settings->get('group_questions_top');
  $default_sorting = $faq_settings->get('default_sorting');

  // Configure labels.
  $variables['question_label'] = '';
  $variables['answer_label'] = '';
  if ($faq_settings->get('qa_mark')) {
    $variables['question_label'] = $faq_settings->get('question_label');
    $variables['answer_label'] = $faq_settings->get('answer_label');
  }

  // Initialise some variables.
  $default_weight = 0;
  if ($default_sorting != 'DESC') {
    $default_weight = 1000000;
  }
  $this_page = URL::fromRoute('<current>');
  $get_child_terms = 0;
  // Check if we're on a faq page.
  if ($id = FaqHelper::searchInArgs('faq-page')) {
    $next_id = ($id) + 1;
    // Check if we're on a categorized faq page.
    if (is_numeric(FaqHelper::arg($next_id))) {
      $get_child_terms = FaqHelper::arg($next_id);
    }
  }
  // Force some settings in case we're processing a special faq question list
  // created by a custom call to faq_page().
  elseif (!empty($parent_term)) {
    $get_child_terms = $parent_term->id();
    $show_term_page_children = TRUE;
  }

  // Get number of questions, and account for hidden sub-categories.
  $count = 0;
  if ($display_faq_count && $hide_child_terms) {
    $count = FaqHelper::taxonomyTermCountNodes($term->id());
  }
  $variables['display_faq_count'] = $display_faq_count;

  // Get taxonomy image.
  // taxonomy_image module doesn't exists yet in D8
  $variables['term_image'] = '';
  //if (module_exists('taxonomy_image')) {
  //  $variables['term_image'] = '';
  //  $variables['term_image'] = taxonomy_image_display($term->tid, array('class' => 'faq-tax-image'));
  //}

  $term_id = $term->id();
  // Configure header.
  $variables['category_depth'] = $term->depth;
  $variables['category_name'] = $term->getName();
  if ($category_display == 'hide_qa') {
    $url = URL::fromUserInput('/faq/' . $term_id);
    $variables['header_title'] = \Drupal::l($term->getName(), $url);
  }
  else {
    $variables['header_title'] = $term->getName();
  }

  // Configure category description.
  $variables['description'] = ($term->getDescription()) ? t($term->getDescription()) : '';

  // Get list of sub-categories if necessary.
  $child_categories = array();
  if (($show_term_page_children || $hide_child_terms) && $category_display == 'new_page') {
    $child_categories = FaqHelper::viewChildCategoryHeaders($term);
  }
  $variables['subcat_list'] = $child_categories;
  $variables['subcat_list_style'] = $faq_settings->get('category_listing');

  // Configure class (faq-qa or faq-qa-hide).
  if ($get_child_terms == $term_id) {
    $variables['container_class'] = 'faq-qa';
  }
  else {
    $variables['container_class'] = $class;
  }

  // Configure sub-category bodies (theme recursively).
  $variables['subcat_body_list'] = array();
  if (($get_child_terms && $category_display == 'categories_inline') || ((($show_term_page_children && $this_page != 'faq-page') || $hide_child_terms) && $category_display == 'hide_qa')) {
    $variables['subcat_body_list'] = FaqHelper::getChildCategoriesFaqs($term, 'faq_category_questions_top', $default_weight, $default_sorting, $category_display, $variables['class'], $parent_term);
  }

  $variables['group_questions_top'] = $group_questions_top;

  if (!count($data)) {
    $variables['question_count'] = $count;
    $variables['nodes'] = array();
    $variables['answer_category_name'] = FALSE;
    return;
  }

  $questions = array();
  $nodes = array();
  foreach ($data as $node) {
    if (!$hide_child_terms) {
      $count++;
    }
    $node_var = array();
    $anchor = 't' . $term->id() . 'n' . $node->id();
    $this_page->setOptions(array('fragment' => $anchor));
    $questions[] = \Drupal::l($node->getTitle(), $this_page);
    FaqViewer::viewQuestion($node_var, $node, NULL, $anchor);
    if ($group_questions_top || $category_display == 'hide_qa') {
      FaqViewer::viewAnswer($node_var, $node, $teaser);
    }
    $nodes[] = $node_var;
  }
  $variables['question_count'] = $count;
  $variables['use_teaser'] = $teaser;
  $variables['question_list'] = $questions;
  $variables['question_list_style'] = $faq_settings->get('question_listing');

  if ($group_questions_top || $category_display == "hide_qa") {
    $variables['nodes'] = $nodes;
    $variables['answer_category_name'] = $faq_settings->get('answer_category_name');
  }
  else {
    $variables['nodes'] = array();
    $variables['answer_category_name'] = FALSE;
  }
}

/**
 * Create categorized answers for FAQ page if set to show the questions on top.
 *
 * @param &$variables
 *   Array reference of arguments given to the theme() function.
 */
function template_preprocess_faq_category_questions_top_answers(&$variables) {
  $faq_settings = \Drupal::config('faq.settings');
  $data = $variables['data'];
  $category_display = $variables['category_display'];
  $term = $variables['term'];
  $parent_term = $variables['parent_term'];

  // Fetch configuration.
  $teaser = $faq_settings->get('use_teaser');
  $hide_child_terms = $faq_settings->get('hide_child_terms');
  $show_term_page_children = $faq_settings->get('show_term_page_children');
  $group_questions_top = $faq_settings->get('group_questions_top');
  $default_sorting = $faq_settings->get('default_sorting');

  // Configure labels.
  $variables['question_label'] = '';
  $variables['answer_label'] = '';
  if ($faq_settings->get('qa_mark')) {
    $variables['question_label'] = $faq_settings->get('question_label');
    $variables['answer_label'] = $faq_settings->get('answer_label');
  }

  // Initialise some variables.
  $default_weight = 0;
  if ($default_sorting != 'DESC') {
    $default_weight = 1000000;
  }

  $variables['group_questions_top'] = $group_questions_top;
  if ($group_questions_top || $category_display == "hide_qa") {
    $variables['display_answers'] = FALSE;
    $variables['category_depth'] = 0;
    return;
  }
  $variables['display_answers'] = TRUE;

  $this_page = URL::fromRoute('<current>');
  $get_child_terms = 0;
  // Check if we're on a faq page.
  if ($id = FaqHelper::searchInArgs('faq-page')) {
    $next_id = ($id) + 1;
    // Check if we're on a categorized faq page.
    if (is_numeric(FaqHelper::arg($next_id))) {
      $get_child_terms = FaqHelper::arg($next_id);
    }
  }
  // Force some settings in case we're processing a special faq question list
  // created by a custom call to faq_page().
  elseif (!empty($parent_term)) {
    $get_child_terms = $parent_term->id();
    $show_term_page_children = TRUE;
  }

  // taxonomy_image does not exists in D8 yet
  // Get taxonomy image.
  $variables['term_image'] = '';
  //if (module_exists('taxonomy_image')) {
  //  $variables['term_image'] = taxonomy_image_display($term->tid, array('class' => 'faq-tax-image'));
  //}
  // Configure sub-category bodies (theme recursively).
  $variables['subcat_body_list'] = array();
  if (($get_child_terms && $category_display == 'categories_inline') || ((($show_term_page_children && $this_page != 'faq-page') || $hide_child_terms) && $category_display == 'hide_qa')) {
    $variables['subcat_body_list'] = FaqHelper::getChildCategoriesFaqs($term, 'faq_category_questions_top_answers', $default_weight, $default_sorting, $category_display, $variables['class'], $parent_term);
  }


  $nodes = array();
  foreach ($data as $node) {
    $node_var = array();
    $anchor = 't' . $term->id() . 'n' . $node->id();
    FaqViewer::viewQuestion($node_var, $node, NULL, $anchor);
    FaqViewer::viewAnswer($node_var, $node, $teaser);
    $nodes[] = $node_var;
  }
  $variables['use_teaser'] = $teaser;
  $variables['nodes'] = $nodes;
  $variables['category_name'] = t($term->getName());
  $variables['category_depth'] = $term->depth;
  $variables['display_header'] = FALSE;
  $variables['answer_category_name'] = $faq_settings->get('answer_category_name');
  if ($variables['answer_category_name'] && FaqHelper::taxonomyTermCountNodes($term->id())) {
    $variables['display_header'] = TRUE;
  }
}
