---
title: pieces
permalink: /pieces.html
---

{% include views.html dir="/pieces/" index="/pieces.html" %}

<p>ascii art written in a muds own color language: ampersand codes for
xterm palette, truecolor an named colors, carets for background. every
piece is real text, selectable, rendered exactly as it was written.
{{ site.pieces | size }} pieces live here, all at one level.</p>

<section class="exhibit">
  {% xterm_file droid.txt cap:left %}
  <div class="placard">
    <h3>for lack of any polish</h3>
    <p>a burnished droid in amber an teal. the piece that started this
    site.</p>
  </div>
</section>

<section class="exhibit flip">
  {% xterm_file brassk.txt %}
  <div class="placard">
    <h3>brassk</h3>
    <p>a shop sign as a full truecolor gradient, one color code per
    character.</p>
  </div>
</section>

<p>the row up top is the directory: <a href="{{ '/pieces/start-here.html' | relative_url }}">start here</a>
tells the story in a few picks, <a href="{{ '/pieces/catalogue.html' | relative_url }}">the catalogue</a>
is the flat record of everything, an the eras are the raw archive sorted
by when each was written.</p>
