---
layout: default
title: welcome
feature: tuco_shop
---


{% xterm_file tuco/shop.txt cap:left %}
{% assign feat = site.pieces | where: "slug", page.feature | first %}
{% include comments.html comments=feat.comments open=true %}

## whats new
<ul class="news">
{% for n in site.data.news limit:8 %}
  <li>{{ n.date }}. {{ n.msg | escape }}</li>
{% endfor %}
</ul>
