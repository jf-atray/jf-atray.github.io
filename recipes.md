---
title: recipes
permalink: /recipes.html
---

{% if site.recipes.size > 0 %}
<ul>
{% for r in site.recipes %}  <li><a href="{{ r.url | relative_url }}">{{ r.title }}</a></li>
{% endfor %}
</ul>
{% else %}
<p>no food yet. first dish goes in <code>_recipes/</code> w a <code>title:</code> on top.</p>
{% endif %}
