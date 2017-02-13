<?php
/**
 * @file
 * contains \Drupal\icrp\Controller\ProfileUpdateController
 */
namespace Drupal\icrp\Controller;

use Drupal\Core\Controller\ControllerBase;

use Symfony\Component\HttpFoundation\JsonResponse;
use Drupal\Core\Session\AccountInterface;
use Drupal\Core\DependencyInjection\ContainerInjectionInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Drupal\Core\Password\PasswordInterface;

class ProfileUpdateController extends ControllerBase implements ContainerInjectionInterface {

    public function __construct(PasswordInterface $password_hasher, AccountInterface $account) {
        $this->passwordHasher = $password_hasher;
        $this->account = $account;
    }

    public static function create(ContainerInterface $container) {
        return new static(
            $container->get('password'),
            $container->get('current_user')
        );
    }

    public function updatePassword() {
        //global $user;
        $response = new \stdClass();
        //check the plain password with the hashed password from db
        $pass = $this->passwordHasher->check('secret', 'hashed_password_from_db');

        $response->password = $pass;
        // this will return true if the password matches or false vice-versa
        return new JsonResponse($response);
    }
}
?>