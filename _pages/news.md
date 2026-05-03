---
layout: page
title: News
permalink: /news/
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

<div id="post-list">
{% for post in site.posts %}
  {% if post.type == 'news' %}
  {% assign w = post.content | strip_html | split: " " | size %}{% assign rt = w | divided_by: 200 | at_least: 1 %}
  <article class="blog-list-item" data-title="{{ post.title | downcase }}" data-excerpt="{{ post.abstract | default: post.excerpt | strip_html | downcase }}" data-date="{{ post.date | date: '%Y-%m-%d' }}" data-reading-time="{{ rt }}">
    <span class="post-date">{{ post.date | date: "%B %d, %Y" }} &middot; {{ rt }} min read</span>
    <div class="post-title-row">
      {% if post.image %}<a href="{{ post.url | relative_url }}"><img class="post-thumbnail" src="{{ post.image | relative_url }}" alt="Thumbnail for {{ post.title }}" /></a>{% endif %}
      <a class="post-title-link" href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </div>
    {% if post.abstract %}
      <p class="post-excerpt">{{ post.abstract | truncatewords: 30 }}</p>
    {% endif %}
  </article>
  {% endif %}
{% endfor %}
</div>

{% assign has_news = false %}
{% for post in site.posts %}{% if post.type == 'news' %}{% assign has_news = true %}{% endif %}{% endfor %}
{% unless has_news %}
  <p>No news yet. Stay tuned!</p>
{% endunless %}

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
  var currentPage = 1;

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
      var excerpt = item.getAttribute('data-excerpt');
      var combined = title + ' ' + excerpt;
      if (!hasQuery || textMatches(combined, parsed)) {
        var score = hasQuery ? relevanceScore(combined, parsed) : 0;
        results.push({ item: item, score: score, date: item.getAttribute('data-date'), rt: parseInt(item.getAttribute('data-reading-time')) || 1 });
      }
    });

    var sortBy = sortSelect.value;
    if (sortBy === 'oldest') results.sort(function(a, b) { return a.date.localeCompare(b.date); });
    else if (sortBy === 'shortest') results.sort(function(a, b) { return a.rt - b.rt || b.date.localeCompare(a.date); });
    else if (sortBy === 'longest') results.sort(function(a, b) { return b.rt - a.rt || b.date.localeCompare(a.date); });
    else if (sortBy === 'newest') results.sort(function(a, b) { return b.date.localeCompare(a.date); });
    else { if (hasQuery) results.sort(function(a, b) { return b.score - a.score || b.date.localeCompare(a.date); }); else results.sort(function(a, b) { return b.date.localeCompare(a.date); }); }

    results.forEach(function(r) { list.appendChild(r.item); });

    var perPage = parseInt(perPageSelect.value);
    var totalFound = results.length;
    var start = (perPage === 0) ? 0 : (currentPage - 1) * perPage;
    var end = (perPage === 0) ? totalFound : Math.min(start + perPage, totalFound);
    var visibleItems = results.slice(start, end).map(function(r) { return r.item; });
    var visibleSet = new Set(visibleItems);

    items.forEach(function(item) { item.style.display = visibleSet.has(item) ? '' : 'none'; });

    items.forEach(function(item) {
      var titleEl = item.querySelector('.post-title-link');
      var excerptEl = item.querySelector('.post-excerpt');
      if (titleEl) highlightText(titleEl, terms);
      if (excerptEl) highlightText(excerptEl, terms);
    });

    if (hasQuery) { resultCount.textContent = totalFound + ' of ' + items.length + ' posts found'; resultCount.style.display = ''; }
    else { resultCount.style.display = 'none'; }

    noResults.style.display = (totalFound === 0 && hasQuery) ? '' : 'none';
    clear.style.display = q ? 'block' : 'none';

    renderPagination(totalFound);

    var params = new URLSearchParams();
    if (q) params.set('q', q);
    if (sortSelect.value !== 'default') params.set('sort', sortSelect.value);
    if (perPageSelect.value !== '5') params.set('per_page', perPageSelect.value);
    if (currentPage > 1) params.set('page', currentPage);
    var newUrl = params.toString() ? window.location.pathname + '?' + params.toString() : window.location.pathname;
    history.replaceState(null, '', newUrl);

    localStorage.setItem('news_sort', sortSelect.value);
    localStorage.setItem('news_per_page', perPageSelect.value);
  }

  input.addEventListener('input', function() { currentPage = 1; search(); });
  sortSelect.addEventListener('change', function() { currentPage = 1; search(); });
  perPageSelect.addEventListener('change', function() { currentPage = 1; search(); });
  clear.addEventListener('click', function() { input.value = ''; currentPage = 1; search(); input.focus(); });

  paginationEl.addEventListener('click', function(e) {
    var btn = e.target.closest('[data-page]');
    if (!btn) return;
    e.preventDefault();
    currentPage = parseInt(btn.getAttribute('data-page'));
    search();
    window.scrollTo({ top: 0, behavior: 'smooth' });
  });

  var params = new URLSearchParams(window.location.search);
  if (params.get('q')) input.value = params.get('q');
  if (params.get('sort')) sortSelect.value = params.get('sort');
  else if (localStorage.getItem('news_sort')) sortSelect.value = localStorage.getItem('news_sort');
  if (params.get('per_page')) perPageSelect.value = params.get('per_page');
  else if (localStorage.getItem('news_per_page')) perPageSelect.value = localStorage.getItem('news_per_page');
  if (params.get('page')) currentPage = parseInt(params.get('page'));
  search();
})();
</script>
