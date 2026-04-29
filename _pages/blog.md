---
layout: page
title: Blog
permalink: /blog/
subscribe: true
---

<div class="search-box">
  <input type="text" id="search-input" placeholder="Search posts..." autocomplete="off">
  <span class="search-clear" id="search-clear">&times;</span>
</div>

<div class="category-filters" id="category-filters">
  {% assign all_categories = "" | split: "" %}
  {% for post in site.posts %}
    {% for cat in post.categories %}
      {% assign all_categories = all_categories | push: cat %}
    {% endfor %}
  {% endfor %}
  {% assign unique_categories = all_categories | uniq | sort %}
  {% for cat in unique_categories %}
    <button class="cat-filter-btn" data-category="{{ cat | downcase }}">{{ cat }}</button>
  {% endfor %}
</div>

<div id="post-list">
{% for post in site.posts %}
  <article class="blog-list-item" data-title="{{ post.title | downcase }}" data-categories="{{ post.categories | join: ',' | downcase }}" data-excerpt="{{ post.abstract | default: post.excerpt | strip_html | downcase }}">
    <span class="post-date">{{ post.date | date: "%B %d, %Y" }}{% assign w = post.content | strip_html | split: " " | size %}{% assign rt = w | divided_by: 200 | at_least: 1 %} &middot; {{ rt }} min read</span>
    <div class="post-title-row">
      {% if post.image %}<img class="post-thumbnail" src="{{ post.image | relative_url }}" alt="Thumbnail for {{ post.title }}" />{% endif %}
      <a class="post-title-link" href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </div>
    {% if post.categories %}
      <span class="post-category-badges">
        {% for cat in post.categories %}<span class="category-tag">{{ cat }}</span>{% endfor %}
      </span>
    {% endif %}
    {% if post.abstract %}
      <p class="post-excerpt">{{ post.abstract | truncatewords: 30 }}</p>
    {% endif %}
  </article>
{% endfor %}
</div>

{% if site.posts.size == 0 %}
  <p>No posts yet. Stay tuned!</p>
{% endif %}

<p class="no-results" id="no-results" style="display:none;">No posts found.</p>

<script>
(function() {
  var input = document.getElementById('search-input');
  var clear = document.getElementById('search-clear');
  var items = document.querySelectorAll('.blog-list-item');
  var noResults = document.getElementById('no-results');
  var buttons = document.querySelectorAll('.cat-filter-btn');
  var activeCategories = [];

  function search() {
    var q = input.value.toLowerCase().trim();
    var found = 0;
    items.forEach(function(item) {
      var title = item.getAttribute('data-title');
      var cats = item.getAttribute('data-categories').split(',');
      var excerpt = item.getAttribute('data-excerpt');

      var textMatch = !q || title.indexOf(q) !== -1 || excerpt.indexOf(q) !== -1;
      var catMatch = activeCategories.length === 0 || activeCategories.some(function(c) { return cats.indexOf(c) !== -1; });

      var show = textMatch && catMatch;
      item.style.display = show ? '' : 'none';
      if (show) found++;
    });
    noResults.style.display = found === 0 ? '' : 'none';
    clear.style.display = q ? '' : 'none';
  }

  input.addEventListener('input', search);
  clear.addEventListener('click', function() { input.value = ''; search(); input.focus(); });

  buttons.forEach(function(btn) {
    btn.addEventListener('click', function() {
      var cat = this.getAttribute('data-category');
      var idx = activeCategories.indexOf(cat);
      if (idx === -1) {
        activeCategories.push(cat);
        this.classList.add('active');
      } else {
        activeCategories.splice(idx, 1);
        this.classList.remove('active');
      }
      search();
    });
  });
})();
</script>
