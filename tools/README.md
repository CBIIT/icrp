# Committed Angular bundles

Drupal serves the committed assets below. The deployment Dockerfile copies them;
it does not install npm dependencies or build Angular.

| Workspace under `modules/custom/` | Node | npm | Angular runtime | CLI / builder |
| --- | --- | --- | --- | --- |
| `db_search/src/angular` | 12.22.12 | 6.14.16 | 6.1.10 | 6.1.5 / 0.7.5 |
| `db_admin/src/Forms` | 12.22.12 | 6.14.16 | 7.2.16 | 7.3.10 / 0.13.10 |
| `data_load/src/Components` | 22.22.3 | 11.19.0 | 22.1.5 | 22.1.7 / 22.1.7 |

Each workspace has a committed lockfile, `.nvmrc`, `engines`, `packageManager`,
and install/build lifecycle checks. Load nvm, run `nvm install && nvm use` inside
each workspace, and select the listed npm version before running commands.
Node 12 includes npm 6.14.16; for Node 22 use `npm install --global npm@11.19.0`
within the selected nvm installation. Never use `--ignore-scripts` or an unpinned
`npx ng`. If a shell exports both `path` and `PATH`, unset the lowercase `path`
before selecting Node; npm can otherwise put the machine's Node first.

## Rebuild only the affected applications

From each workspace, under its toolchain:

```sh
# db_search/src/angular
npm ci --no-audit --no-fund
npm run build

# db_admin/src/Forms
npm ci --no-audit --no-fund
npm run build -- --project partners
npm run build -- --project fundingOrganizations

# data_load/src/Components
npm ci --no-audit --no-fund
npm run build:data-upload-tool
```

The legacy build script expands to `ng build --prod --progress false
--output-hashing none` with the optional project selector. The upload script
expands to `ng build data-upload-tool` using its production configuration and
fixed output filenames. Do not rebuild unchanged admin or upload siblings.

Node 12 and Angular 6/7 are end-of-life and retained only for this isolated build,
not recommended for serving applications. Use x64 Node 12 with Rosetta on Apple
Silicon. Search also has `sh modules/custom/db_search/src/build.sh`, which uses
the exact Node image tag/digest and `npm ci` on `linux/amd64`. Native builds do not require
Docker. The Docker path requires a running daemon.

## Repeatability

After building, run this from the repository root:

```sh
find modules/custom/db_search/assets \
  modules/custom/db_admin/assets/partners \
  modules/custom/db_admin/assets/funding-organizations \
  modules/custom/data_load/src/assets/data-upload-tool \
  -type f -exec shasum -a 256 {} + | LC_ALL=C sort > /tmp/icrp-bundles-first.sha256
```

Run all three clean installs and four builds again with the same Node/npm
versions. For a cold upload build, run `npm run ng -- cache clean` in that workspace
before building. Repeat the command with `/tmp/icrp-bundles-second.sha256` as
the output and compare:

```sh
diff -u /tmp/icrp-bundles-first.sha256 /tmp/icrp-bundles-second.sha256
git diff -- modules/custom/data_load/src/assets/import-institutions \
  modules/custom/data_load/src/assets/import-collaborators \
  modules/custom/db_admin/assets/institutions \
  modules/custom/db_admin/assets/merge-institutions
```

Both commands should print nothing. Compare the entire output directories, not
only `main.js`; index files, runtime, polyfills, CSS and licenses are also shipped.
Do not hand-edit generated files to make a comparison pass. Update lockfiles only
as an intentional dependency change, then repeat the clean-install check.

## Provenance and release verification

The NCIATWP-11502 follow-up is based on `dev` at
`eb9e68dd4881613e411234176327537c3ef48c08`, carrying the cumulative source-only
change from [PR #68](https://github.com/CBIIT/icrp/pull/68) through
`2ca877420af11515e0566f11b97655079c2dcfda` as a separate prerequisite commit.
Merge #68 first. The source overlap remains until `dev` contains that prerequisite.
The upload-wizard follow-on is not included.

The previous committed bundles embed Angular 6.1.10, 7.2.16 and 22.1.5,
respectively. No contemporaneous lockfiles or full original build environment
were committed with them; these lockfiles establish a repeatable resolution,
not a claim to recover the original complete dependency trees. Runtime versions
are preserved, and changes in minified identifier allocation can still spread
beyond the changed templates.

The follow-up was built natively on macOS (x64 Node 12 under Rosetta; arm64
Node 22). Two clean installs/builds produced identical SHA-256 hashes for all
27 output files; the upload build also cleared Angular's cache. Only the four
target `main.js` files change in Git: runtime, polyfills, styles, index, licenses,
and sibling bundles remain unchanged. Docker execution was not verified because
the local daemon was unavailable.

Control builds of unchanged `dev` source with the new locks reproduced the
committed Search and upload `main.js` byte-for-byte. The admin control bundles
each grew by 780 bytes; their URL parser now resolves to `url-parse` 1.5.10 under
the existing `^1.4.3` range. Its parser implementation and related Webpack module
identifiers differ from the historical artifacts. The full historical resolution
is unknown; do not downgrade to an inferred old parser merely to shrink a diff.
The actual accessibility edits add 1,218 bytes to Search, 730 bytes to partners,
346 bytes to funding organizations and 306 bytes to upload versus those controls.

Before release, verify with a DEV manager account: partner, non-partner and
funding-organization add/update; sample workbook upload; Search Include Future
Years; award-chart currency year; review page and every export option. Check the
Funding Organizations and CSO Research Areas tree groups and Map Coordinates
with a screen reader. Local synthetic fixtures and Chrome accessibility-tree
inspection are not authenticated DEV or auditory screen-reader evidence.
These commands neither deploy nor authorize real data writes. Record outstanding
manager checks explicitly, bump only the affected Drupal library versions and
clear Drupal caches after the separately approved deployment.

For safe local coverage of the committed bundles, see
[the Chrome fixture guide](../test/unit/js/README.bundle-accessibility.md).
From the repository root, with Node >=22, Chrome and the upload workspace
dependencies installed, run `node test/unit/js/run-bundle-accessibility.mjs --xlsx`.
The synthetic XLSX case verifies the existing CSV-only validation rejects XLSX
and previews its CSV conversion using a mocked response; it is not an import.
