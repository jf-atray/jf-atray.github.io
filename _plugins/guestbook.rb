require 'net/http'
require 'json'
require 'uri'

# the guestbook wall lives on bluesky. replies to the post in
# site.guestbook_post are the signatures, rendered at build the
# same way the news feed reads git log. on a failed fetch the
# last good wall stands in: _data/guestbook.json is our own
# cache, loaded by jekyll before we run.
module Jekyll
  class Guestbook < Generator
    safe true
    priority :low

    def generate(site)
      url = site.config['guestbook_post']
      return unless url
      m = url.match(%r{bsky\.app/profile/([^/]+)/post/([^/?]+)})
      return Jekyll.logger.warn('guestbook:', "cant parse post url #{url}") unless m
      handle, rkey = m.captures
      api = URI("https://public.api.bsky.app/xrpc/app.bsky.feed.getPostThread" \
        "?uri=at://#{handle}/app.bsky.feed.post/#{rkey}&depth=1")
      begin
        res = Net::HTTP.get_response(api)
        raise res.code unless res.is_a?(Net::HTTPSuccess)
        thread = JSON.parse(res.body)['thread']
        root_did = thread.dig('post', 'author', 'did')
        site.data['guestbook'] = (thread['replies'] || []).filter_map do |r|
          p = r['post'] or next
          next if p.dig('author', 'did') == root_did
          text = p.dig('record', 'text').to_s.strip
          next if text.empty?
          {
            'handle' => p.dig('author', 'handle'),
            'name' => p.dig('author', 'displayName') || p.dig('author', 'handle'),
            'avatar' => p.dig('author', 'avatar'),
            'text' => text,
            'date' => p.dig('record', 'createdAt').to_s[0, 10],
            'url' => "https://bsky.app/profile/#{p.dig('author', 'handle')}/post/#{p['uri'].split('/').last}",
          }
        end
        cache = File.join(site.source, '_data', 'guestbook.json')
        body = JSON.pretty_generate(site.data['guestbook'])
        File.write(cache, body) unless File.exist?(cache) && File.read(cache) == body
      rescue => e
        Jekyll.logger.warn 'guestbook:', "fetch failed (#{e.message}), serving the cache"
      end
    end
  end
end
