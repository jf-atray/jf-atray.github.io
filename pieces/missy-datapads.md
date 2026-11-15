---
title: missy's datapads
permalink: /pieces/missy-datapads.html
parent: /pieces.html
folds:
  - title: the pads
    tag: datapad
  - title: the trade
    tag: datapad-trade
  - title: on her person
    tag: datapad-worn
  - title: everywhere else
    tag: datapad-loose
---

{% include views.html dir="/pieces/" index="/pieces.html" %}

every pad she made, sold, an wore. <em>the webmaster writes this intro.</em>

{% for f in page.folds %}
{% include tagfold.html tag=f.tag title=f.title %}
{% endfor %}
