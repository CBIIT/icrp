# AdminForms

This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 6.1.3.

## Development server

Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`. The app will automatically reload if you change any of the source files.

## Code scaffolding

Run `ng generate component component-name` to generate a new component. You can also use `ng generate directive|pipe|service|class|guard|interface|enum|module`.

## Build

Use **Node.js 12.22.12 and npm 6.14.16** (bundled with that Node release).
From this directory, with [nvm](https://github.com/nvm-sh/nvm) loaded:

```sh
nvm install
nvm use
node --version # v12.22.12
npm --version  # 6.14.16
npm ci --no-audit --no-fund
npm run build -- --project partners
npm run build -- --project fundingOrganizations
```

Install and build lifecycle guards reject other Node/npm versions. Use `npm ci`
with the committed lockfile, and do not disable lifecycle scripts. Angular is
pinned to **7.2.16**, CLI to **7.3.10**, and the builder to **0.13.10**.
Node 12/Angular 7 are end-of-life: use this toolchain only for isolated legacy
builds, not as a server runtime. Apple Silicon needs Node's x64 distribution and
Rosetta. Some legacy transitive packages declare different engine ranges and
emit warnings; root versions are enforced without upgrading unrelated packages.

Production artifacts are written to `../../assets/partners/` and
`../../assets/funding-organizations/`, not `dist/`.
These commands intentionally do not rebuild `institutions` or `mergeInstitutions`.

Drupal serves committed assets; deployment does not rebuild them. When publishing
rebuilt assets, bump the affected library version in `../../db_admin.libraries.yml`
and rebuild Drupal caches (`drush cr`) after deployment. The NCIATWP-11502 bundle
rebuild uses the source fixes merged into `dev` via
[PR #68](https://github.com/CBIIT/icrp/pull/68).

See [the bundle build guide](../../../../../tools/README.md) for the clean-install
hash comparison.

## Running unit tests

Run `ng test` to execute the unit tests via [Karma](https://karma-runner.github.io).

## Running end-to-end tests

Run `ng e2e` to execute the end-to-end tests via [Protractor](http://www.protractortest.org/).

## Further help

To get more help on the Angular CLI use `ng help` or go check out the [Angular CLI README](https://github.com/angular/angular-cli/blob/master/README.md).
