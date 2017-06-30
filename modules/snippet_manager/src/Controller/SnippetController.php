<?php

namespace Drupal\snippet_manager\Controller;

use Drupal\Core\Controller\ControllerBase;
use Drupal\snippet_manager\SnippetInterface;

/**
 * Controller routines for admin snippet routes.
 */
class SnippetController extends ControllerBase {

  /**
   * Calls a method on a snippet and reloads the listing page.
   *
   * @param \Drupal\snippet_manager\SnippetInterface $snippet
   *   The snippet being acted upon.
   * @param string $op
   *   The operation to perform, e.g., 'enable' or 'disable'.
   *
   * @return \Symfony\Component\HttpFoundation\RedirectResponse
   *   A redirect back to the listing page.
   */
  public function performOperation(SnippetInterface $snippet, $op) {
    $snippet->$op()->save();
    $args = ['%name' => $snippet->label()];
    $message = $op == 'enable'
      ? $this->t('Snippet %name has been enabled.', $args)
      : $this->t('Snippet %name has been disabled.', $args);
    drupal_set_message($message);
    return $this->redirect('entity.snippet.collection');
  }

}
