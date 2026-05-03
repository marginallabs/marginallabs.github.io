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

<div class="search-controls">
  <div class="search-controls-left">
    <span class="search-sort-label">Sort by:</span>
    <select class="search-sort" id="search-sort">
      <option value="default">Default</option>
      <option value="newest">Newest first</option>
      <option value="oldest">Oldest first</option>
      <option value="shortest">Shortest read</option>
      <option value="longest">Longest read</option>
    </select>
  </div>
  <div class="search-controls-right">
    <span class="search-sort-label">Show:</span>
    <select class="search-sort" id="per-page">
      <option value="5" selected>5 per page</option>
      <option value="10">10 per page</option>
      <option value="20">20 per page</option>
      <option value="0">All posts</option>
    </select>
  </div>
</div>

<span class="search-result-count" id="search-result-count" style="display:none;"></span>

<div class="filter-row filter-row-center" id="format-filters">
  <span class="filter-label">Type:</span>
  <div class="filter-tags">
    <button class="fmt-filter-btn format-badge format-essay" data-format="essay">Essay</button>
    <button class="fmt-filter-btn format-badge format-tutorial" data-format="tutorial">Tutorial</button>
    <button class="fmt-filter-btn format-badge format-deep-dive" data-format="deep-dive">Deep Dive</button>
  </div>
</div>

<div class="filter-row" id="category-filters">
  <span class="filter-label">Categories:</span>
  <div class="filter-tags">
  {% assign all_categories = "" | split: "" %}
  {% for post in site.posts %}
    {% if post.type == 'blog' %}
      {% for cat in post.categories %}
        {% assign all_categories = all_categories | push: cat %}
      {% endfor %}
    {% endif %}
  {% endfor %}
  {% assign unique_categories = all_categories | uniq | sort %}
  {% for cat in unique_categories %}
    <button class="cat-filter-btn" data-category="{{ cat | downcase }}">{{ cat }}</button>
  {% endfor %}
  <button class="cat-filter-btn cat-more-toggle" id="cat-more-toggle">More...</button>
  </div>
</div>

<div id="post-list">
{% for post in site.posts %}
  {% if post.type == 'blog' %}
  {% assign w = post.content | strip_html | split: " " | size %}{% assign rt = w | divided_by: 200 | at_least: 1 %}
  <article class="blog-list-item" data-title="{{ post.title | downcase }}" data-categories="{{ post.categories | join: ',' | downcase }}" data-excerpt="{{ post.abstract | default: post.excerpt | strip_html | downcase }}" data-date="{{ post.date | date: '%Y-%m-%d' }}" data-reading-time="{{ rt }}" data-format="{{ post.format | downcase }}">
    <span class="post-date">{{ post.date | date: "%B %d, %Y" }} &middot; {{ rt }} min read</span>
    <div class="post-title-row">
      {% if post.image %}<a href="{{ post.url | relative_url }}"><img class="post-thumbnail" src="{{ post.image | relative_url }}" alt="Thumbnail for {{ post.title }}" /></a>{% endif %}
      <a class="post-title-link" href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </div>
    {% if post.format %}<a class="format-badge format-{{ post.format | downcase }}" href="{{ '/blog/' | relative_url }}?format={{ post.format | downcase | url_encode }}">{{ post.format | replace: '-', ' ' }}</a>{% endif %}{% if post.categories %}<span class="post-category-badges">{% if post.categories.size <= 5 %}{% for cat in post.categories %}<span class="category-tag">{{ cat }}</span>{% endfor %}{% else %}{% for cat in post.categories limit:4 %}<span class="category-tag">{{ cat }}</span>{% endfor %}<span class="category-tag category-more-toggle" onclick="this.parentElement.querySelectorAll('.category-tag.hidden-tag').forEach(function(t){t.classList.remove('hidden-tag');}); this.style.display='none';">More...</span>{% for cat in post.categories offset:4 %}<span class="category-tag hidden-tag">{{ cat }}</span>{% endfor %}{% endif %}</span>{% endif %}
    {% if post.abstract %}
      <p class="post-excerpt">{{ post.abstract | truncatewords: 30 }}</p>
    {% endif %}
  </article>
  {% endif %}
{% endfor %}
</div>

