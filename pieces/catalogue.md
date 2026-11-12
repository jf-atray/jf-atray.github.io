---
title: catalogue
permalink: /pieces/catalogue.html
parent: /pieces.html
---

{% include views.html dir="/pieces/" index="/pieces.html" %}

all of it, by era.

{% assign by_era = site.pieces | group_by: "era" | sort: "name" %}
{% for e in by_era %}
## era {{ e.name | default: "uncatalogued" }}
{% for p in e.items %}
- [{{ p.title }}]({{ p.url | relative_url }})
{% endfor %}
{% endfor %}
