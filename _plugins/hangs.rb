# doc.data[hung_in] feeds the hangs in line on piece.html
Jekyll::Hooks.register :site, :post_read do |site|
  pcs = site.collections['pieces']&.docs || []
  own = pcs.to_h { |d| [d.data['slug'], d] }
  out = Hash.new { |h, k| h[k] = [] }

  put = lambda do |doc, pg|
    next if doc.equal?(pg)
    e = { 'title' => pg.data['title'] || pg.name, 'url' => pg.url }
    out[doc] << e unless out[doc].any? { |x| x['url'] == e['url'] }
  end

  (site.pages + site.documents).each do |pg|
    says = Array(pg.data['pieces']).map(&:to_s)
    says << pg.data['feature'].to_s if pg.data['feature']
    says.each do |s|
      if (d = own[s])
        put.call(d, pg)
      else
        Jekyll.logger.warn 'hangs:', "#{pg.relative_path} claims piece '#{s}', no such slug"
      end
    end

    pg.content.to_s.scan(/\{%\s*xterm_file\s+["']?([^"'%}\s]+)/) do |(raw)|
      s = File.basename(raw).sub(/\.(md|txt)\z/, '')
      put.call(own[s], pg) if own.key?(s)
    end
  end

  out.each { |doc, list| doc.data['hung_in'] = list }
end
