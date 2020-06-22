#!/usr/bin/env bash
# Upgrade ICRP to 8.8.6

sed -i.bak "s/8.6.13/8.7.12/g" composer.json
cat composer.json |grep core

composer update drupal/core --with-dependencies

composer require drupal/twig_tweak:^1.10 drupal/embed:^1.3 drupal/entity:^1.0 drupal/entity_embed:^1.0 drupal/extlink:^1.3
composer require drupal/crop:^2.0 drupal/devel:^2.1 drupal/ds:^3.5 drupal/ds_extras:^3.5 drupal/ds_switch_view_mode:^3.5 drupal/editor_advanced_link:^1.6
composer require drupal/email_registration:^1.0
composer require drupal/focal_point:^1.4 drupal/fontawesome:^2.15 drupal/honeypot:^1.30
composer require drupal/panelizer:^4.2 drupal/pathauto:^1.6 drupal/redirect:^1.5 drupal/rules:^3.0-alpha5@alpha drupal/search_exclude:^1.2

sed -i.bak "s/8.7.12/8.8.6/g" composer.json
composer update drupal/core --with-dependencies

composer require drupal/admin_toolbar:^2.2 drupal/admin_toolbar_tools:^2.2
composer require drupal/webform:^5.11 drupal/webform_ui:^5.11 drupal/webform_views:^5.0-alpha7@alpha
composer require drupal/ds:^3.6 drupal/entity_embed:^1.1 drupal/panelizer:^4.4 drupal/panels:^4.6 drupal/panels_ipe drupal/ds_switch_view_mode drupal/ds_extras
composer require drupal/pathauto:^1.8 drupal/token:^1.7 drupal/typed_data:^1.0-alpha4@alpha drupal/video_embed_field:^2.4 drupal/views_data_export:^1.0-rc1 drupal/views_templates:^1.11 drupal/yaml_content:^1.0-alpha7@alpha
composer require drupal/backup_migrate:^4.1 drupal/crop:^2.1
composer require drupal/ctools:^3.4 drupal/ctools_views drupal/ctools_block
composer require drupal/redirect:^1.6 drupal/honeypot:^2.0
composer require drupal/clientside_validation:^2.0 drupal/clientside_validation_jquery:^2.0
composer require drupal/metatag:^1.13 drupal/linkit:^5.0-beta11@beta

sed -i.bak "s/8.8.6/8.9.1/g" composer.json
composer update drupal/core --with-dependencies

composer require drupal/google_analytics:^3.1 drupal/field_permissions:^1.0 drupal/captcha:^1.1 drupal/bootstrap_layouts:^5.2 drupal/honeypot:^2.0

#This one breaks everything... AUTOLOGOUT BREAKS EVERYTHING...
#composer require drupal/autologout:^1.3

echo "Reset file permissions and owners for production"
echo "Remove drupal/views_data_export patch from composer.json"
echo "Go to Reports/Available Updates and click on Check Manually"



