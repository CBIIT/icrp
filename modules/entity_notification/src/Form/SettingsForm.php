<?php

namespace Drupal\entity_notification\Form;

use Drupal\Core\Config\ConfigFactoryInterface;
use Drupal\Core\DependencyInjection\ContainerInjectionInterface;
use Drupal\Core\Entity\ContentEntityInterface;
use Drupal\Core\Entity\EntityTypeInterface;
use Drupal\Core\Entity\EntityTypeManagerInterface;
use Drupal\Core\Form\ConfigFormBase;
use Drupal\Core\Form\FormStateInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;

class SettingsForm extends ConfigFormBase implements ContainerInjectionInterface {

  /**
   * The entity type manager.
   *
   * @var \Drupal\Core\Entity\EntityTypeManagerInterface
   */
  protected $entityTypeManager;

  /**
   * {@inheritdoc}
   */
  public function __construct(ConfigFactoryInterface $config_factory, EntityTypeManagerInterface $entity_type_manager) {
    parent::__construct($config_factory);

    $this->entityTypeManager = $entity_type_manager;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container) {
    return new static(
      $container->get('config.factory'),
      $container->get('entity_type.manager')
    );
  }

  /**
   * {@inheritdoc}
   */
  protected function getEditableConfigNames() {
    return ['entity_notification.settings'];
  }

  /**
   * {@inheritdoc}
   */
  public function getFormId() {
    return 'entity_notification__settings';
  }

  /**
   * @return \Drupal\Core\Entity\EntityTypeInterface[]
   */
  protected function getEntityTypes() {
    $definitions = array_filter($this->entityTypeManager->getDefinitions(), function (EntityTypeInterface $entity_type) {
      return $entity_type->isSubclassOf(ContentEntityInterface::class);
    });

    return $definitions;
  }

  /**
   * {@inheritdoc}
   */
  public function buildForm(array $form, FormStateInterface $form_state) {
    $form = parent::buildForm($form, $form_state);

    $definitions = $this->getEntityTypes();

    $form['configuration'] = [
      '#type' => 'vertical_tabs',
      '#weight' => 99,
    ];

    $config = $this->config('entity_notification.settings');
    foreach ($definitions as $entity_type_id => $entity_type) {
      foreach (['create', 'update', 'delete'] as $operation) {
        $settings = $config->get('configuration.' . $entity_type_id . '.' . $operation);
        $settings = $settings ?: [
          'to' => '',
          'subject' => '',
          'body' => '',
        ];
        $form[$entity_type_id . '__' . $operation] = [
          '#type' => 'details',
          '#title' => $this->t('@label (@operation)', ['@label' => $entity_type->getLabel(), '@operation' => $operation]),
          '#group' => 'configuration',
        ];

        $form[$entity_type_id . '__' . $operation][$entity_type_id . '__' . $operation . '__' . 'enable'] = [
          '#type' => 'checkbox',
          '#title' => $this->t('Enable notifications'),
          '#default_value' => !empty($settings['to']),
        ];

        $form[$entity_type_id . '__' . $operation][$entity_type_id . '__' . $operation . '__' . 'to'] = [
          '#type' => 'textfield',
          '#title' => $this->t('To'),
          '#default_value' => $settings['to'],
        ];

        $form[$entity_type_id . '__' . $operation][$entity_type_id . '__' . $operation . '__' . 'subject'] = [
          '#type' => 'textfield',
          '#title' => $this->t('Subject'),
          '#default_value' => $settings['subject'],
        ];

        $form[$entity_type_id . '__' . $operation][$entity_type_id . '__' . $operation . '__' . 'body'] = [
          '#type' => 'textarea',
          '#title' => $this->t('Body'),
          '#default_value' => $settings['body'],
        ];

        $form[$entity_type_id . '__' . $operation][$entity_type_id . '__' . $operation . '__' . 'token_help'] = [
          '#theme' => 'token_tree_link',
          '#token_types' => [$entity_type_id],
        ];
      }
    }

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {
    parent::submitForm($form, $form_state);

    $definitions = $this->getEntityTypes();
    $config = $this->config('entity_notification.settings');
    foreach (array_keys($definitions) as $entity_type_id) {
      foreach (['create', 'update', 'delete'] as $operation) {
        if (!empty($form_state->getValue($entity_type_id . '__' . $operation . '__' . 'enable'))) {
          $config->set('configuration.' . $entity_type_id . '.' . $operation, [
            'to' => $form_state->getValue($entity_type_id . '__' . $operation . '__' . 'to'),
            'subject' => $form_state->getValue($entity_type_id . '__' . $operation . '__' . 'subject'),
            'body' => $form_state->getValue($entity_type_id . '__' . $operation . '__' . 'body'),
          ]);
        }
        else {
          $config->set('configuration.' . $entity_type_id . '.' . $operation, []);
        }
      }
    }
    $config->save();
  }

}
