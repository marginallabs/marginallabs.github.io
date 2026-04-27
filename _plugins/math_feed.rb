# Replaces LaTeX math in feed.xml with Codecogs <img> tags.
# Runs after site build. Fallback: alt attribute shows raw LaTeX if image fails.
require 'cgi'

Jekyll::Hooks.register :site, :post_write do |site|
  feed_path = File.join(site.dest, 'feed.xml')
  return unless File.exist?(feed_path)

  content = File.read(feed_path)

  # Display math: \[...\] and $$...$$
  content = content.gsub(/\\\[([\s\S]*?)\\\]/) { |m| build_img($1.strip) }
  content = content.gsub(/\$\$([\s\S]*?)\$\$/)   { |m| build_img($1.strip) }

  # Inline math: \(...\)
  content = content.gsub(/\\\(([\s\S]*?)\\\)/) { |m| build_img($1.strip) }

  # Inline math: $...$ (not currency — must contain at least one non-digit/non-space char)
  content = content.gsub(/(?<!\$)\$(?!\$)([^\$\n]+?[\\{}\^_\/])\$(?!\$)/) { |m| build_img($1.strip) }

  File.write(feed_path, content)
end

def build_img(latex)
  url = "https://latex.codecogs.com/png.latex?#{CGI.escape(latex)}"
  alt = latex.gsub('&', '&amp;').gsub('<', '&lt;').gsub('>', '&gt;').gsub('"', '&quot;')
  "<img src=\"#{url}\" alt=\"#{alt}\" style=\"vertical-align: middle;\" />"
end
