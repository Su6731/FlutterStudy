// 对已保存的真实运行日志进行浏览器截图；不伪装为桌面终端截图。
// 可选工具：Node.js 与 Playwright，不属于 Dart 应用依赖。
const fs = require('node:fs');
const path = require('node:path');
const { chromium } = require(process.env.PLAYWRIGHT_MODULE || 'playwright');
const escape = (text) => text.replace(/[&<>]/g, (c) => ({'&':'&amp;', '<':'&lt;', '>':'&gt;'}[c]));
(async () => {
  const browser = await chromium.launch({ channel: 'msedge', headless: true });
  try {
    const page = await browser.newPage({ viewport: { width: 1200, height: 700 }, deviceScaleFactor: 1 });
    for (const [name, command] of [
      ['normal', 'dart run'],
      ['missing_file', 'dart run（data/books.json 临时改名后）'],
      ['missing_field', 'dart run bin/async_json.dart test/fixtures/missing_field.json'],
      ['wrong_type', 'dart run bin/async_json.dart test/fixtures/wrong_type.json'],
      ['test', 'dart test'],
    ]) {
      const log = fs.readFileSync(path.join(__dirname, `${name}.txt`), 'utf8');
      await page.setContent(`<html lang="zh-CN"><meta charset="utf-8"><style>body{margin:32px;background:#101828;color:#e9eef7;font:18px 'Microsoft YaHei',sans-serif}h1{font-size:24px}p{color:#a9bedb}pre{padding:24px;border:1px solid #62738b;white-space:pre-wrap;line-height:1.65;font:18px/1.65 Consolas,'Microsoft YaHei',monospace}</style><h1>DAY4 实际运行输出</h1><p>已保存日志的浏览器截图 · ${escape(command)}</p><pre>${escape(log)}</pre></html>`);
      await page.screenshot({ path: path.join(__dirname, `${name}.png`), fullPage: true });
    }
  } finally { await browser.close(); }
})().catch((error) => { console.error(error); process.exitCode = 1; });
