---
layout: page
title: Subscribe
permalink: /subscribe/
---

<div class="rss-guide">
  <details>
    <summary class="section-toggle">
      <h2 class="section-title-row">RSS Feed <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 11a9 9 0 0 1 9 9"/><path d="M4 4a16 16 0 0 1 16 16"/><circle cx="5" cy="19" r="1"/></svg></h2>
      <svg class="toggle-chevron" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
    </summary>
    <div class="section-content">
      <p>Subscribe to new posts from Marginal Lab via RSS Feed — delivered automatically to your reader!</p>

      <div class="rss-url-box">
        <code>https://marginallabs.github.io/feed.xml</code>
        <button class="rss-copy-btn" id="rss-copy-btn" aria-label="Copy feed URL">Copy</button>
      </div>

      <h3>What is an RSS Feed?</h3>
      <p>RSS (Really Simple Syndication) is a standard format for publishing updates from a website. Instead of checking back for new content, your RSS reader fetches it for you — like a subscription to a newspaper, but free and private.</p>

      <h3>How to Subscribe</h3>
      <ol>
        <li>Install an RSS reader (see suggestions below)</li>
        <li>Click <strong class="no-accent">Subscribe</strong> or <strong class="no-accent">Add Feed</strong> in the app</li>
        <li>Paste the URL above and save</li>
        <li>New posts will appear in your reader automatically!<sup>*</sup></li>
      </ol>
      <p class="rss-footnote"><sup>*</sup>Some readers do not support inline math (LaTeX) rendering. For browser-based readers like Inoreader or Feedly, install the <a href="https://chromewebstore.google.com/detail/webtex-%E2%80%93-render-latex-any/cbcpbegaepelbhjfkikhbhhoemegdbim" target="_blank">WebTeX</a> extension (Chrome) to display math correctly.</p>

      <h3>Popular RSS Readers</h3>
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
              <td><a href="https://news.nononsenseapps.com/about/" target="_blank">Feeder</a></td>
              <td>&#10003;</td>
              <td>&#10003;</td>
              <td>&#10003;</td>
              <td>&#10003;</td>
              <td>Android</td>
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
              <td><a href="https://reederapp.com" target="_blank">Reeder</a></td>
              <td>&#10003;<sup>&Dagger;</sup></td>
              <td>&#10003;</td>
              <td>&#10007;</td>
              <td>&#10003;</td>
              <td>macOS, iOS</td>
            </tr>
          </tbody>
        </table>
      </div>
      <p class="rss-footnote"><sup>&dagger;</sup>Offline reading requires a Pro subscription.</p>
      <p class="rss-footnote"><sup>&Dagger;</sup>Free tier limited to 10 feeds; unlimited requires subscription.</p>
      <br>
    </div>
  </details>

  <details>
    <summary class="section-toggle">
      <h2>Other Subscribing Methods</h2>
      <svg class="toggle-chevron" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
    </summary>
    <div class="section-content">
      <p>Coming Soon — Stay Tuned!</p>
    </div>
  </details>
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

  document.querySelectorAll('.rss-guide details').forEach(function(detail) {
    var summary = detail.querySelector('.section-toggle');
    var content = detail.querySelector('.section-content');
    if (!summary || !content) return;

    summary.addEventListener('click', function(e) {
      e.preventDefault();
      if (detail.open) {
        var h = content.getBoundingClientRect().height;
        content.style.height = h + 'px';
        content.style.opacity = '1';
        content.offsetHeight; // force reflow
        content.style.height = '0px';
        content.style.opacity = '0';
        var done = false;
        function finish() {
          if (done) return;
          done = true;
          content.removeEventListener('transitionend', finish);
          detail.open = false;
          content.style.height = '';
          content.style.opacity = '';
        }
        content.addEventListener('transitionend', finish);
        setTimeout(finish, 350);
      } else {
        detail.open = true;
        content.style.height = '0px';
        content.style.opacity = '0';
        content.offsetHeight; // force reflow
        content.style.height = content.scrollHeight + 'px';
        content.style.opacity = '1';
        var done2 = false;
        function finish2() {
          if (done2) return;
          done2 = true;
          content.removeEventListener('transitionend', finish2);
          content.style.height = '';
          content.style.opacity = '';
        }
        content.addEventListener('transitionend', finish2);
        setTimeout(finish2, 350);
      }
    });
  });
})();
</script>
