const assert = require('assert');
const path = require('path');
const { engines } = require(path.join(process.cwd(), 'package.json'));

assert.strictEqual(process.versions.node, engines.node,
  `Use Node.js ${engines.node} (see this workspace's .nvmrc).`);
assert.strictEqual((process.env.npm_config_user_agent || '').split(' ')[0],
  `npm/${engines.npm}`, `Run this build with npm ${engines.npm}.`);
