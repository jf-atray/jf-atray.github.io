---
title: guestbook
permalink: /guestbook.html
---

<p>the sacred tradition. the wall lives on bluesky: <a href="{{ site.guestbook_post }}">reply to the post</a> to sign it, or <a href="mailto:guestbook@example.com?subject=signing%20the%20guestbook">email</a> like its 1998. signatures render at build time, so the wall is only as fresh as the last deploy.</p>

<h2>the wall</h2>
{% if site.data.guestbook.size > 0 %}
{% for e in site.data.guestbook %}
<p class="gb"><a class="gb-h" href="{{ e.url }}">{{ e.handle }}</a><span class="gb-d">{{ e.date }}</span><br>{{ e.text | escape }}</p>
{% endfor %}
{% else %}
<p class="gb">the wall is quiet. be the first name on it.</p>
{% endif %}
