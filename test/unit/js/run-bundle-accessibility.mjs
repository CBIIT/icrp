#!/usr/bin/env node
/**
 * Local generated-bundle tests; Node >=22 and installed Google Chrome.
 *   node test/unit/js/run-bundle-accessibility.mjs
 *   node test/unit/js/run-bundle-accessibility.mjs --app upload --xlsx
 * --help lists flags; README.bundle-accessibility.md explains coverage and prerequisites.
 * CHROME_BIN overrides the installed Chrome path. D3_PATH supplies an offline copy of the
 * production external dependency (D3 4.10.2); otherwise one bounded public GET fetches it.
 * No browser API request reaches a backend. Profiles are isolated under test/ and removed.
 */
import {createServer} from 'node:http';
import {spawn} from 'node:child_process';
import {readFile, writeFile, mkdir, rm, realpath} from 'node:fs/promises';
import {fileURLToPath} from 'node:url';
import path from 'node:path';
import {createHash} from 'node:crypto';
import {createRequire} from 'node:module';
import assert from 'node:assert/strict';

const root = path.resolve(fileURLToPath(new URL('../../../', import.meta.url)));
const args = process.argv.slice(2);
let selected;
let reportPath;
let withXlsx = false;
const usage = `Usage: node test/unit/js/run-bundle-accessibility.mjs [options]
  --app partners|funding|upload|search|review|dom  Run one app (default: all six).
  --xlsx       Also test synthetic XLSX rejection, then XLSX-derived CSV preview.
               Uses already-installed ExcelJS in the upload workspace.
               Valid with all apps or --app upload.
  --report PATH  Write JSON to this explicit path (relative to cwd or absolute).
                 Parent directory must exist; existing file is overwritten.
  --help       Print this help without starting Chrome.
Default output is stdout only; no report file is created.
Environment: CHROME_BIN (installed Chrome), D3_PATH (offline D3 4.10.2).
Requires Node >=22. See README.bundle-accessibility.md for coverage limitations.`;
for (let i = 0; i < args.length; i++) {
  const option = args[i];
  if (option === '--help') { console.log(usage); process.exit(0); }
  if (option === '--xlsx') { withXlsx = true; continue; }
  if (option === '--app' || option === '--report') {
    const value = args[++i];
    assert(value && !value.startsWith('--'), option + ' requires a value\n' + usage);
    if (option === '--app') selected = value;
    else reportPath = value;
  } else throw new Error('Unknown option: ' + option + '\n' + usage);
}
const apps = ['partners', 'funding', 'upload', 'search', 'review', 'dom'];
assert(!selected || apps.includes(selected), 'Unknown --app');
assert(!withXlsx || !selected || selected === 'upload', '--xlsx requires all apps or --app upload');
if (reportPath) reportPath = path.resolve(reportPath);
assert(typeof WebSocket === 'function', 'Use Node >=22 (native WebSocket required)');
const chromeBin = process.env.CHROME_BIN || (process.platform === 'darwin'
  ? '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
  : process.platform === 'win32'
    ? 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe' : 'google-chrome');
const profile = path.join(root, 'test', `.bundle-chrome-${process.pid}`);
const report = {
  coverage: 'Synthetic local Chrome fixture; not DEV or auditory screen-reader evidence',
  startedAt: new Date().toISOString(), browser: null, assets: {}, scenarios: [], failures: [],
  limitations: [], blockedNetwork: [], consoleErrors: []
};
let chrome;
let server;
let browser;
let stderr = '';
const pause = ms => new Promise(resolve => setTimeout(resolve, ms));
const deadline = Date.now() + 180_000;
const hash = bytes => createHash('sha256').update(bytes).digest('hex');

class CDP {
  constructor(socket) {
    this.socket = socket;
    this.next = 0;
    this.pending = new Map();
    this.listeners = new Map();
    socket.addEventListener('message', ({data}) => {
      const message = JSON.parse(data);
      if (message.id) {
        const pending = this.pending.get(message.id);
        if (!pending) return;
        clearTimeout(pending.timer);
        this.pending.delete(message.id);
        message.error ? pending.reject(new Error(JSON.stringify(message.error))) : pending.resolve(message.result);
      } else {
        for (const listener of this.listeners.get(message.method) || []) {
          Promise.resolve(listener(message.params, message.sessionId)).catch(error => {
            report.failures.push('CDP event: ' + error.message);
          });
        }
      }
    });
  }
  static async connect(url) {
    const socket = new WebSocket(url);
    await new Promise((resolve, reject) => {
      const timer = setTimeout(() => reject(new Error('Chrome WebSocket connection timeout')), 10_000);
      socket.addEventListener('open', () => { clearTimeout(timer); resolve(); }, {once: true});
      socket.addEventListener('error', () => { clearTimeout(timer); reject(new Error('Chrome WebSocket error')); }, {once: true});
    });
    return new CDP(socket);
  }
  on(method, handler) {
    this.listeners.set(method, [...this.listeners.get(method) || [], handler]);
  }
  send(method, params = {}, sessionId) {
    return new Promise((resolve, reject) => {
      const id = ++this.next;
      const timer = setTimeout(() => {
        this.pending.delete(id);
        reject(new Error('CDP timeout: ' + method));
      }, method === 'Browser.close' || method === 'SystemInfo.getProcessInfo'
        ? 5000 : Math.max(1, Math.min(15_000, deadline - Date.now())));
      this.pending.set(id, {resolve, reject, timer});
      this.socket.send(JSON.stringify({id, method, params, ...(sessionId ? {sessionId} : {})}));
    });
  }
  close() {
    for (const {timer, reject} of this.pending.values()) {
      clearTimeout(timer);
      reject(new Error('Chrome connection closed'));
    }
    this.pending.clear();
    this.socket.close();
  }
}

try {
  let workbookFixture;
  if (withXlsx) {
    const uploadRequire = createRequire(path.join(root, 'modules/custom/data_load/src/Components/package.json'));
    let ExcelJS;
    try { ExcelJS = uploadRequire('exceljs'); } catch {
      throw new Error('--xlsx requires the existing upload workspace ExcelJS dependency; restore that workspace or omit --xlsx. No dependency is installed by this runner.');
    }
    const workbook = new ExcelJS.Workbook();
    workbook.addWorksheet('Synthetic').addRows([
      ['AwardCode', 'Title', 'Funding'], ['FIX-1', 'Synthetic CSV project', 100]
    ]);
    const xlsx = Buffer.from(await workbook.xlsx.writeBuffer());
    const reopened = new ExcelJS.Workbook();
    await reopened.xlsx.load(xlsx);
    assert.equal(reopened.getWorksheet('Synthetic').getCell('B2').value, 'Synthetic CSV project');
    const csv = Buffer.from(await reopened.csv.writeBuffer({sheetName: 'Synthetic'}));
    workbookFixture = {base64: xlsx.toString('base64'), csv: csv.toString('utf8')};
    report.workbook = {
      generator: 'Existing upload workspace ExcelJS ' + uploadRequire('exceljs/package.json').version,
      synthetic: true, generatedInMemory: true, xlsxBytes: xlsx.length,
      xlsxSha256: hash(xlsx), csvSha256: hash(csv),
      coverage: 'Real synthetic XLSX generated and reopened locally; browser rejects XLSX and previews its CSV conversion using a mocked backend response.'
    };
  }
  let d3;
  if (!selected || ['search', 'review'].includes(selected)) {
    if (process.env.D3_PATH) d3 = await readFile(process.env.D3_PATH);
    else {
      const response = await fetch('https://cdnjs.cloudflare.com/ajax/libs/d3/4.10.2/d3.min.js', {signal: AbortSignal.timeout(15_000)});
      assert(response.ok, 'Could not retrieve production D3; set D3_PATH for offline execution');
      d3 = Buffer.from(await response.arrayBuffer());
    }
    report.assets['external/d3-4.10.2.min.js'] = hash(d3);
  }
  const permitted = [
    '/test/unit/js/bundle-accessibility.html', '/test/unit/js/dom-rendering.html',
    '/themes/bootstrap_subtheme/css/ext/', '/themes/bootstrap_subtheme/css/508_fixes.css',
    '/themes/bootstrap_subtheme/js/script.js', '/libraries/fullcalendar/lib/jquery.min.js',
    '/modules/custom/db_map/src/assets/db_layer_map.js',
    '/modules/custom/db_search/assets/', '/modules/custom/db_admin/assets/partners/',
    '/modules/custom/db_admin/assets/funding-organizations/',
    '/modules/custom/data_load/src/assets/data-upload-tool/'
  ];
  function allowed(pathname) {
    return pathname === '/__fixture__/d3.min.js' || pathname === '/favicon.ico' ||
      permitted.some(prefix => prefix.endsWith('/') ? pathname.startsWith(prefix) : pathname === prefix);
  }
  server = createServer(async (req, res) => {
    try {
      const pathname = path.posix.normalize(decodeURIComponent(new URL(req.url, 'http://127.0.0.1').pathname));
      if (req.method !== 'GET' || !allowed(pathname)) {
        report.blockedNetwork.push({method: req.method, path: pathname});
        res.writeHead(403).end('Fixture server refuses this request');
        return;
      }
      if (pathname === '/favicon.ico') { res.writeHead(204).end(); return; }
      let content;
      if (pathname === '/__fixture__/d3.min.js') content = d3;
      else {
        const filename = await realpath(path.join(root, pathname));
        assert(filename.startsWith(root + path.sep), 'Path escapes worktree');
        content = await readFile(filename);
        if (pathname.endsWith('.js') || pathname.endsWith('.html')) report.assets[pathname] = hash(content);
      }
      const type = {'.html': 'text/html', '.js': 'text/javascript', '.css': 'text/css', '.woff': 'font/woff', '.woff2': 'font/woff2', '.ttf': 'font/ttf'}[path.extname(pathname)] || 'application/octet-stream';
      res.writeHead(200, {'Content-Type': type, 'Cache-Control': 'no-store'}).end(content);
    } catch (error) {
      res.writeHead(404).end(error.message);
    }
  });
  await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
  const origin = `http://127.0.0.1:${server.address().port}`;
  await mkdir(profile);
  chrome = spawn(chromeBin, [
    '--headless=new', '--remote-debugging-port=0', '--remote-debugging-address=127.0.0.1',
    `--user-data-dir=${profile}`, '--no-first-run', '--no-default-browser-check',
    '--disable-background-networking', '--disable-component-update', '--disable-sync',
    '--disable-domain-reliability', '--disable-extensions', '--metrics-recording-only',
    '--safebrowsing-disable-auto-update', '--no-proxy-server',
    '--host-resolver-rules=MAP * ~NOTFOUND, EXCLUDE 127.0.0.1',
    '--window-size=1440,1200', 'about:blank'
  ], {stdio: ['ignore', 'ignore', 'pipe']});
  chrome.stderr.on('data', chunk => { stderr = (stderr + chunk).slice(-12000); });
  let launchError;
  chrome.on('error', error => { launchError = error; });
  let portData;
  const launchDeadline = Date.now() + 15_000;
  while (!portData) {
    if (launchError) throw launchError;
    if (chrome.exitCode !== null || Date.now() > launchDeadline) throw new Error('Chrome did not start: ' + stderr);
    try { portData = (await readFile(path.join(profile, 'DevToolsActivePort'), 'utf8')).trim().split('\n'); } catch { await pause(100); }
  }
  browser = await CDP.connect(`ws://127.0.0.1:${portData[0]}${portData[1]}`);
  report.browser = await browser.send('Browser.getVersion');
  console.log('Installed Chrome:', report.browser.product);
  const sessions = new Set();
  browser.on('Fetch.requestPaused', async (event, sessionId) => {
    if (!sessions.has(sessionId)) return;
    const url = new URL(event.request.url);
    const permittedRequest = event.request.method === 'GET' && url.origin === origin && allowed(decodeURIComponent(url.pathname));
    if (permittedRequest) await browser.send('Fetch.continueRequest', {requestId: event.requestId}, sessionId);
    else {
      report.blockedNetwork.push({method: event.request.method, url: event.request.url});
      await browser.send('Fetch.failRequest', {requestId: event.requestId, errorReason: 'BlockedByClient'}, sessionId);
    }
  });
  browser.on('Runtime.consoleAPICalled', (event, sessionId) => {
    if (sessions.has(sessionId) && event.type === 'error') report.consoleErrors.push(event.args.map(arg => arg.description || arg.value).join(' '));
  });
  for (const app of selected ? [selected] : apps) {
    if (Date.now() > deadline) throw new Error('Fixture exceeded 180-second total bound');
    const {targetId} = await browser.send('Target.createTarget', {url: 'about:blank'});
    const {sessionId} = await browser.send('Target.attachToTarget', {targetId, flatten: true});
    sessions.add(sessionId);
    const send = (method, params) => browser.send(method, params, sessionId);
    const evaluate = async expression => {
      const response = await send('Runtime.evaluate', {expression, awaitPromise: true, returnByValue: true});
      if (response.exceptionDetails) throw new Error(response.exceptionDetails.exception?.description || response.exceptionDetails.text);
      return response.result.value;
    };
    try {
      await send('Page.enable');
      await send('Runtime.enable');
      await send('Accessibility.enable');
      await send('Network.enable');
      await send('Network.setBypassServiceWorker', {bypass: true});
      await send('Fetch.enable', {patterns: [{urlPattern: 'http://*'}, {urlPattern: 'https://*'}]});
      const url = app === 'dom' ? '/test/unit/js/dom-rendering.html' :
        '/test/unit/js/bundle-accessibility.html?app=' + app + (withXlsx && app === 'upload' ? '&xlsx=1' : '');
      await send('Page.navigate', {url: origin + url});
      const readyDeadline = Date.now() + 15_000;
      for (;;) {
        const state = await evaluate(`({ready: ${app === 'dom' ? 'document.body?.dataset.testFailures !== undefined' : 'window.fixture?.ready'}, error: window.fixtureFatal})`);
        if (state.error) throw new Error(state.error);
        if (state.ready) break;
        if (Date.now() > readyDeadline) throw new Error('Timed out loading ' + app + ': ' + await evaluate('document.body?.innerText'));
        await pause(100);
      }
      if (app === 'dom') {
        const results = await evaluate('({failures: document.body.dataset.testFailures, output: document.getElementById("results").textContent})');
        assert.equal(results.failures, '0', results.output);
        report.scenarios.push({app, ...results});
        console.log('PASS dom:', results.output.split('\n').at(-1));
      } else {
        if (withXlsx && app === 'upload') {
          await evaluate(`window.fixture.workbook = ${JSON.stringify(workbookFixture)}`);
        }
        const names = await evaluate('Object.keys(window.fixture.scenarios)');
        for (const name of names) {
          if (Date.now() > deadline) throw new Error('Fixture exceeded 180-second total bound');
          const outcome = await evaluate(`window.fixture.run(${JSON.stringify(name)})`);
          const {nodes} = await send('Accessibility.getFullAXTree');
          const nodeById = new Map(nodes.map(node => [node.nodeId, node]));
          const roles = ['textbox', 'combobox', 'checkbox', 'radio', 'spinbutton', 'button', 'group'];
          outcome.accessibility = nodes.filter(node => !node.ignored && node.name?.value && roles.includes(node.role?.value))
            .map(node => ({
              role: node.role.value, name: node.name.value,
              properties: Object.fromEntries((node.properties || [])
                .filter(property => ['checked', 'disabled', 'readonly', 'focusable', 'expanded'].includes(property.name))
                .map(property => [property.name, property.value.value]))
            }));
          // Required-field asterisks are CSS generated content included in Chrome's name.
          for (const expected of outcome.expectedAX) {
            const node = nodes.find(node => !node.ignored && node.role?.value === expected.role &&
              node.name?.value.replace(/\s*\*$/, '').trim() === expected.name);
            assert(node,
              `${app}/${name}: missing Chrome AX ${expected.role} "${expected.name}"; got ${JSON.stringify(outcome.accessibility.filter(node => node.role === expected.role).map(node => node.name))}`);
            if ('checked' in expected) {
              assert.equal(node.properties.find(property => property.name === 'checked')?.value.value, String(expected.checked),
                'Chrome AX checked state: ' + expected.name);
            }
            if (expected.group) {
              let parent = nodeById.get(node.parentId);
              while (parent && !(parent.role?.value === 'group' && parent.name?.value === expected.group)) {
                parent = nodeById.get(parent.parentId);
              }
              assert(parent, expected.name + ' must belong to named Chrome AX group ' + expected.group);
            }
          }
          outcome.mapCoordinatesGroup = outcome.accessibility.some(node => node.role === 'group' && node.name === 'Map Coordinates');
          report.scenarios.push({app, ...outcome});
          console.log(`PASS ${app}/${name}: ${outcome.assertions.length} DOM/request assertions, ${outcome.expectedAX.length} AX names`);
        }
        report.scenarios.push({app, requests: await evaluate('window.fixture.requests')});
        report.limitations.push(...await evaluate('window.fixture.limitations'));
      }
    } catch (error) {
      report.failures.push(app + ': ' + error.message);
      try {
        report.scenarios.push({app, diagnostic: await evaluate(`({
          status: document.getElementById('fixture-status')?.textContent,
          errors: window.fixture?.errors, requests: window.fixture?.requests,
          invalidControls: [...document.querySelectorAll('input.ng-invalid,select.ng-invalid,textarea.ng-invalid')].map(el => ({id: el.id, name: el.getAttribute('formcontrolname'), value: el.value})),
          text: document.body?.innerText.slice(-7000)
        })`)});
      } catch {}
      console.error('FAIL', app, error.message);
    } finally {
      await browser.send('Target.closeTarget', {targetId});
      sessions.delete(sessionId);
    }
  }
  assert.equal(report.blockedNetwork.length, 0, 'Unexpected network request(s): ' + JSON.stringify(report.blockedNetwork));
  assert.equal(report.consoleErrors.length, 0, 'Application console errors: ' + report.consoleErrors.join('\n'));
  for (const [pathname, before] of Object.entries(report.assets)) {
    if (pathname.startsWith('/')) assert.equal(hash(await readFile(path.join(root, pathname))), before, 'Asset changed during test: ' + pathname);
  }
} catch (error) {
  report.failures.push(error.stack || String(error));
  console.error(error.message);
} finally {
  let chromeProcesses = [];
  if (browser) {
    try {
      chromeProcesses = (await browser.send('SystemInfo.getProcessInfo')).processInfo.map(info => info.id);
    } catch {}
    try { await browser.send('Browser.close'); } catch {}
    browser.close();
  }
  if (chrome && chrome.exitCode === null && !chrome.killed) {
    await Promise.race([new Promise(resolve => chrome.once('exit', resolve)), pause(3000)]);
    if (chrome.exitCode === null) {
      chrome.kill('SIGTERM');
      await Promise.race([new Promise(resolve => chrome.once('exit', resolve)), pause(3000)]);
      if (chrome.exitCode === null) {
        chrome.kill('SIGKILL');
        await new Promise(resolve => chrome.once('exit', resolve));
      }
    }
  }
  chrome?.stderr.destroy();
  // Chrome may exit before its utility processes. Only terminate PIDs reported by
  // this isolated browser, never another Chrome instance or a process-name match.
  const alive = pid => {
    try { process.kill(pid, 0); return true; } catch { return false; }
  };
  const childDeadline = Date.now() + 2000;
  while (chromeProcesses.some(alive) && Date.now() < childDeadline) await pause(100);
  for (const pid of chromeProcesses.filter(alive)) {
    try { process.kill(pid, 'SIGTERM'); } catch {}
  }
  if (chromeProcesses.some(alive)) await pause(500);
  for (const pid of chromeProcesses.filter(alive)) {
    try { process.kill(pid, 'SIGKILL'); } catch {}
  }
  if (server) {
    server.closeAllConnections();
    await new Promise(resolve => server.close(resolve));
  }
  await rm(profile, {recursive: true, force: true, maxRetries: 3, retryDelay: 100});
  report.finishedAt = new Date().toISOString();
  report.limitations = [...new Set(report.limitations)];
  if (reportPath) await writeFile(reportPath, JSON.stringify(report, null, 2) + '\n');
  console.log(`${report.scenarios.filter(scenario => scenario.assertions || scenario.output).length} scenarios passed; ${report.failures.length} failures.`);
  if (reportPath) console.log('Report:', reportPath);
  process.exitCode = report.failures.length ? 1 : 0;
}