{% if site.posts.size == 0 %}
  <p>No posts yet. Stay tuned!</p>
{% endif %}

<p class="no-results" id="no-results" style="display:none;">No posts found.</p>

<nav class="pagination" id="pagination"></nav>

<script>
(function() {
  var sortSelect = document.getElementById('search-sort');
  var perPageSelect = document.getElementById('per-page');
  var input = document.getElementById('search-input');
  var clear = document.getElementById('search-clear');
  var list = document.getElementById('post-list');
  var items = Array.from(document.querySelectorAll('.blog-list-item'));
  var noResults = document.getElementById('no-results');
  var resultCount = document.getElementById('search-result-count');
  var paginationEl = document.getElementById('pagination');
  var buttons = document.querySelectorAll('.cat-filter-btn:not(.cat-more-toggle)');
  var activeCategories = [];
  var activeFormat = '';
  var currentPage = 1;

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

  // Parse query
  function parseQuery(q) {
    var include = [], phrases = [], exclude = [];
    var remaining = q;
    var phraseRe = /"([^"]+)"/g, m;
    while ((m = phraseRe.exec(remaining)) !== null) phrases.push(m[1].toLowerCase());
    remaining = remaining.replace(/"[^"]*"/g, ' ');
    remaining.split(/\s+/).filter(function(w) { return w.length > 0; }).forEach(function(w) {
      if (w.charAt(0) === '-') { var ex = w.substring(1); if (ex.length > 0) exclude.push(ex.toLowerCase()); }
      else include.push(w.toLowerCase());
    });
    return { include: include, phrases: phrases, exclude: exclude };
  }

  function textMatches(text, parsed) {
    for (var i = 0; i < parsed.exclude.length; i++) if (text.indexOf(parsed.exclude[i]) !== -1) return false;
    for (var i = 0; i < parsed.phrases.length; i++) if (text.indexOf(parsed.phrases[i]) === -1) return false;
    for (var i = 0; i < parsed.include.length; i++) if (text.indexOf(parsed.include[i]) === -1) return false;
    return true;
  }

  function relevanceScore(text, parsed) {
    var score = 0;
    parsed.phrases.forEach(function(p) { var idx = text.indexOf(p); while (idx !== -1) { score += 3; idx = text.indexOf(p, idx + 1); } });
    parsed.include.forEach(function(w) { var idx = text.indexOf(w); while (idx !== -1) { score += 1; idx = text.indexOf(w, idx + 1); } });
    return score;
  }

  function getAllTerms(parsed) { return parsed.include.concat(parsed.phrases).filter(function(t) { return t.length > 0; }); }

  function escapeHtml(s) { return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;'); }

  function highlightText(el, terms) {
    if (terms.length === 0) { el.innerHTML = el.textContent; return; }
    var text = el.textContent, lower = text.toLowerCase(), marks = [];
    terms.forEach(function(term) { var idx = lower.indexOf(term); while (idx !== -1) { marks.push({ start: idx, end: idx + term.length }); idx = lower.indexOf(term, idx + 1); } });
    if (marks.length === 0) { el.innerHTML = text; return; }
    marks.sort(function(a, b) { return a.start - b.start || a.end - b.end; });
    var merged = [marks[0]];
    for (var i = 1; i < marks.length; i++) { var last = merged[merged.length - 1]; if (marks[i].start <= last.end) last.end = Math.max(last.end, marks[i].end); else merged.push(marks[i]); }
    var result = '', prev = 0;
    merged.forEach(function(m) { result += escapeHtml(text.substring(prev, m.start)) + '<mark class="search-highlight">' + escapeHtml(text.substring(m.start, m.end)) + '</mark>'; prev = m.end; });
    result += escapeHtml(text.substring(prev));
    el.innerHTML = result;
  }

  function renderPagination(totalItems) {
    var perPage = parseInt(perPageSelect.value);
    if (perPage === 0 || totalItems <= perPage) { paginationEl.innerHTML = ''; return; }
    var totalPages = Math.ceil(totalItems / perPage);
    if (currentPage > totalPages) currentPage = totalPages;
    if (currentPage < 1) currentPage = 1;
    var html = '';
    if (currentPage > 1) html += '<a class="page-btn" href="#" data-page="' + (currentPage - 1) + '">&laquo; Prev</a>';
    for (var i = 1; i <= totalPages; i++) {
      if (i === currentPage) html += '<span class="page-btn active">' + i + '</span>';
      else html += '<a class="page-btn" href="#" data-page="' + i + '">' + i + '</a>';
    }
    if (currentPage < totalPages) html += '<a class="page-btn" href="#" data-page="' + (currentPage + 1) + '">Next &raquo;</a>';
    paginationEl.innerHTML = html;
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
      var fmt = item.getAttribute('data-format') || '';
      var formatMatch = !activeFormat || fmt === activeFormat;
      if (textMatch && catMatch && formatMatch) {
        var score = hasQuery ? relevanceScore(combined, parsed) : 0;
        results.push({ item: item, score: score, date: item.getAttribute('data-date'), rt: parseInt(item.getAttribute('data-reading-time')) || 1 });
      }
    });

    // Sort
    var sortBy = sortSelect.value;
    if (sortBy === 'oldest') results.sort(function(a, b) { return a.date.localeCompare(b.date); });
    else if (sortBy === 'shortest') results.sort(function(a, b) { return a.rt - b.rt || b.date.localeCompare(a.date); });
    else if (sortBy === 'longest') results.sort(function(a, b) { return b.rt - a.rt || b.date.localeCompare(a.date); });
    else if (sortBy === 'newest') results.sort(function(a, b) { return b.date.localeCompare(a.date); });
    else { if (hasQuery) results.sort(function(a, b) { return b.score - a.score || b.date.localeCompare(a.date); }); else results.sort(function(a, b) { return b.date.localeCompare(a.date); }); }

    // Reorder DOM
    results.forEach(function(r) { list.appendChild(r.item); });

    // Pagination
    var perPage = parseInt(perPageSelect.value);
    var totalFound = results.length;
    var start = (perPage === 0) ? 0 : (currentPage - 1) * perPage;
    var end = (perPage === 0) ? totalFound : Math.min(start + perPage, totalFound);
    var visibleItems = results.slice(start, end).map(function(r) { return r.item; });
    var visibleSet = new Set(visibleItems);

    items.forEach(function(item) { item.style.display = visibleSet.has(item) ? '' : 'none'; });

    // Highlight
    items.forEach(function(item) {
      var titleEl = item.querySelector('.post-title-link');
      var excerptEl = item.querySelector('.post-excerpt');
      if (titleEl) highlightText(titleEl, terms);
      if (excerptEl) highlightText(excerptEl, terms);
    });

    // Result count
    if (hasQuery) { resultCount.textContent = totalFound + ' of ' + items.length + ' posts found'; resultCount.style.display = ''; }
    else { resultCount.style.display = 'none'; }

    noResults.style.display = (totalFound === 0 && (hasQuery || activeCategories.length > 0 || activeFormat)) ? '' : 'none';
    clear.style.display = q ? 'block' : 'none';

    renderPagination(totalFound);

    // URL state
    var params = new URLSearchParams();
    if (q) params.set('q', q);
    if (activeFormat) params.set('format', activeFormat);
    if (activeCategories.length > 0) params.set('cats', activeCategories.join(','));
    if (sortSelect.value !== 'default') params.set('sort', sortSelect.value);
    if (perPageSelect.value !== '5') params.set('per_page', perPageSelect.value);
    if (currentPage > 1) params.set('page', currentPage);
    var newUrl = params.toString() ? window.location.pathname + '?' + params.toString() : window.location.pathname;
    history.replaceState(null, '', newUrl);

    // Persist sort/per-page in localStorage
    localStorage.setItem('blog_sort', sortSelect.value);
    localStorage.setItem('blog_per_page', perPageSelect.value);
  }

  input.addEventListener('input', function() { currentPage = 1; search(); });
  sortSelect.addEventListener('change', function() { currentPage = 1; search(); });
  perPageSelect.addEventListener('change', function() { currentPage = 1; search(); });
  clear.addEventListener('click', function() { input.value = ''; currentPage = 1; search(); input.focus(); });

  buttons.forEach(function(btn) {
    btn.addEventListener('click', function() {
      var cat = this.getAttribute('data-category');
      var idx = activeCategories.indexOf(cat);
      if (idx === -1) { activeCategories.push(cat); this.classList.add('active'); }
      else { activeCategories.splice(idx, 1); this.classList.remove('active'); }
      currentPage = 1;
      search();
    });
  });

  var fmtButtons = document.querySelectorAll('.fmt-filter-btn');
  fmtButtons.forEach(function(btn) {
    btn.addEventListener('click', function() {
      var fmt = this.getAttribute('data-format');
      if (activeFormat === fmt) { activeFormat = ''; this.classList.remove('active'); }
      else { activeFormat = fmt; fmtButtons.forEach(function(b) { b.classList.remove('active'); }); this.classList.add('active'); }
      currentPage = 1;
      search();
    });
  });

  // Category tags in post previews toggle filter
  list.addEventListener('click', function(e) {
    var tag = e.target.closest('.post-category-badges .category-tag');
    if (!tag || tag.classList.contains('category-more-toggle') || tag.classList.contains('hidden-tag')) return;
    var cat = tag.textContent.trim().toLowerCase();
    var idx = activeCategories.indexOf(cat);
    if (idx === -1) { activeCategories.push(cat); } else { activeCategories.splice(idx, 1); }
    allBtns.forEach(function(btn) {
      if (activeCategories.indexOf(btn.getAttribute('data-category')) !== -1) btn.classList.add('active');
      else btn.classList.remove('active');
    });
    currentPage = 1;
    search();
  });

  paginationEl.addEventListener('click', function(e) {
    var btn = e.target.closest('[data-page]');
    if (!btn) return;
    e.preventDefault();
    currentPage = parseInt(btn.getAttribute('data-page'));
    search();
    window.scrollTo({ top: 0, behavior: 'smooth' });
  });

  // Restore from URL (takes priority) then localStorage
  var params = new URLSearchParams(window.location.search);
  if (params.get('q')) input.value = params.get('q');
  if (params.get('format')) {
    activeFormat = params.get('format');
    fmtButtons.forEach(function(btn) { if (btn.getAttribute('data-format') === activeFormat) btn.classList.add('active'); });
  }
  if (params.get('cats')) {
    params.get('cats').split(',').forEach(function(cat) {
      activeCategories.push(cat);
      allBtns.forEach(function(btn) { if (btn.getAttribute('data-category') === cat) btn.classList.add('active'); });
    });
  }
  if (params.get('sort')) sortSelect.value = params.get('sort');
  else if (localStorage.getItem('blog_sort')) sortSelect.value = localStorage.getItem('blog_sort');
  if (params.get('per_page')) perPageSelect.value = params.get('per_page');
  else if (localStorage.getItem('blog_per_page')) perPageSelect.value = localStorage.getItem('blog_per_page');
  if (params.get('page')) currentPage = parseInt(params.get('page'));
  search();
})();
</script>
