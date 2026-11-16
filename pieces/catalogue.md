---
title: catalogue
permalink: /pieces/catalogue.html
parent: /pieces.html
---

all of it, by whos it is.

{% assign fams = site.pieces | group_by_exp: "p", "p.relative_path | split: '/' | slice: 1" | sort: "name" %}
{% for f in fams %}
## {{ f.name }}
{% assign sorted = f.items | sort: "title" %}
{% for p in sorted %}
- [{{ p.title }}]({{ p.url | relative_url }})
{% endfor %}
{% endfor %}
