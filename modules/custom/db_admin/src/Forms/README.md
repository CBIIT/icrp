# AdminForms

This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 6.1.3.

## Development server

Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`. The app will automatically reload if you change any of the source files.

## Code scaffolding

Run `ng generate component component-name` to generate a new component. You can also use `ng generate directive|pipe|service|class|guard|interface|enum|module`.

## Build

From this directory, run
`npm run build -- --project partners` or
`npm run build -- --project fundingOrganizations` for the corresponding form.
Production artifacts are written to `../../assets/partners/` and
`../../assets/funding-organizations/`, not `dist/`.

For NCIATWP-11502, rebuilding and publishing the bundles is deferred to a separate
change; source edits alone do not update the served UI. When publishing rebuilt
assets, bump the affected library version in `../../db_admin.libraries.yml` and
rebuild Drupal caches (`drush cr`) after deployment so the updated controls and
labels reach the browser.

## Running unit tests

Run `ng test` to execute the unit tests via [Karma](https://karma-runner.github.io).

## Running end-to-end tests

Run `ng e2e` to execute the end-to-end tests via [Protractor](http://www.protractortest.org/).

## Further help

To get more help on the Angular CLI use `ng help` or go check out the [Angular CLI README](https://github.com/angular/angular-cli/blob/master/README.md).
