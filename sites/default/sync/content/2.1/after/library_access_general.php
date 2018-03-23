<?php

// ensure all users have "General" access to library

$uids = \Drupal::entityQuery('user')->execute();
$users = \Drupal\user\Entity\User::loadMultiple($uids);

foreach($users as $user) {
    $field_library_access = $user->get('field_library_access');
    $library_access = array_map(function($record) {
        return $record['value'];
    }, $field_library_access->getValue());

    // ensure each user has general access to library
    if (!in_array('general', $library_access)) {
        $library_access[] = 'general';
        $user->set('field_library_access', $library_access);
        $user->save();
    }
}