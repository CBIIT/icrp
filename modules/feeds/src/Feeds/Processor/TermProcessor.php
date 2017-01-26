<?php

namespace Drupal\feeds\Feeds\Processor;

/**
 * Defines a term processor.
 *
 * Creates taxonomy terms from feed items.
 *
 * @FeedsProcessor(
 *   id = "entity:taxonomy_term",
 *   title = @Translation("Term"),
 *   description = @Translation("Creates taxonomy terms from feed items."),
 *   entity_type = "taxonomy_term",
 *   arguments = {"@entity.manager", "@entity.query"},
 *   form = {
 *     "configuration" = "Drupal\feeds\Feeds\Processor\Form\DefaultEntityProcessorForm",
 *     "option" = "Drupal\feeds\Feeds\Processor\Form\EntityProcessorOptionForm",
 *   },
 * )
 */
class TermProcessor extends EntityProcessorBase {

}
