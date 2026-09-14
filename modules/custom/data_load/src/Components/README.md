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

Run `npm run start:data-upload-tool` (port 4200), `npm run start:import-institutions`
(port 4201), or `npm run start:import-collaborators` (port 4202), then navigate to
the corresponding `http://localhost:<port>/`. The backend API is provided by the
Drupal `data_load` module, so API-driven flows require a running Drupal instance;
the UI itself renders without it.

## Build

Run `npm run build` to build all three applications. Production output is written
directly to `../assets/<app-name>/` (i.e. `modules/custom/data_load/src/assets/`),
which is referenced by fixed filename (`main.js`, `polyfills.js`, `styles.css`)
from `data_load.libraries.yml`. Output hashing is disabled for that reason; the
scripts are loaded as ES modules (`attributes: { type: module }` in the library
definitions).

The built artifacts are checked in. After changing anything under `src/`, rerun
`npm run build` and commit the regenerated assets together with the source change.
