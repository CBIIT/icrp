<?php

namespace Drupal\db_admin\EventSubscriber;

use Drupal\db_admin\Helpers\PDOBuilder;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\EventDispatcher\GenericEvent;

/**
 * Event Subscriber AddPartnerApplicationSubscriber.
 */
class AddPartnerApplicationSubscriber implements EventSubscriberInterface {

  private static function validateApplication($parameters) {
    $required_fields = [
        'id',
        'organization_name',
        'country',
        'email',
        'description_of_the_organization',
        'is_completed',
    ];

    foreach($required_fields as $field) {
      if (!array_key_exists($field, $parameters)
        || empty($parameters[$field])) {
        return false;
      }
    }

    $stmt = PDOBuilder::getConnection()->prepare('
      SELECT * FROM PartnerApplication
        WHERE OrgName = :name
        AND OrgCountry = :country
        AND OrgEmail = :email
        AND MissionDesc = :mission
    ');

    $fields = [
        ':name'     => $parameters['organization_name'],
        ':country'  => $parameters['country'],
        ':email'    => $parameters['email'],
        ':mission'  => $parameters['description_of_the_organization'],
    ];

    if ($stmt->execute($fields) && !empty($stmt->fetchAll())) {
      return false;
    }

    return true;
  }

  public static function saveApplication($parameters) {

    if (!self::validateApplication($parameters)) {
      return false;
    }

    $fields = [
        ':name'       => $parameters['organization_name'],
        ':country'    => $parameters['country'],
        ':email'      => $parameters['email'],
        ':mission'    => $parameters['description_of_the_organization'],
        ':incomeBand' => $parameters['income_band'],
    ];

    $stmt = PDOBuilder::getConnection()->prepare("
      INSERT INTO PartnerApplication
                  (OrgName, OrgCountry, OrgEmail, MissionDesc,  IncomeBand,  Status)
          VALUES  (:name,   :country,   :email,   :mission,     :incomeBand, 'NEW')
    ");

    return $stmt->execute($fields);
  }

  /**
   * @param \Symfony\Component\EventDispatcher\GenericEvent $event
   */
  public static function onAddPartnerApplication(GenericEvent $event) {
    self::saveApplication($event->getSubject());
  }

  /**
   * {@inheritdoc}

   * @return array
   */
  public static function getSubscribedEvents() {
    return [
      'db_admin.add_partner_application'  => 'onAddPartnerApplication',
    ];
  }
}
