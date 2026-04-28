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
    <li>New posts will appear in your reader automatically!<sup>*</sup></li>
  </ol>
  <p class="rss-footnote"><sup>*</sup>Some readers do not support inline math (LaTeX) rendering. For browser-based readers like Feedly or Inoreader, install the <a href="https://chromewebstore.google.com/detail/webtex-%E2%80%93-render-latex-any/cbcpbegaepelbhjfkikhbhhoemegdbim" target="_blank">WebTeX</a> extension (Chrome) to display math correctly.</p>
  <p class="rss-footnote"><sup>&dagger;</sup>Offline reading requires a Pro subscription. <sup>&Dagger;</sup>Free tier limited to 10 feeds; unlimited requires subscription.</p>

  <h2>Popular RSS Readers</h2>
  <div class="rss-readers-table-wrap">
    <table class="rss-readers-table">
      <thead>
        <tr>
          <th>Reader</th>
          <th>Free</th>
          <th>No Sign-up</th>
          <th>Open Source</th>
          <th>Offline <span class="info-trigger" tabindex="0">&#9432;</span><span class="info-box">Articles are saved locally for<br>reading without internet.</span></th>
          <th>Platform</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><a href="https://www.inoreader.com" target="_blank">Inoreader</a></td>
          <td>&#10003;</td>
          <td>&#10007;</td>
          <td>&#10007;</td>
          <td>&#10007;<sup>&dagger;</sup></td>
          <td>Web, iOS, Android</td>
        </tr>
        <tr>
          <td><a href="https://feedly.com" target="_blank">Feedly</a></td>
          <td>&#10003;</td>
          <td>&#10007;</td>
          <td>&#10007;</td>
          <td>&#10007;</td>
          <td>Web, iOS, Android</td>
        </tr>
        <tr>
          <td><a href="https://reederapp.com" target="_blank">Reeder</a></td>
          <td>&#10003;<sup>&Dagger;</sup></td>
          <td>&#10003;</td>
          <td>&#10007;</td>
          <td>&#10003;</td>
          <td>macOS, iOS</td>
        </tr>
        <tr>
          <td><a href="https://netnewswire.com" target="_blank">NetNewsWire</a></td>
          <td>&#10003;</td>
          <td>&#10003;</td>
          <td>&#10003;</td>
          <td>&#10003;</td>
          <td>macOS, iOS</td>
        </tr>
        <tr>
          <td><a href="https://news.nononsenseapps.com" target="_blank">Feeder</a></td>
          <td>&#10003;</td>
          <td>&#10003;</td>
          <td>&#10003;</td>
          <td>&#10003;</td>
          <td>Android</td>
        </tr>
      </tbody>
    </table>
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
