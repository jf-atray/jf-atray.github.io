---
title: guestbook
permalink: /guestbook.html
---

the wall is a bluesky post. [reply to it]({{ site.guestbook_post }}) an ur name shows up here next build. freshest i can do.

## the wall
{% if site.data.guestbook.size > 0 %}
<div class="gb-wall bleed">
{% for e in site.data.guestbook %}
<div class="gb"><span class="gb-a">{% if e.avatar %}<a href="{{ e.url }}"><img src="{{ e.avatar }}" alt="" loading="lazy" width="48" height="48"></a>{% endif %}</span><div class="gb-b"><div class="gb-top"><a class="gb-h" href="{{ e.url }}">{{ e.handle }}</a><span class="gb-d">{{ e.date }}</span></div><div class="gb-t">{{ e.text | escape }}</div></div></div>
{% endfor %}
</div>
{% else %}
<p class="gb">the wall is quiet. be the first name on it.</p>
{% endif %}
