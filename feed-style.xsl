<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:atom="http://www.w3.org/2005/Atom"
  exclude-result-prefixes="atom">

<xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes"/>

<xsl:template match="/">
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title><xsl:value-of select="atom:feed/atom:title"/> — RSS Feed</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: "Source Serif 4", Georgia, serif;
      color: #2c2c2c;
      background: #fdfcf9;
      line-height: 1.7;
      -webkit-font-smoothing: antialiased;
    }
    a { color: #2d5016; text-decoration: none; }
    a:hover { text-decoration: underline; }
    .wrapper { max-width: 680px; margin: 0 auto; padding: 0 1.5rem; }
    header { padding: 3rem 0 1.5rem; text-align: center; border-bottom: 1px solid #ddd8cc; }
    .site-name { font-family: "Inter", "Helvetica Neue", Arial, sans-serif; font-size: 0.9rem; font-weight: 700; color: #2d5016; text-transform: uppercase; letter-spacing: 0.03em; margin-bottom: 0.5rem; }
    .feed-title { font-family: "Inter", "Helvetica Neue", Arial, sans-serif; font-size: 1.6rem; font-weight: 700; color: #2c2c2c; margin-bottom: 0.3em; }
    .feed-desc { font-size: 0.95rem; color: #6b6b6b; margin-bottom: 1.5rem; }
    .guide {
      background: #f5f3ee;
      border: 1px solid #ddd8cc;
      border-radius: 4px;
      padding: 1.2em 1.5em;
      margin: 1.5rem auto 2rem;
      max-width: 680px;
      text-align: left;
    }
    .guide h2 {
      font-family: "Inter", "Helvetica Neue", Arial, sans-serif;
      font-size: 1rem;
      font-weight: 600;
      color: #2d5016;
      margin-bottom: 0.6em;
      text-transform: uppercase;
      letter-spacing: 0.04em;
    }
    .guide p { font-size: 0.92rem; margin: 0.5em 0; color: #2c2c2c; }
    .guide ol { margin: 0.5em 0 0.5em 1.5em; font-size: 0.92rem; }
    .guide li { margin: 0.3em 0; }
    .guide code { font-family: "SFMono-Regular", Consolas, monospace; font-size: 0.88em; background: #e8e4d9; padding: 0.15em 0.4em; border-radius: 3px; }
    .guide .apps { display: flex; flex-wrap: wrap; gap: 0.4em; margin: 0.6em 0; }
    .guide .app-tag {
      font-family: "Inter", "Helvetica Neue", Arial, sans-serif;
      font-size: 0.8rem;
      background: #e8f0e2;
      color: #2d5016;
      padding: 0.2em 0.6em;
      border-radius: 3px;
    }
    .feed-url {
      font-family: "SFMono-Regular", Consolas, monospace;
      font-size: 0.88rem;
      background: #e8e4d9;
      padding: 0.5em 0.8em;
      border-radius: 4px;
      margin: 0.8em 0;
      word-break: break-all;
    }
    .posts { padding: 1.5rem 0 3rem; }
    .posts-heading {
      font-family: "Inter", "Helvetica Neue", Arial, sans-serif;
      font-size: 0.95rem;
      font-weight: 600;
      color: #6b6b6b;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      margin-bottom: 1em;
      padding-bottom: 0.5em;
      border-bottom: 1px solid #ddd8cc;
    }
    .post-item {
      padding: 0.8em 0;
      border-bottom: 1px solid #f5f3ee;
    }
    .post-item:last-child { border-bottom: none; }
    .post-item a {
      font-family: "Inter", "Helvetica Neue", Arial, sans-serif;
      font-size: 1.05rem;
      font-weight: 600;
      color: #2d5016;
    }
    .post-date {
      font-family: "Inter", "Helvetica Neue", Arial, sans-serif;
      font-size: 0.85rem;
      color: #6b6b6b;
    }
    footer {
      border-top: 1px solid #ddd8cc;
      padding: 1.5rem 0;
      text-align: center;
    }
    footer p {
      font-family: "Inter", "Helvetica Neue", Arial, sans-serif;
      font-size: 0.75rem;
      color: #6b6b6b;
    }
  </style>
</head>
<body>
  <header>
    <div class="wrapper">
      <div class="site-name">Marginal Lab</div>
      <div class="feed-title">RSS Feed</div>
      <p class="feed-desc">Subscribe to new posts — delivered automatically to your reader.</p>
      <div class="feed-url"><xsl:value-of select="atom:feed/atom:link[@rel='self']/@href"/></div>
    </div>
  </header>

  <div class="guide wrapper">
    <h2>How to Use This RSS Feed</h2>
    <p>Copy the URL above and paste it into any RSS reader app. You'll be notified whenever a new post is published — no email, no algorithm, no spam.</p>
    <ol>
      <li>Install an RSS reader (see suggestions below)</li>
      <li>Click <strong>Subscribe</strong> or <strong>Add Feed</strong></li>
      <li>Paste the URL and save</li>
    </ol>
    <p>Popular RSS readers:</p>
    <div class="apps">
      <span class="app-tag">Feedly</span>
      <span class="app-tag">Inoreader</span>
      <span class="app-tag">NetNewsWire</span>
      <span class="app-tag">Reeder</span>
      <span class="app-tag">Feeder</span>
    </div>
  </div>

  <div class="posts wrapper">
    <div class="posts-heading">Recent Posts</div>
    <xsl:for-each select="atom:feed/atom:entry">
      <div class="post-item">
        <a href="{atom:link/@href}"><xsl:value-of select="atom:title"/></a>
        <div class="post-date"><xsl:value-of select="substring(atom:published, 1, 10)"/></div>
      </div>
    </xsl:for-each>
  </div>

  <footer>
    <div class="wrapper">
      <p>&#169; 2026 Marginal Lab &middot; <a href="https://marginallabs.github.io">Back to site</a></p>
    </div>
  </footer>
</body>
</html>
</xsl:template>
</xsl:stylesheet>
