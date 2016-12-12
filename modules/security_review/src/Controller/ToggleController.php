<?php

/**
 * @file
 * Contains \Drupal\security_review\Controller\ToggleController.
 */

namespace Drupal\security_review\Controller;

use Drupal\Core\Access\CsrfTokenGenerator;
use Drupal\Core\Controller\ControllerBase;
use Drupal\Core\Url;
use Drupal\security_review\Checklist;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\RequestStack;

/**
 * Responsible for handling the toggle links on the Run & Review page.
 */
class ToggleController extends ControllerBase {

  /**
   * The security_review.checklist service.
   *
   * @var \Drupal\security_review\Checklist
   */
  protected $checklist;

  /**
   * The CSRF Token generator.
   *
   * @var \Drupal\Core\Access\CsrfTokenGenerator $csrfToken
   */
  protected $csrfToken;

  /**
   * The request stack.
   *
   * @var \Symfony\Component\HttpFoundation\Request $request
   */
  protected $request;

  /**
   * Constructs a ToggleController.
   *
   * @param \Drupal\Core\Access\CsrfTokenGenerator $csrf_token_generator
   *   The CSRF Token generator.
   * @param \Symfony\Component\HttpFoundation\RequestStack $request
   *   The request stack.
   * @param \Drupal\security_review\Checklist $checklist
   *   The security_review.checklist service.
   */
  public function __construct(CsrfTokenGenerator $csrf_token_generator, RequestStack $request, Checklist $checklist) {
    $this->checklist = $checklist;
    $this->csrfToken = $csrf_token_generator;
    $this->request = $request->getCurrentRequest();
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container) {
    return new static(
      $container->get('csrf_token'),
      $container->get('request_stack'),
      $container->get('security_review.checklist')
    );
  }

  /**
   * Handles check toggling.
   *
   * @param string $check_id
   *   The ID of the check.
   *
   * @return \Symfony\Component\HttpFoundation\JsonResponse|\Symfony\Component\HttpFoundation\RedirectResponse
   *   The response.
   */
  public function index($check_id) {
    // Determine access type.
    $ajax = $this->request->query->get('js') == 1;

    // Validate token.
    $token = $this->request->query->get('token');
    if ($this->csrfToken->validate($token, $check_id)) {
      // Toggle.
      $check = $this->checklist->getCheckById($check_id);
      if ($check != NULL) {
        if ($check->isSkipped()) {
          $check->enable();
        }
        else {
          $check->skip();
        }
      }

      // Output.
      if ($ajax) {
        return new JsonResponse([
          'skipped' => $check->isSkipped(),
          'toggle_text' => $check->isSkipped() ? $this->t('Enable') : $this->t('Skip'),
          'toggle_href' => Url::fromRoute(
            'security_review.toggle',
            ['check_id' => $check->id()],
            [
              'query' => [
                'token' => $this->csrfToken->get($check->id()),
                'js' => 1,
              ],
            ]
          )->toString(),
        ]);
      }
      else {
        // Set message.
        if ($check->isSkipped()) {
          drupal_set_message($this->t(
            '@name check skipped.',
            ['@name' => $check->getTitle()]
          ));
        }
        else {
          drupal_set_message($this->t(
            '@name check no longer skipped.',
            ['@name' => $check->getTitle()]
          ));
        }

        // Redirect back to Run & Review.
        return $this->redirect('security_review');
      }
    }

    // Go back to Run & Review if the access was wrong.
    return $this->redirect('security_review');
  }

}
