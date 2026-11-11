---
title: posts
permalink: /posts.html
---

{% assign by_year = site.posts | group_by_exp: "p", "p.date | date: '%Y'" | sort: "name" | reverse %}
{% for y in by_year %}
<h2>{{ y.name }}</h2>
<ul>
{% for p in y.items %}
  <li>{{ p.date | date: "%Y-%m-%d" }}. <a href="{{ p.url | relative_url }}">{{ p.title }}</a></li>
{% endfor %}
</ul>
{% endfor %}
