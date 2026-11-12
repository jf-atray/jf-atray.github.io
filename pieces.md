---
title: pieces
permalink: /pieces.html
---

{% include views.html dir="/pieces/" index="/pieces.html" %}

ascii art in the color language of a mud the webmaster plays. real text,
u can select it an everything. {{ site.pieces | size }} pieces,
all on one level.

<section class="exhibit">
  {% xterm_file droid.txt cap:left %}
  <div class="placard">
    <h3>for lack of any polish</h3>
    <p>a poem about a droid in the droids own colors. the site got
    built to hang it.</p>
  </div>
</section>

<section class="exhibit flip">
  {% xterm_file brassk.txt %}
  <div class="placard">
    <h3>brassk</h3>
    <p>a shop sign that exists to show off the colors.</p>
  </div>
</section>

first time here, [start here]({{ '/pieces/start-here.html' | relative_url }}).
