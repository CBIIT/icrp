<?php

namespace Drupal\clientside_validation\Plugin\CvValidator;

use Drupal\clientside_validation\CvValidatorBase;
use Drupal\Core\Form\FormStateInterface;
use Drupal\link\LinkItemInterface;

/**
 * Provides a 'url' validator for internal url.
 *
 * @CvValidator(
 *   id = "url_internal_external",
 *   name = @Translation("Url - Internal/External"),
 *   supports = {
 *     "attributes" = {
 *       "link_type"
 *     }
 *   }
 * )
 */
class UrlInternalExternal extends CvValidatorBase {

  /**
   * {@inheritdoc}
   */
  protected function getRules($element, FormStateInterface $form_state) {
    return [
      'messages' => [
        'pattern' => $this->t('@title does not contain a valid url.', ['@title' => $this->getElementTitle($element)]),
      ],
    ];
  }

  /**
   * {@inheritdoc}
   */
  public function addValidation(array &$element, FormStateInterface $form_state) {
    parent::addValidation($element, $form_state);
    // needs patch from https://www.drupal.org/node/2613694
    switch($element['#link_type']) {
      case LinkItemInterface::LINK_GENERIC:
        $element['#attributes']['pattern'] = '\<front\>|\/.*|\?.*|#.*|[hH][tT][Tt][pP][sS]?://.+|.*\(\d+\)';
        break;

      case LinkItemInterface::LINK_INTERNAL:
        $element['#attributes']['pattern'] = '\<front\>|\/|\/[^\/]+.*|\?.*|#.*|.*\(\d+\)';
        break;

    }
  }

}
