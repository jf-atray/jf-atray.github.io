---
title: start here
permalink: /pieces/start-here.html
parent: /pieces.html
pieces: [droid, brassk, sov]
---

{% include views.html dir="/pieces/" index="/pieces.html" %}

<p>three of em. they say what this place is.</p>

<section class="exhibit">
  {% xterm_file droid.txt cap:left %}
  <div class="placard">
    <h3>for lack of any polish</h3>
    <p>a poem about a droid in the droids own colors. the site got built to hang it.</p>
  </div>
</section>

<section class="exhibit flip">
  {% xterm_file brassk.txt %}
  <div class="placard">
    <h3>brassk</h3>
    <p>colored one letter at a time. patience i dont have.</p>
  </div>
</section>

<section class="exhibit">
  {% xterm_file sov.txt %}
  <div class="placard">
    <h3>SOVREIGN</h3>
    <p>the color language doin fiction. drawn boxes, datanet, the works.</p>
  </div>
</section>
