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
 * Provides render context for a given snippet entity.
 *
 * @param \Drupal\snippet_manager\SnippetInterface $snippet
 *   The snippet entity.
 *
 * @return array|null
 *   Snippet context items or null.
 */
function hook_snippet_context(SnippetInterface $snippet) {
  $context = [];
  if ($snippet->id() == 'foo') {
    $context['bar'] = [
      '#type' => 'details',
      '#title' => t('Click me'),
      '#value' => t('Hello world!'),
    ];
  }
  return $context;
}

/**
 * Alters snippet context before rendering.
 *
 * @param array $context
 *   Snippet context to be altered.
 * @param \Drupal\snippet_manager\SnippetInterface $snippet
 *   The snippet entity.
 */
function hook_snippet_context_alter(array &$context, SnippetInterface $snippet) {
  if ($snippet->id() == 'foo') {
    $context['bar'] = 'New value';
  }
}

/**
 * @} End of "addtogroup hooks".
 */
