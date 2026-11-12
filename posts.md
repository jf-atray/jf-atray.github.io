---
title: posts
permalink: /posts.html
---

{% assign by_year = site.posts | group_by_exp: "p", "p.date | date: '%Y'" | sort: "name" | reverse %}
{% for y in by_year %}
## {{ y.name }}
{% for p in y.items %}
- {{ p.date | date: "%Y-%m-%d" }}. [{{ p.title }}]({{ p.url | relative_url }})
{% endfor %}
{% endfor %}
