---
title: this site
permalink: /projects/xterm-view.html
parent: /projects/
---

<p>the colored text everywhere on this site is written in the color language of a star wars mud i play. the files are the same ones i write for the game. a ~70 line ruby tag turns them into html at build time, so no javascript ever touches the art.</p>

<p>the language: <code>&NNN</code> picks from a 256 color palette, <code>&#RRGGBB</code> an <code>&RRR.GGG.BBB</code> are truecolor, <code>^NNN</code> paints the background instead of the text, single letters are the classic 16 ansi colors, an <code>&I</code>/<code>&U</code>/<code>&D</code> do italic, underline, reset.</p>

<p>jekyll, github pages, one plugin, zero dependencies. the renderer is the smallest thing that could honor the format.</p>
