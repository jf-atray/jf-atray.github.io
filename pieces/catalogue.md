---
title: catalogue
permalink: /pieces/catalogue.html
parent: /pieces.html
---

{% include views.html dir="/pieces/" index="/pieces.html" %}

<p>the flat list of everything, grouped by era. no curation here, just the record.</p>

{% assign by_era = site.pieces | group_by: "era" | sort: "name" %}
{% for e in by_era %}
<h2>era {{ e.name | default: "uncatalogued" }}</h2>
<ul>
{% for p in e.items %}
  <li><a href="{{ p.url | relative_url }}">{{ p.title }}</a></li>
{% endfor %}
</ul>
{% endfor %}
