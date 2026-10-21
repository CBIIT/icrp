# IcrpSearch

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
npm run build
```

The install and build lifecycle guards reject a different Node or npm version.
Use `npm ci`, not `npm install`, to preserve the committed dependency resolution.
Do not disable lifecycle scripts. Angular is pinned to **6.1.10**, CLI to **6.1.5**,
and the builder to **0.7.5**. This is an isolated legacy build toolchain, not a
supported server runtime; Node 12 and these Angular packages are end-of-life.
On Apple Silicon, Node 12 requires the x64 distribution and Rosetta, or use Docker.
Legacy dependencies can emit engine/deprecation warnings; the root versions are
enforced separately so those declarations do not require unrelated upgrades.

Alternatively, from the repository root, `sh modules/custom/db_search/src/build.sh`
builds with digest-pinned `node:12.22.12-bullseye-slim` on `linux/amd64` and `npm ci`.
Docker must be running. The Docker context excludes everything except this
workspace and the toolchain guard; it does not copy host `node_modules`.

Both commands write production artifacts to `../../assets/`, not `dist/`.
Drupal serves these committed files; deployment does not run Angular builds.
Commit the generated assets and bump `../../db_search.libraries.yml` when shipping
a change, then rebuild Drupal caches (`drush cr`) after deployment. The
NCIATWP-11502 bundle follow-up carries the source-only prerequisite from
[PR #68](https://github.com/CBIIT/icrp/pull/68); that PR should merge first.

For the clean-install hash comparison and the other two workspace commands, see
[the bundle build guide](../../../../../tools/README.md).

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
