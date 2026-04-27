---
layout: page
title: Subscribe
permalink: /subscribe/
---

<div class="rss-guide">
  <p>Subscribe to new posts from Marginal Lab via <a href="{{ '/feed.xml' | relative_url }}" target="_blank">RSS Feed</a> — delivered automatically to your reader!</p>

  <div class="rss-url-box">
    <code>https://marginallabs.github.io/feed.xml</code>
    <button class="rss-copy-btn" id="rss-copy-btn" aria-label="Copy feed URL">Copy</button>
  </div>

  <h2>What is an RSS Feed?</h2>
  <p>RSS (Really Simple Syndication) is a standard format for publishing updates from a website. Instead of checking back for new content, your RSS reader fetches it for you — like a subscription to a newspaper, but free and private.</p>

  <h2>How to Subscribe</h2>
  <ol>
    <li>Install an RSS reader (see suggestions below)</li>
    <li>Click <strong>Subscribe</strong> or <strong>Add Feed</strong> in the app</li>
    <li>Paste the URL above and save</li>
    <li>New posts will appear in your reader automatically!</li>
  </ol>

  <h2>Popular RSS Readers</h2>
  <div class="rss-apps">
    <span class="app-tag">Feedly</span>
    <span class="app-tag">Inoreader</span>
    <span class="app-tag">NetNewsWire</span>
    <span class="app-tag">Reeder</span>
    <span class="app-tag">Feeder</span>
  </div>
</div>

<script>
(function() {
  var btn = document.getElementById('rss-copy-btn');
  btn.addEventListener('click', function() {
    navigator.clipboard.writeText('https://marginallabs.github.io/feed.xml').then(function() {
      btn.textContent = 'Copied!';
      setTimeout(function() { btn.textContent = 'Copy'; }, 1500);
    });
  });
})();
</script>
