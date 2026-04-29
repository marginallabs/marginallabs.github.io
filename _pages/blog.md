---
layout: page
title: Blog
permalink: /blog/
subscribe: true
---

<div class="search-box">
  <input type="text" id="search-input" placeholder="Search posts..." autocomplete="off">
  <span class="search-clear" id="search-clear">&times;</span>
  <select class="search-sort" id="search-sort">
    <option value="default">Default</option>
    <option value="newest">Newest first</option>
    <option value="oldest">Oldest first</option>
    <option value="shortest">Shortest read</option>
    <option value="longest">Longest read</option>
    <option value="relevance">Relevance</option>
  </select>
</div>

<span class="search-result-count" id="search-result-count" style="display:none;"></span>

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
  <button class="cat-filter-btn cat-more-toggle" id="cat-more-toggle">More...</button>
</div>

<div id="post-list">
{% for post in site.posts %}
  {% assign w = post.content | strip_html | split: " " | size %}{% assign rt = w | divided_by: 200 | at_least: 1 %}
  <article class="blog-list-item" data-title="{{ post.title | downcase }}" data-categories="{{ post.categories | join: ',' | downcase }}" data-excerpt="{{ post.abstract | default: post.excerpt | strip_html | downcase }}" data-date="{{ post.date | date: '%Y-%m-%d' }}" data-reading-time="{{ rt }}">
    <span class="post-date">{{ post.date | date: "%B %d, %Y" }} &middot; {{ rt }} min read</span>
    <div class="post-title-row">
      {% if post.image %}<a href="{{ post.url | relative_url }}"><img class="post-thumbnail" src="{{ post.image | relative_url }}" alt="Thumbnail for {{ post.title }}" /></a>{% endif %}
      <a class="post-title-link" href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </div>
    {% if post.categories %}<span class="post-category-badges">{% if post.categories.size <= 5 %}{% for cat in post.categories %}<span class="category-tag">{{ cat }}</span>{% endfor %}{% else %}{% for cat in post.categories limit:4 %}<span class="category-tag">{{ cat }}</span>{% endfor %}<span class="category-tag category-more-toggle" onclick="this.parentElement.querySelectorAll('.category-tag.hidden-tag').forEach(function(t){t.classList.remove('hidden-tag');}); this.style.display='none';">More...</span>{% for cat in post.categories offset:4 %}<span class="category-tag hidden-tag">{{ cat }}</span>{% endfor %}{% endif %}</span>{% endif %}
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
  var sortSelect = document.getElementById('search-sort');
  var input = document.getElementById('search-input');
  var clear = document.getElementById('search-clear');
  var list = document.getElementById('post-list');
  var items = Array.from(document.querySelectorAll('.blog-list-item'));
  var noResults = document.getElementById('no-results');
  var resultCount = document.getElementById('search-result-count');
  var buttons = document.querySelectorAll('.cat-filter-btn:not(.cat-more-toggle)');
  var activeCategories = [];

  // Category expand/collapse
  var VISIBLE_COUNT = 6;
  var allBtns = Array.from(buttons);
  var moreToggle = document.getElementById('cat-more-toggle');
  var expanded = false;

  function updateCatVisibility() {
    allBtns.forEach(function(btn, i) {
      btn.style.display = (!expanded && i >= VISIBLE_COUNT) ? 'none' : '';
    });
    if (allBtns.length <= VISIBLE_COUNT) {
      moreToggle.style.display = 'none';
    } else {
      moreToggle.style.display = '';
      moreToggle.textContent = expanded ? 'Less...' : 'More...';
    }
  }
  updateCatVisibility();

  moreToggle.addEventListener('click', function() {
    expanded = !expanded;
    updateCatVisibility();
  });

  // Parse query: returns { include: [words], phrases: ["exact phrase"], exclude: [words] }
  function parseQuery(q) {
    var include = [];
    var phrases = [];
    var exclude = [];
    var remaining = q;
    // Extract quoted phrases
    var phraseRe = /"([^"]+)"/g;
    var m;
    while ((m = phraseRe.exec(remaining)) !== null) {
      phrases.push(m[1].toLowerCase());
    }
    remaining = remaining.replace(/"[^"]*"/g, ' ');
    // Split remaining into words
    var words = remaining.split(/\s+/).filter(function(w) { return w.length > 0; });
    words.forEach(function(w) {
      if (w.charAt(0) === '-') {
        var ex = w.substring(1);
        if (ex.length > 0) exclude.push(ex.toLowerCase());
      } else {
        include.push(w.toLowerCase());
      }
    });
    return { include: include, phrases: phrases, exclude: exclude };
  }

  function textMatches(text, parsed) {
    // Check excludes
    for (var i = 0; i < parsed.exclude.length; i++) {
      if (text.indexOf(parsed.exclude[i]) !== -1) return false;
    }
    // Check phrases (all must be present)
    for (var i = 0; i < parsed.phrases.length; i++) {
      if (text.indexOf(parsed.phrases[i]) === -1) return false;
    }
    // Check include words (all must be present)
    for (var i = 0; i < parsed.include.length; i++) {
      if (text.indexOf(parsed.include[i]) === -1) return false;
    }
    return true;
  }

  function relevanceScore(text, parsed) {
    var score = 0;
    parsed.phrases.forEach(function(p) {
      var idx = text.indexOf(p);
      while (idx !== -1) { score += 3; idx = text.indexOf(p, idx + 1); }
    });
    parsed.include.forEach(function(w) {
      var idx = text.indexOf(w);
      while (idx !== -1) { score += 1; idx = text.indexOf(w, idx + 1); }
    });
    return score;
  }

  function getAllTerms(parsed) {
    return parsed.include.concat(parsed.phrases).filter(function(t) { return t.length > 0; });
  }

  function highlightText(el, terms) {
    if (terms.length === 0) { el.innerHTML = el.textContent; return; }
    var text = el.textContent;
    var lower = text.toLowerCase();
    var marks = [];
    terms.forEach(function(term) {
      var idx = lower.indexOf(term);
      while (idx !== -1) {
        marks.push({ start: idx, end: idx + term.length });
        idx = lower.indexOf(term, idx + 1);
      }
    });
    if (marks.length === 0) { el.innerHTML = text; return; }
    marks.sort(function(a, b) { return a.start - b.start || a.end - b.end; });
    // Merge overlapping
    var merged = [marks[0]];
    for (var i = 1; i < marks.length; i++) {
      var last = merged[merged.length - 1];
      if (marks[i].start <= last.end) {
        last.end = Math.max(last.end, marks[i].end);
      } else {
        merged.push(marks[i]);
      }
    }
    var result = '';
    var prev = 0;
    merged.forEach(function(m) {
      result += escapeHtml(text.substring(prev, m.start));
      result += '<mark class="search-highlight">' + escapeHtml(text.substring(m.start, m.end)) + '</mark>';
      prev = m.end;
    });
    result += escapeHtml(text.substring(prev));
    el.innerHTML = result;
  }

  function escapeHtml(s) {
    return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
  }

  function search() {
    var q = input.value.trim();
    var parsed = parseQuery(q);
    var terms = getAllTerms(parsed);
    var hasQuery = terms.length > 0 || parsed.exclude.length > 0;
    var results = [];

    items.forEach(function(item) {
      var title = item.getAttribute('data-title');
      var cats = item.getAttribute('data-categories').split(',');
      var excerpt = item.getAttribute('data-excerpt');
      var combined = title + ' ' + excerpt + ' ' + cats.join(' ');

      var textMatch = !hasQuery || textMatches(combined, parsed);
      var catMatch = activeCategories.length === 0 || activeCategories.every(function(c) { return cats.indexOf(c) !== -1; });

      if (textMatch && catMatch) {
        var score = hasQuery ? relevanceScore(combined, parsed) : 0;
        results.push({ item: item, score: score, date: item.getAttribute('data-date'), rt: parseInt(item.getAttribute('data-reading-time')) || 1 });
      }
    });

    // Sort
    var sortBy = sortSelect.value;
    if (sortBy === 'relevance' && hasQuery) {
      results.sort(function(a, b) { return b.score - a.score || b.date.localeCompare(a.date); });
    } else if (sortBy === 'oldest') {
      results.sort(function(a, b) { return a.date.localeCompare(b.date); });
    } else if (sortBy === 'shortest') {
      results.sort(function(a, b) { return a.rt - b.rt || b.date.localeCompare(a.date); });
    } else if (sortBy === 'longest') {
      results.sort(function(a, b) { return b.rt - a.rt || b.date.localeCompare(a.date); });
    } else if (sortBy === 'newest') {
      results.sort(function(a, b) { return b.date.localeCompare(a.date); });
    } else {
      // default: relevance when searching, newest when not
      if (hasQuery) {
        results.sort(function(a, b) { return b.score - a.score || b.date.localeCompare(a.date); });
      } else {
        results.sort(function(a, b) { return b.date.localeCompare(a.date); });
      }
    }

    // Reorder DOM
    results.forEach(function(r) { list.appendChild(r.item); });
    // Hide non-matching
    var matchSet = new Set(results.map(function(r) { return r.item; }));
    items.forEach(function(item) {
      item.style.display = matchSet.has(item) ? '' : 'none';
    });

    // Highlight
    items.forEach(function(item) {
      var titleEl = item.querySelector('.post-title-link');
      var excerptEl = item.querySelector('.post-excerpt');
      if (titleEl) highlightText(titleEl, terms);
      if (excerptEl) highlightText(excerptEl, terms);
    });

    // Result count
    var total = items.length;
    var found = results.length;
    if (hasQuery) {
      resultCount.textContent = found + ' of ' + total + ' posts found';
      resultCount.style.display = '';
    } else {
      resultCount.style.display = 'none';
    }

    noResults.style.display = (found === 0 && (hasQuery || activeCategories.length > 0)) ? '' : 'none';
    clear.style.display = q ? '' : 'none';

    // URL state
    var params = new URLSearchParams();
    if (q) params.set('q', q);
    if (activeCategories.length > 0) params.set('cats', activeCategories.join(','));
    if (sortSelect.value !== 'default') params.set('sort', sortSelect.value);
    var newUrl = params.toString() ? window.location.pathname + '?' + params.toString() : window.location.pathname;
    history.replaceState(null, '', newUrl);
  }

  input.addEventListener('input', search);
  sortSelect.addEventListener('change', search);
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

  // Restore from URL
  var params = new URLSearchParams(window.location.search);
  if (params.get('q')) {
    input.value = params.get('q');
  }
  if (params.get('cats')) {
    params.get('cats').split(',').forEach(function(cat) {
      activeCategories.push(cat);
      allBtns.forEach(function(btn) {
        if (btn.getAttribute('data-category') === cat) btn.classList.add('active');
      });
    });
  }
  if (params.get('sort')) {
    sortSelect.value = params.get('sort');
  }
  search();
})();
</script>
