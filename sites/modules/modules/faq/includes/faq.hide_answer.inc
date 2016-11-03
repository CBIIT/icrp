<?php

/**
 * @file
 * FAQ page callbacks for the "hide answer" layouts.
 */

use Drupal\Core\Url;
use Drupal\faq\FaqHelper;
use Drupal\faq\FaqViewer;
use Drupal\Component\Utility\SafeMarkup;

/**
 * Create FAQ page if set to show/hide answer when question is clicked.
 *
 * @param &$variables
 *   Array reference of arguments given to the theme() function.
 */
function template_preprocess_faq_hide_answer(&$variables) {
  $faq_settings = \Drupal::config('faq.settings');
  $data = $variables['data'];
  $this_page = URL::fromRoute('<current>');

  // Fetch configuration.
  $teaser = $faq_settings->get('use_teaser');

  $nodes = array();
  foreach ($data as $index=>$node) {
    $anchor = 'n' . $node->id();
    FaqViewer::viewQuestion($nodes[$index], $node, $this_page, $anchor);
    FaqViewer::viewAnswer($nodes[$index], $node, $teaser);
  }
  $variables['use_teaser'] = $teaser;
  $variables['nodes'] = $nodes;
}

/**
 * Create categorized FAQ page if set to show answer when question is clicked.
 *
 * @param &$variables
 *   Array reference of arguments given to the theme() function.
 */
function template_preprocess_faq_category_hide_answer(&$variables) {
  $faq_settings = \Drupal::config('faq.settings');
  $data = $variables['data'];
  $category_display = $variables['category_display'];
  $term = $variables['term'];
  $term_id = $term->id();
  $parent_term = $variables['parent_term'];
  $class = $variables['class'];

  // Fetch configuration.
  $teaser = $faq_settings->get('use_teaser');
  $variables['use_teaser'] = $teaser;
  $display_faq_count = $faq_settings->get('count');
  $hide_child_terms = $faq_settings->get('hide_child_terms');
  $show_term_page_children = $faq_settings->get('show_term_page_children');
  $default_sorting = $faq_settings->get('default_sorting');

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
    $count = FaqHelper::taxonomyTermCountNodes($term_id);
  }
  $variables['display_faq_count'] = $display_faq_count;

  // Get taxonomy image.
  $variables['term_image'] = '';
  // taxonomy_image module is not exists in D8 yet
  //if (module_exists('taxonomy_image')) {
  //  $variables['term_image'] = taxonomy_image_display($term->tid, array('class' => 'faq-tax-image'));
  //}
  // Configure header.
  $variables['category_depth'] = $term->depth;
  $variables['category_name'] = $term->getName();
  if ($category_display == 'hide_qa') {
    $variables['header_title'] = \Drupal::l($term->getName(), URL::fromUserInput('/faq/' . $term_id));
  }
  else {
    $variables['header_title'] = $term->getName();
  }

  // Configure category description.
  $variables['description'] = SafeMarkup::checkPlain($term->getDescription());

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
    $variables['subcat_body_list'] = FaqHelper::getChildCategoriesFaqs($term, 'faq_category_hide_answer', $default_weight, $default_sorting, $category_display, $variables['class'], $parent_term);
  }

  if (!count($data)) {
    $variables['question_count'] = $count;
    $variables['nodes'] = array();
    return;
  }

  $nodes = array();
  foreach ($data as $node) {
    if (!$hide_child_terms) {
      $count++;
    }
    $node_var = array();
    $anchor = 't' . $term_id . 'n' . $node->id();
    FaqViewer::viewQuestion($node_var, $node, $this_page, $anchor);
    FaqViewer::viewAnswer($node_var, $node, $teaser);
    $nodes[] = $node_var;
  }
  $variables['nodes'] = $nodes;
  $variables['question_count'] = $count;
}
