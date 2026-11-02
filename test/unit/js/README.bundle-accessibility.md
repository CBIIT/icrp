# Generated-bundle Chrome regression fixtures

These local-only NCIATWP-11502 tests execute the generated applications in installed
Google Chrome, inspect the DOM and Chrome accessibility (AX) tree, and assert
intercepted request payloads. They are **not live DEV or authenticated integration
evidence**. No production sources or generated bundles are modified.

## Prerequisites

- Node.js **22 or later**, with native `fetch` and `WebSocket`.
- Installed **Google Chrome**. The default executable is:
  - macOS: `/Applications/Google Chrome.app/Contents/MacOS/Google Chrome`
  - Linux: `google-chrome` on `PATH`
  - Windows: `C:\Program Files\Google\Chrome\Application\chrome.exe`
  Set `CHROME_BIN` to override it. Chrome runs headlessly with an isolated profile,
  not the user's existing browser profile or the Copilot browser.
- Existing built assets in:
  - `modules/custom/db_search/assets` (Angular 6.1.10; search and review)
  - `modules/custom/db_admin/assets/partners` (Angular 7.2.16)
  - `modules/custom/db_admin/assets/funding-organizations` (Angular 7.2.16)
  - `modules/custom/data_load/src/assets/data-upload-tool` (Angular 22.1.5 ESM)
- The repository's existing CSS, jQuery and map/theme scripts for
  `dom-rendering.html`.
- Search/review need the production external dependency **D3 4.10.2**. By default,
  the Node runner makes one public GET to
  `https://cdnjs.cloudflare.com/ajax/libs/d3/4.10.2/d3.min.js`, with a 15-second
  timeout, then serves the bytes locally. Set `D3_PATH` to an existing local copy
  for offline execution.
- Optional `--xlsx` uses **already-installed `exceljs`** from
  `modules/custom/data_load/src/Components/node_modules` (tested with 4.4.0).
  Without this flag, ExcelJS is not required.

No Playwright, Puppeteer, npm installation, new test framework, or production
dependency change is needed. The runner does not rebuild assets or install anything.

## Commands and flags

From the repository root:

```sh
# All bundle scenarios plus the existing 24-test DOM fixture; stdout only.
node test/unit/js/run-bundle-accessibility.mjs

# Focused upload test, including synthetic XLSX rejection and CSV conversion.
node test/unit/js/run-bundle-accessibility.mjs --app upload --xlsx

# All scenarios including XLSX; explicitly persist evidence outside the checkout.
node test/unit/js/run-bundle-accessibility.mjs --xlsx \
  --report /absolute/path/to/existing/artifacts/bundle-results.json

# Offline search-only run with an existing local D3 file.
D3_PATH=/absolute/path/to/d3-4.10.2.min.js \
  node test/unit/js/run-bundle-accessibility.mjs --app search
```

Exactly these CLI flags are supported:

| Flag | Meaning |
| --- | --- |
| `--app NAME` | Run only `partners`, `funding`, `upload`, `search`, `review`, or `dom`. Omit to run all six. |
| `--xlsx` | Add XLSX selection/rejection and use XLSX-derived CSV for upload preview. Valid with all apps or `--app upload`. |
| `--report PATH` | Write JSON evidence to the explicit path; relative paths resolve against the invoking working directory, and absolute paths are accepted. Its parent directory must already exist. An existing file is overwritten. |
| `--help` | Print usage without launching Chrome. |

The only configuration environment variables are `CHROME_BIN` and `D3_PATH`.
Without `--report`, results go to stdout and **no report file is created**.
The runner starts a loopback-only server and a test-owned Chrome profile under
`test/.bundle-chrome-<pid>`, then stops its helpers and removes that profile.
It uses an approximately 180-second execution budget plus bounded cleanup.
Exit status is zero on success and nonzero on failures or invalid arguments.
JSON evidence includes timestamps, browser/Angular versions, loaded-script hashes,
assertions, relevant AX nodes, intercepted requests, and limitations.

## Coverage and limitations

- Partner, non-partner and funding-organization add/update controls and synthetic
  save payloads; conditional funding/partner-organization labels.
- Search labels and enabled/disabled location inputs, Include Future Years,
  funding/CSO checkbox groups and their AX ancestry/checked state, sponsor
  regrouping, award-chart currency year, chart SVG rendering, and pagination.
- Review upload selection and all six export options on both search and review.
- CSV selection, synthetic load preview and reset, plus the existing DOM fixture.

**CSV is not XLSX or a backend upload.** The current upload form accepts `.csv`
only. `--xlsx` creates a real synthetic XLSX in memory with installed ExcelJS,
reopens it locally, and checks that selecting it in the actual browser form is
rejected by validation with Load disabled and no API request. ExcelJS converts
that workbook to CSV for the subsequent supported file-selection test. The preview
response is still mocked: these tests do not verify server-side workbook parsing,
validation, persistence, integrity checking, or import. No real data is used.

**Exports:** tests verify each menu option and the endpoint/search/upload/currency
parameters. Responses use a same-document synthetic URL; downloaded file contents,
spreadsheet validity, chart export contents, and backend generation are not tested.

**Accessibility:** Chrome AX names, roles, group ancestry and checked states are
partial evidence, not auditory screen-reader interaction, a complete keyboard audit,
or accessibility conformance. Tree filters remain named groups of checkboxes, not
ARIA tree widgets. Map Coordinates has individually named Latitude/Longitude
inputs but **no fieldset/legend or named group**. The existing upload file accessor
also leaves the native file input enabled after Load, although Load is disabled.
These pre-existing behaviors are documented, not repaired by the fixture.

Application API calls are intercepted in memory, including synthetic save/load
POSTs. Unknown requests, external browser requests, import, synchronization,
deletion, and email are not allowed. The HTTP server accepts only allowlisted
local GETs, and Chrome request interception supplies another boundary. No real
backend writes, imports, authenticated external testing, deployment, or merge occurs.
