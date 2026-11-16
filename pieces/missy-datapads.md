---
title: Missy's datapads
permalink: /pieces/missy-datapads.html
family: missy
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




{% for f in page.folds %}
{% include tagfold.html tag=f.tag title=f.title %}
{% endfor %}
