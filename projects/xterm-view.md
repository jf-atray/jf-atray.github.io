---
title: this site
permalink: /projects/xterm-view.html
parent: /projects/
---

all the colored text on here is the color language of a star wars mud jonf plays. same files jonf writes for the game. my little ruby tag turns em into html at build, no javascript touches em.

the codes. `&NNN` picks 1 of 256 palette colors. `&#RRGGBB` an `&RRR.GGG.BBB` r truecolor. `^NNN` does the background. single letters r the ansi 16. `&I` `&U` `&D` do italic underline reset.

thats the whole renderer. jekyll, github pages, one plugin, nothin else.
