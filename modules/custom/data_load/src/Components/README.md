# Components

Angular workspace containing the three ICRP data-load front-end applications:

- `data-upload-tool` (bootstraps `<icrp-data-upload-tool>`, served by Drupal at `/DataUploadTool`)
- `import-institutions` (bootstraps `<icrp-import-institutions>`, served at `/ImportInstitutions`)
- `import-collaborators` (bootstraps `<icrp-import-collaborators>`, served at `/ImportCollaborators`)

All three applications share the source tree under `src/` and differ only in their
entry point (`src/data-upload-tool.ts`, `src/import-institutions.ts`,
`src/import-collaborators.ts`).

Built with Angular 22 / Angular CLI 22.

## Development server

Use the pinned Node/npm versions and clean install below before starting a server.

Run `npm run start:data-upload-tool` (port 4200), `npm run start:import-institutions`
(port 4201), or `npm run start:import-collaborators` (port 4202), then navigate to
the corresponding `http://localhost:<port>/`. The backend API is provided by the
Drupal `data_load` module, so API-driven flows require a running Drupal instance;
the UI itself renders without it.

## Build

Use **Node.js 22.22.3 and npm 11.19.0**. With
[nvm](https://github.com/nvm-sh/nvm) loaded, run from this directory:

```sh
nvm install
nvm use
npm install --global npm@11.19.0
node --version # v22.22.3
npm --version  # 11.19.0
npm ci --no-audit --no-fund
npm run build:data-upload-tool
```

The explicit npm install updates only the selected nvm Node installation.
The engine checks and install/build lifecycle guards reject other versions.
Do not disable lifecycle scripts. npm 11.19.0 avoids an npm 10.9.8 optional-peer
resolver crash encountered when generating this lockfile. Use `npm ci`, not a
fresh dependency resolution, for subsequent builds.

Angular framework/compiler packages are pinned to **22.1.5**, matching all three
committed applications; CLI and the builder are **22.1.7** and ngx-bootstrap is
**22.0.0**. Keep the framework packages aligned: do not rebuild one application
with a newer runtime while its siblings still ship the old one.

The targeted command above rebuilds only `data-upload-tool`; unchanged sibling
assets must not be rebuilt for the NCIATWP-11502 follow-up.
Use `npm run build` only when intentionally rebuilding all three applications,
or the individual `build:import-institutions` / `build:import-collaborators` scripts.
Production output is written
directly to `../assets/<app-name>/` (i.e. `modules/custom/data_load/src/assets/`),
which is referenced by fixed filename (`main.js`, `polyfills.js`, `styles.css`)
from `data_load.libraries.yml`. Output hashing is disabled for that reason; the
scripts are loaded as ES modules (`attributes: { type: module }` in the library
definitions).

The built artifacts are checked in and deployment does not rebuild them. After
source changes, rebuild the affected applications, commit their generated assets,
bump the corresponding `../../data_load.libraries.yml` versions, and run `drush cr`
after deployment. The NCIATWP-11502 bundle rebuild uses the source fixes merged
into `dev` via [PR #68](https://github.com/CBIIT/icrp/pull/68).
See [the bundle build guide](../../../../../tools/README.md) for clean-install
hash comparisons and verification limits.
