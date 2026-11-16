// js port of _plugins/xterm_art.rb. same grammar, same spans,
// same 80col wrap. keep the two in lockstep or the playground
// lies about the site.
(() => {
const NAMED = {
  x:'c000',r:'c001',g:'c002',O:'c003',b:'c004',p:'c005',
  c:'c006',w:'c007',z:'c008',R:'c009',G:'c010',Y:'c011',
  B:'c012',P:'c013',C:'c014',W:'c015',
};
const RE = /(&&|\^#[0-9a-fA-F]{6}|\^\d{3}|&\d{1,3}\.\d{1,3}\.\d{1,3}|&#[0-9a-fA-F]{6}|&\d{3}|&[^\s])/;
const MAX = 80;

const esc = t => t.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');

function vis_len(tok) {
  if (tok === '&&') return 1;
  if (/^(\^#[0-9a-fA-F]{6}|\^\d{3}|&\d{1,3}\.\d{1,3}\.\d{1,3}|&#[0-9a-fA-F]{6}|&\d{3}|&[DIU]|&k|&\?)$/.test(tok)) return 0;
  const m = tok.match(/^&(.)$/s);
  if (m) return NAMED[m[1]] ? 0 : tok.length;
  return null;
}

function widths(src) {
  const ws = [];
  let cur = 0;
  for (const tok of src.split(RE)) {
    const n = vis_len(tok);
    if (n !== null) { cur += n; continue; }
    tok.split('\n').forEach((l, i) => {
      if (i > 0) { ws.push(cur); cur = 0; }
      cur += l.length;
    });
  }
  ws.push(cur);
  return ws;
}

// same autowrap as the ruby. fat lines break at the last
// space before the wall, or get sawn mid word.
function xwrap(src) {
  let out = '';
  let col = 0, last_sp = -1;
  for (const tok of src.split(RE)) {
    const n = vis_len(tok);
    if (n !== null) { out += tok; col += n; continue; }
    for (const ch of tok) {
      if (ch === '\n') { out += ch; col = 0; last_sp = -1; continue; }
      out += ch;
      col += 1;
      if (ch === ' ') last_sp = out.length - 1;
      if (col > MAX) {
        if (last_sp >= 0) {
          out = out.slice(0, last_sp) + '\n' + out.slice(last_sp + 1);
          col = out.length - last_sp - 1;
          last_sp = -1;
        } else { out += '\n'; col = 0; }
      }
    }
  }
  return out;
}

function xrender(src) {
  let cls = null, sty = null, bgcls = null, bgsty = null;
  let it = false, ul = false, kw = false;
  let out = '';
  const push = text => {
    if (!text) return;
    const t = esc(text);
    const classes = [cls, bgcls, it && 'it', ul && 'ul', kw && 'kw'].filter(Boolean).join(' ');
    const css = [sty, bgsty].filter(Boolean).join(';');
    const attrs = [
      classes && `class="${classes}"`,
      css && `style="${css}"`,
    ].filter(Boolean).join(' ');
    out += attrs ? `<b ${attrs}>${t}</b>` : t;
  };
  for (const tok of src.split(RE)) {
    if (!tok) continue;
    let m;
    if (tok === '&&') push('&');
    else if ((m = tok.match(/^&#([0-9a-fA-F]{6})$/))) { sty = `color:#${m[1].toLowerCase()}`; cls = null; }
    else if ((m = tok.match(/^\^#([0-9a-fA-F]{6})$/))) { bgsty = `background:#${m[1].toLowerCase()}`; bgcls = null; }
    else if ((m = tok.match(/^\^(\d{3})$/))) { bgcls = `b${m[1]}`; bgsty = null; }
    else if ((m = tok.match(/^&(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/))) {
      sty = 'color:#' + [m[1], m[2], m[3]].map(n => (+n).toString(16).padStart(2, '0')).join('');
      cls = null;
    }
    else if ((m = tok.match(/^&(\d{3})$/))) { cls = `c${m[1]}`; sty = null; }
    else if (tok === '&D') { cls = sty = bgcls = bgsty = null; it = ul = kw = false; }
    else if (tok === '&I') it = true;
    else if (tok === '&U') ul = true;
    else if (tok === '&k') kw = !kw;
    else if (tok === '&?') { cls = 'c' + String(Math.floor(Math.random() * 256)).padStart(3, '0'); sty = null; }
    else if ((m = tok.match(/^&(.)$/s))) {
      if (NAMED[m[1]]) { cls = NAMED[m[1]]; sty = null; }
      else push(tok);
    }
    else push(tok);
  }
  return out;
}

// playground wiring. input box, live pre, a fat-col cop.
// the site wraps at 80 before render, so the preview does
// the same an the stat reports what got wrapped.
document.addEventListener('DOMContentLoaded', () => {
  const box = document.getElementById('play-in');
  const out = document.getElementById('play-out');
  const stat = document.getElementById('play-stat');
  if (!box || !out || !stat) return;
  const draw = () => {
    const raw = box.value;
    const src = xwrap(raw);
    out.innerHTML = xrender(src);
    const ws = widths(src);
    const max = Math.max(...ws);
    out.className = 'xterm ' + (max <= 66 ? 'w-s' : max <= 78 ? 'w-m' : 'w-l');
    const fat = widths(raw).filter(w => w > MAX).length;
    stat.textContent = fat
      ? `widest line ${max}, ${fat} line${fat > 1 ? 's' : ''} wrapped at 80`
      : `widest line ${max}`;
  };
  box.addEventListener('input', draw);
  draw();
});
})();
