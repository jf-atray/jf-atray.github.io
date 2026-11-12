---
title: recipes
permalink: /recipes.html
---

{% if site.recipes.size > 0 %}
{% for r in site.recipes %}- [{{ r.title }}]({{ r.url | relative_url }})
{% endfor %}
{% else %}
no food yet. first dish goes in `_recipes/` w a `title:` on top.
{% endif %}
