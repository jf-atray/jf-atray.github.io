---
title: recipes
permalink: /recipes.html
---

{% if site.recipes.size > 0 %}
{% for r in site.recipes %}- [{{ r.title }}]({{ r.url | relative_url }})
{% endfor %}
{% else %}
I'm accused of 'winging' everything I cook, and you know, I cook a lot. So I'm going to try the Ragusea method of writing it down.
{% endif %}
