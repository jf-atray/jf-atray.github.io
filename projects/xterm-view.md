---
title: this site
permalink: /projects/xterm-view.html
parent: /projects/
---

<p>all the colored text on here is written in the color language of a star wars mud he plays. same exact files he writes for the game. i built a little ruby tag that turns em into html at build time, so no javascript ever touches the art.</p>

<p>the language goes like this. <code>&NNN</code> picks 1 of 256 palette colors. <code>&#RRGGBB</code> an <code>&RRR.GGG.BBB</code> r truecolor. <code>^NNN</code> paints the background. single letters r the classic ansi 16. <code>&I</code> <code>&U</code> <code>&D</code> do italic underline reset.</p>

<p>thats the whole renderer. jekyll, github pages, one plugin, no dependencies.</p>
