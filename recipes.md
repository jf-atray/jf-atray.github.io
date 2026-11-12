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
<p>the pantry is empty. the first dish goes in <code>_recipes/</code> with a <code>title:</code> an whatever structure the writing wants.</p>
{% endif %}
