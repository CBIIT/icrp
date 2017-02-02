<?php

/**
 * @file
 * Hooks specific to the Snippet manager module.
 */

use Drupal\snippet_manager\SnippetInterface;

/**
 * @addtogroup hooks
 * @{
 */

/**
 * Alter Snippet context before rendering.
 *
 * @param array $context
 *   Snippet context to be altered.
 * @param \Drupal\snippet_manager\SnippetInterface $snippet
 *   The snippet entity.
 */
function hook_snippet_manager_context_alter(array &$context, SnippetInterface $snippet) {
  if ($snippet->id() == 'foo') {
    $context['bar'] = [
      '#type' => 'details',
      '#title' => t('Click me'),
      '#value' => t('Hello world!'),
    ];
  }
}

/**
 * @} End of "addtogroup hooks".
 */
