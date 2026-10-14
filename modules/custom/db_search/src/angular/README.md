# IcrpSearch

This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 6.1.3.

## Development server

Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`. The app will automatically reload if you change any of the source files.

## Code scaffolding

Run `ng generate component component-name` to generate a new component. You can also use `ng generate directive|pipe|service|class|guard|interface|enum|module`.

## Build

Use Node.js 16 for this legacy Angular CLI workspace. From this directory, run
`npm run build` to write the production artifacts to `../../assets/`, not `dist/`.
Commit rebuilt assets with source changes, bump the version in
`../../db_search.libraries.yml`, and rebuild Drupal caches (`drush cr`) after
deployment.

Search labels must remain associated with the inner native inputs of
`ui-select`, including when selected values remove the placeholder or a
location filter switches between disabled and enabled inputs. Verify both
states, the ORCiD and last-name fields, chart currency rates, and results-per-page
controls after rebuilding.

## Running unit tests

Run `ng test` to execute the unit tests via [Karma](https://karma-runner.github.io).

## Running end-to-end tests

Run `ng e2e` to execute the end-to-end tests via [Protractor](http://www.protractortest.org/).

## Further help

To get more help on the Angular CLI use `ng help` or go check out the [Angular CLI README](https://github.com/angular/angular-cli/blob/master/README.md).
