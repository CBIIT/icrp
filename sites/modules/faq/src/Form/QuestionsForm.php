<?php

/**
 * @file
 * Contains \Drupal\faq\Form\QuestionsForm.
 */

namespace Drupal\faq\Form;

use Drupal\Core\Form\ConfigFormBase;
use Drupal\Core\Form\FormStateInterface;

/**
 * Form for the FAQ settings page - questions tab.
 */
class QuestionsForm extends ConfigFormBase {

  /**
   * {@inheritdoc}
   */
  public function getFormId() {
    return 'faq_questions_settings_form';
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

    $display_options['questions_inline'] = $this->t('Questions inline');
    $display_options['questions_top'] = $this->t('Clicking on question takes user to answer further down the page');
    $display_options['hide_answer'] = $this->t('Clicking on question opens/hides answer under question');
    $display_options['new_page'] = $this->t('Clicking on question opens the answer in a new page');

    $form['faq_display'] = array(
      '#type' => 'radios',
      '#options' => $display_options,
      '#title' => $this->t('Page layout'),
      '#description' => $this->t('This controls how the questions and answers are displayed on the page and what happens when someone clicks on the question.'),
      '#default_value' => $faq_settings->get('display')
    );

    $form['faq_questions_misc'] = array(
      '#type' => 'details',
      '#title' => $this->t('Miscellaneous layout settings'),
      '#open' => TRUE
    );

    $form['faq_questions_misc']['faq_question_listing'] = array(
      '#type' => 'select',
      '#options' => array(
        'ol' => $this->t('Ordered list'),
        'ul' => $this->t('Unordered list'),
      ),
      '#title' => $this->t('Questions listing style'),
      '#description' => $this->t("This allows to select how the questions listing is presented.  It only applies to the layouts: 'Clicking on question takes user to answer further down the page' and 'Clicking on question opens the answer in a new page'.  An ordered listing would number the questions, whereas an unordered list will have a bullet to the left of each question."),
      '#default_value' => $faq_settings->get('question_listing')
    );

    $form['faq_questions_misc']['faq_qa_mark'] = array(
      '#type' => 'checkbox',
      '#title' => $this->t('Label questions and answers'),
      '#description' => $this->t('This option is only valid for the "Questions Inline" and "Clicking on question takes user to answer further down the page" layouts.  It labels all questions on the faq page with the "question label" setting and all answers with the "answer label" setting.  For example these could be set to "Q:" and "A:".'),
      '#default_value' => $faq_settings->get('qa_mark')
    );

    $form['faq_questions_misc']['faq_question_label'] = array(
      '#type' => 'textfield',
      '#title' => $this->t('Question Label'),
      '#description' => $this->t('The label to pre-pend to the question text in the "Questions Inline" layout if labelling is enabled.'),
      '#default_value' => $faq_settings->get('question_label')
    );

    $form['faq_questions_misc']['faq_answer_label'] = array(
      '#type' => 'textfield',
      '#title' => $this->t('Answer Label'),
      '#description' => $this->t('The label to pre-pend to the answer text in the "Questions Inline" layout if labelling is enabled.'),
      '#default_value' => $faq_settings->get('answer_label')
    );

    $form['faq_questions_misc']['faq_question_length'] = array(
      '#type' => 'radios',
      '#title' => $this->t('Question length'),
      '#options' => array(
        'long' => $this->t('Display longer text'),
        'short' => $this->t('Display short text'),
        'both' => $this->t('Display both short and long questions'),
      ),
      '#description' => t("The length of question text to display on the FAQ page.  The short question will always be displayed in the FAQ blocks."),
      '#default_value' => $faq_settings->get('question_length')
    );

    $form['faq_questions_misc']['faq_question_long_form'] = array(
      '#type' => 'checkbox',
      '#title' => $this->t('Allow long question text to be configured'),
      '#default_value' => $faq_settings->get('question_long_form')
    );

    $form['faq_questions_misc']['faq_hide_qa_accordion'] = array(
      '#type' => 'checkbox',
      '#title' => $this->t('Use accordion effect for "opens/hides answer under question" layout'),
      '#description' => $this->t('This enables an "accordion" style effect where when a question is clicked, the answer appears beneath, and is then hidden when another question is opened.'),
      '#default_value' => $faq_settings->get('hide_qa_accordion')
    );

    $form['faq_questions_misc']['faq_show_expand_all'] = array(
      '#type' => 'checkbox',
      '#title' => $this->t('Show "expand / collapse all" links for collapsed questions'),
      '#description' => $this->t('The links will only be displayed if using the "opens/hides answer under question" or "opens/hides questions and answers under category" layouts.'),
      '#default_value' => $faq_settings->get('show_expand_all')
    );

    $form['faq_questions_misc']['faq_use_teaser'] = array(
      '#type' => 'checkbox',
      '#title' => $this->t('Use answer teaser'),
      '#description' => t("This enables the display of the answer teaser text instead of the full answer when using the 'Questions inline' or 'Clicking on question takes user to answer further down the page' display options.  This is useful when you have long descriptive text.  The user can see the full answer by clicking on the question."),
      '#default_value' => $faq_settings->get('use_teaser')
    );

    // This setting has no meaning in D8 since comments are fields and read more link depends on view mode settings
    //$form['faq_questions_misc']['faq_show_node_links'] = array(
    //  '#type' => 'checkbox',
    //  '#title' => $this->t('Show node links'),
    //  '#description' => $this->t('This enables the display of links under the answer text on the faq page.  Examples of these links include "Read more", "Add comment".'),
    //  '#default_value' => $faq_settings->get('show_node_links')
    //);

    $form['faq_questions_misc']['faq_back_to_top'] = array(
      '#type' => 'textfield',
      '#title' => $this->t('"Back to Top" link text'),
      '#description' => $this->t('This allows the user to change the text displayed for the links which return the user to the top of the page on certain page layouts.  Defaults to "Back to Top".  Leave blank to have no link.'),
      '#default_value' => $faq_settings->get('back_to_top')
    );

    $form['faq_questions_misc']['faq_disable_node_links'] = array(
      '#type' => 'checkbox',
      '#title' => $this->t('Disable question links to nodes'),
      '#description' => $this->t('This allows the user to prevent the questions being links to the faq node in all layouts except "Clicking on question opens the answer in a new page".'),
      '#default_value' => $faq_settings->get('disable_node_links'),
    );

    $form['faq_questions_misc']['faq_default_sorting'] = array(
      '#type' => 'select',
      '#title' => $this->t('Default sorting for unordered FAQs'),
      '#options' => array(
        'DESC' => $this->t('Date Descending'),
        'ASC' => $this->t('Date Ascending'),
      ),
      '#description' => t("This controls the default ordering behaviour for new FAQ nodes which haven't been assigned a position."),
      '#default_value' => $faq_settings->get('default_sorting')
    );

    return parent::buildForm($form, $form_state);
  }

  /**
   * {@inheritdoc}
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {
    // Remove unnecessary values.
    $form_state->cleanValues();

    $this->configFactory()->getEditable('faq.settings')
      ->set('display', $form_state->getValue('faq_display'))
      ->set('question_listing', $form_state->getValue('faq_question_listing'))
      ->set('qa_mark', $form_state->getValue('faq_qa_mark'))
      ->set('question_label', $form_state->getValue('faq_question_label'))
      ->set('answer_label', $form_state->getValue('faq_answer_label'))
      ->set('question_length', $form_state->getValue('faq_question_length'))
      ->set('question_long_form', $form_state->getValue('faq_question_long_form'))
      ->set('hide_qa_accordion', $form_state->getValue('faq_hide_qa_accordion'))
      ->set('show_expand_all', $form_state->getValue('faq_show_expand_all'))
      ->set('use_teaser', $form_state->getValue('faq_use_teaser'))
      ->set('back_to_top', $form_state->getValue('faq_back_to_top'))
      ->set('disable_node_links', $form_state->getValue('faq_disable_node_links'))
      ->set('default_sorting', $form_state->getValue('faq_default_sorting'))
      ->save();

    parent::submitForm($form, $form_state);
  }

}
