<?php

/**
 * @file
 * Contains \Drupal\faq\Form\CategoriesForm.
 */

namespace Drupal\faq\Form;

use Drupal\Core\Form\ConfigFormBase;
use Drupal\taxonomy\Entity\Vocabulary;
use Drupal\Core\Form\FormStateInterface;

/**
 * Form for the FAQ settings page - categories tab.
 */
class CategoriesForm extends ConfigFormBase {

  /**
   * {@inheritdoc}
   */
  public function getFormId() {
    return 'faq_categories_settings_form';
  }

  /**
   * {@inheritdoc}
   */
  protected function getEditableConfigNames() {
    return [];
  }

  /**
   * {@inheritdoc}
   */
  public function buildForm(array $form, FormStateInterface $form_state) {
    $faq_settings = $this->config('faq.settings');

    // Set up a hidden variable.
    $form['faq_display'] = array(
      '#type' => 'hidden',
      '#value' => $faq_settings->get('display')
    );

    $form['faq_use_categories'] = array(
      '#type' => 'checkbox',
      '#title' => $this->t('Categorize questions'),
      '#description' => $this->t('This allows the user to display the questions according to the categories configured on the add/edit FAQ page.  Use of sub-categories is only recommended for large lists of questions.  The Taxonomy module must be enabled.'),
      '#default_value' => $faq_settings->get('use_categories')
    );

    $category_options['none'] = t("Don't display");
    $category_options['categories_inline'] = $this->t('Categories inline');
    $category_options['hide_qa'] = $this->t('Clicking on category opens/hides questions and answers under category');
    $category_options['new_page'] = $this->t('Clicking on category opens the questions/answers in a new page');

    $form['faq_category_display'] = array(
      '#type' => 'radios',
      '#options' => $category_options,
      '#title' => $this->t('Categories layout'),
      '#description' => $this->t('This controls how the categories are displayed on the page and what happens when someone clicks on the category.'),
      '#default_value' => $faq_settings->get('category_display')
    );

    $form['faq_category_misc'] = array(
      '#type' => 'details',
      '#title' => $this->t('Miscellaneous layout settings'),
      '#open' => TRUE
    );

    $form['faq_category_misc']['faq_category_listing'] = array(
      '#type' => 'select',
      '#options' => array(
        'ol' => $this->t('Ordered list'),
        'ul' => $this->t('Unordered list'),
      ),
      '#title' => $this->t('Categories listing style'),
      '#description' => t("This allows to select how the categories listing is presented.  It only applies to the 'Clicking on category opens the questions/answers in a new page' layout.  An ordered listing would number the categories, whereas an unordered list will have a bullet to the left of each category."),
      '#default_value' => $faq_settings->get('category_listing')
    );

    $form['faq_category_misc']['faq_category_hide_qa_accordion'] = array(
      '#type' => 'checkbox',
      '#title' => $this->t('Use accordion effect for "opens/hides questions and answers under category" layout'),
      '#description' => $this->t('This enables an "accordion" style effect where when a category is clicked, the questions appears beneath, and is then hidden when another category is opened.'),
      '#default_value' => $faq_settings->get('category_hide_qa_accordion')
    );

    $form['faq_category_misc']['faq_count'] = array(
      '#type' => 'checkbox',
      '#title' => $this->t('Show FAQ count'),
      '#description' => $this->t('This displays the number of questions in a category after the category name.'),
      '#default_value' => $faq_settings->get('count')
    );

    $form['faq_category_misc']['faq_answer_category_name'] = array(
      '#type' => 'checkbox',
      '#title' => $this->t('Display category name for answers'),
      '#description' => t("This allows the user to toggle the visibility of the category name above each answer section for the 'Clicking on question takes user to answer further down the page' question/answer display."),
      '#default_value' => $faq_settings->get('answer_category_name')
    );

    $form['faq_category_misc']['faq_group_questions_top'] = array(
      '#type' => 'checkbox',
      '#title' => t("Group questions and answers for 'Categories inline'"),
      '#description' => t("This controls how categories are implemented with the 'Clicking on question takes user to answer further down the page' question/answer display."),
      '#default_value' => $faq_settings->get('group_questions_top')
    );

    $form['faq_category_misc']['faq_hide_child_terms'] = array(
      '#type' => 'checkbox',
      '#title' => $this->t('Only show sub-categories when parent category is selected'),
      '#description' => t("This allows the user more control over how and when sub-categories are displayed.  It does not affect the 'Categories inline' display."),
      '#default_value' => $faq_settings->get('hide_child_terms')
    );

    $form['faq_category_misc']['faq_show_term_page_children'] = array(
      '#type' => 'checkbox',
      '#title' => $this->t('Show sub-categories on FAQ category pages'),
      '#description' => t("Sub-categories with 'faq' nodes will be displayed on the per category FAQ page.  This will also happen if 'Only show sub-categories when parent category is selected' is set."),
      '#default_value' => $faq_settings->get('show_term_page_children')
    );

    $moduleHandler = \Drupal::moduleHandler();
    if ($moduleHandler->moduleExists('taxonomy')) {
      $form['faq_category_advanced'] = array(
        '#type' => 'details',
        '#title' => $this->t('Advanced category settings'),
        '#open' => FALSE
      );
      $vocab_options = array();
      $vocabularies = Vocabulary::loadMultiple();
      foreach ($vocabularies as $vid => $vobj) {
        $vocab_options[$vid] = $vobj->get('name');
      }
      if (!empty($vocab_options)) {
        $form['faq_category_advanced']['faq_omit_vocabulary'] = array(
          '#type' => 'checkboxes',
          '#title' => $this->t('Omit vocabulary'),
          '#description' => $this->t('Terms from these vocabularies will be <em>excluded</em> from the FAQ pages.'),
          '#default_value' => $faq_settings->get('omit_vocabulary'),
          '#options' => $vocab_options,
          '#multiple' => TRUE,
        );
      }
    }

    return parent::buildForm($form, $form_state);
  }

  /**
   * {@inheritdoc}
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {
    // Remove unnecessary values.
    $form_state->cleanValues();

    $this->configFactory()->getEditable('faq.settings')
      ->set('use_categories', $form_state->getValue('faq_use_categories'))
      ->set('category_display', $form_state->getValue('faq_category_display'))
      ->set('category_listing', $form_state->getValue('faq_category_listing'))
      ->set('category_hide_qa_accordion', $form_state->getValue('faq_category_hide_qa_accordion'))
      ->set('count', $form_state->getValue('faq_count'))
      ->set('answer_category_name', $form_state->getValue('faq_answer_category_name'))
      ->set('group_questions_top', $form_state->getValue('faq_group_questions_top'))
      ->set('hide_child_terms', $form_state->getValue('faq_hide_child_terms'))
      ->set('show_term_page_children', $form_state->getValue('faq_show_term_page_children'))
      ->set('omit_vocabulary', $form_state->getValue('faq_omit_vocabulary'))
      ->save();

    parent::submitForm($form, $form_state);
  }

}
