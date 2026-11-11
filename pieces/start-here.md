---
title: start here
permalink: /pieces/start-here.html
parent: /pieces.html
pieces: [droid, brassk, sov]
---

{% include views.html dir="/pieces/" index="/pieces.html" %}

<p>three pieces that say what this place is.</p>

<section class="exhibit">
  {% xterm_file droid.txt cap:left %}
  <div class="placard">
    <h3>for lack of any polish</h3>
    <p>the piece the whole site was built around. a poem that colors itself amber as it describes a droid made of gears an wires.</p>
  </div>
</section>

<section class="exhibit flip">
  {% xterm_file brassk.txt %}
  <div class="placard">
    <h3>brassk</h3>
    <p>a truecolor gradient laid down one character at a time. the pure technique piece.</p>
  </div>
</section>

<section class="exhibit">
  {% xterm_file sov.txt %}
  <div class="placard">
    <h3>SOVREIGN</h3>
    <p>a rogue AI datanet entry in drawn boxes. the color language doing fiction, not decoration.</p>
  </div>
</section>
