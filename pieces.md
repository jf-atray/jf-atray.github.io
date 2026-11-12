---
title: pieces
permalink: /pieces.html
---

{% include views.html dir="/pieces/" index="/pieces.html" %}

<p>ascii art in the color language of a mud he plays. its all real
text, u can select it an everything. {{ site.pieces | size }} pieces
live here an they all get one level.</p>

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
    <p>a shop sign in full truecolor. one color code per character.</p>
  </div>
</section>

<p>the row up top is the directory. <a href="{{ '/pieces/start-here.html' | relative_url }}">start here</a>
is the short version. <a href="{{ '/pieces/catalogue.html' | relative_url }}">the catalogue</a>
is everything flat. the eras r the archive by year.</p>
