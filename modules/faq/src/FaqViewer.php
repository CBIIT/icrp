<?php

/**
 * @file
 * Contains \Drupal\faq\FaqViewController.
 */

namespace Drupal\faq;

use Drupal\Component\Render\FormattableMarkup;
use Drupal\Core\Url;

/**
 * Controlls the display of questions and answers.
 */
class FaqViewer {

  /**
   * Helper function to setup the faq question.
   *
   * @param array &$data
   *   Array reference to store display data in.
   * @param \Drupal\node\NodeInterface $node
   *   The node object.
   * @param string $path
   *   The path/url which the question should link to if links are disabled.
   * @param string $anchor
   *   Link anchor to use in question links.
   */
  public static function viewQuestion(&$data, \Drupal\node\NodeInterface $node, $path = NULL, $anchor = NULL) {

    $faq_settings = \Drupal::config('faq.settings');
    $disable_node_links = $faq_settings->get('disable_node_links');
    $question = '';

    // Don't link to faq node, instead provide no link, or link to current page.
    if ($disable_node_links) {
      if (empty($path) && empty($anchor)) {
        $question = $node->getTitle();
      }
      elseif (empty($path)) {
        // Can't seem to use l() function with empty string as screen-readers
        // don't like it, so create anchor name manually.
        $question = '<a id="' . $anchor . '"></a>' . $node->getTitle();
      }
      else {
        $options = array();
        if ($anchor) {
          $options['attributes'] = array('id' => $anchor);
        }
        $question = \Drupal::l($node->getTitle(), $path, $options);
      }
    }

    // Link to faq node.
    else {
      $node_id = $node->id();
      if (empty($anchor)) {
        $question = \Drupal::l($node->getTitle(), "node/$node_id)");
      }
      else {
        $url = $node->toUrl()->setOptions(array("attributes" => array("id" => "$anchor")));
        $question = \Drupal::l($node->getTitle(), $url);
      }
    }
    $question = '<span datatype="" property="dc:title">' . $question . '</span>';

    $detailed_question = $node->get('field_detailed_question')->value;
    if ($faq_settings->get('display') != 'hide_answer' && !empty($detailed_question) && $faq_settings->get('question_length') == 'both') {
      $question .= '<div class="faq-detailed-question">' . $detailed_question . '</div>';
    }
    $data['question'] = new FormattableMarkup($question, []);
  }

  /**
   * Helper function to setup the faq answer.
   *
   * @param array &$data
   *   Array reference to store display data in.
   * @param Drupal\node\NodeInterface $node
   *   The node object.
   * @param string $back_to_top
   *   An array containing the "back to top" link.
   * @param bool $teaser
   *   Whether or not to use teasers.
   * @param bool $links
   *   Whether or not to show node links.
   */
  public static function viewAnswer(&$data, \Drupal\node\NodeInterface $node, $teaser) {
    $faq_settings = \Drupal::config('faq.settings');

    // TODO: hide 'submitted by ... on ...'
    $view_mode = $teaser ? 'teaser' : 'full';

    $node_build = node_view($node, $view_mode);
    
    hide($node_build['title']);
    if (!$faq_settings->get('question_long_form')) {
      hide($node_build['field_detailed_question']);
    }
    
    $content = drupal_render($node_build);

    $content .= FaqViewer::initBackToTop();

    $data['body'] = new FormattableMarkup($content, []);
  }

  /**
   * Helper function to setup the "back to top" link.
   *
   * @param string $path
   *   The path/url where the "back to top" link should bring the user too.  This
   *   could be the 'faq-page' page or one of the categorized faq pages, e.g 'faq-page/123'
   *   where 123 is the tid.
   * @return
   *   An array containing the "back to top" link.
   */
  public static function initBackToTop() {

    $faq_settings = \Drupal::config('faq.settings');

    $back_to_top = '';
    $back_to_top_text = trim($faq_settings->get('back_to_top'));
    if (!empty($back_to_top_text)) {
      $options = array(
        'attributes' => array('title' => t('Go back to the top of the page.')),
        'html' => TRUE,
        'fragment' => 'top',
      );
      $back_to_top = \Drupal::l(new FormattableMarkup($back_to_top_text, []), Url::fromRoute('<current>'), $options);
    }

    return $back_to_top;
  }

}
