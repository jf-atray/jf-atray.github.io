# {% sitemap %} draws _data/map.yml as a colored ascii tree.
# urls resolve to real anchors, an the map self-polices:
# a node naming a missing page warns, an any page absent
# from the map warns too. it cannot quietly drift.
module Jekyll
  class SitemapTag < Liquid::Tag
    def render(context)
      site = context.registers[:site]
      pages = site.pages.map { |p| norm(p.url) }
      mapped = {}
      lines = [[site.config['title'].to_s, nil, 0]]
      walk(site.data['map'], '', lines, mapped, pages, site)
      check_unmapped(pages, mapped, site)
      draw(lines, site)
    end

    private

    def norm(url)
      url.length > 1 ? url.sub(%r{/$}, '') : url
    end

    # prefix is the accumulated continuation chars for this
    # level. between siblings a spacer line keeps the columns
    def walk(nodes, prefix, lines, mapped, pages, site)
      nodes.each_with_index do |n, i|
        last = i == nodes.size - 1
        url = n['url'].to_s
        if url.start_with?('/')
          Jekyll.logger.warn 'sitemap:', "#{url} got no page" unless pages.include?(norm(url))
          mapped[norm(url)] = true
        end
        kids = n['children']
        kids ||= era_children(site) if n['expand'] == 'era'
        lines << [n['name'].to_s, n['note'].to_s, prefix, last, url.empty? ? nil : url]
        walk(kids, prefix + (last ? '   ' : '│  '), lines, mapped, pages, site) if kids
        lines << [:branch, prefix] unless last
      end
    end

    def era_children(site)
      site.pages.select { |p| p.url =~ %r{^/pieces/era-.+\.html$} }
        .sort_by { |p| p.url }
        .map { |p| { 'name' => p.data['title'], 'url' => p.url } }
    end

    def check_unmapped(pages, mapped, site)
      skip = %w[/404.html /map.html]
      (pages - mapped.keys - skip)
        .reject { |u| u.start_with?('/art/', '/assets/', '/feed') }
        .each { |u| Jekyll.logger.warn 'sitemap:', "#{u} aint on the map" }
    end

    def draw(lines, site)
      nodes = lines.select { |l| l.is_a?(Array) && l[2].is_a?(String) }
      maxw = nodes.map { |n, _n, pre, _l, _u| pre.length + 3 + n.length }.max.to_i
      out = +%(<pre class="xterm sitemap">)
      lines.each do |l|
        if l[0] == :branch
          out << %(<span class="sm-b">#{l[1]}│</span>\n)
          next
        end
        name, note, prefix, last, url = l
        unless prefix.is_a?(String)
          out << %(<span class="sm-r">#{name}</span>\n)
          next
        end
        conn = last ? '└─ ' : '├─ '
        cls = prefix.empty? ? 'sm-n' : 'sm-l'
        label = url ? %(<a href="#{site.baseurl}#{url}">#{name}</a>) : name
        out << %(<span class="sm-b">#{prefix}#{conn}</span><span class="#{cls}">#{label}</span>)
        if note && !note.empty?
          out << ' ' * (maxw - prefix.length - 3 - name.length + 2)
          out << %(<span class="sm-z">#{note}</span>)
        end
        out << "\n"
      end
      out << '</pre>'
    end
  end
end

Liquid::Template.register_tag('sitemap', Jekyll::SitemapTag)
