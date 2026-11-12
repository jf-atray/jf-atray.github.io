require 'cgi'

# the markup, the full lotj spec from `help colors`:
# && literal amp, &NNN xterm256 fg -> class cNNN,
# &#RRGGBB and &RRR.GGG.BBB truecolor -> inline style,
# named 16 map onto palette classes c000-c015,
# &I &U attrs, &D reset, &k keyword pair toggle, &? random.
# ^NNN and ^#RRGGBB are the same grammar on the background
# channel (class bNNN / inline background). &D clears both.
module Jekyll
  module XtermArt
    NAMED = {
      'x'=>'c000','r'=>'c001','g'=>'c002','O'=>'c003','b'=>'c004','p'=>'c005',
      'c'=>'c006','w'=>'c007','z'=>'c008','R'=>'c009','G'=>'c010','Y'=>'c011',
      'B'=>'c012','P'=>'c013','C'=>'c014','W'=>'c015',
    }.freeze
    RE = /(&&|\^#[0-9a-fA-F]{6}|\^\d{3}|&\d{1,3}\.\d{1,3}\.\d{1,3}|&#[0-9a-fA-F]{6}|&\d{3}|&[^\s])/m

    # how many visible columns a token adds. nil = plain text,
    # measured by the caller since it can hold newlines.
    # mirrors render()'s dispatch; both must agree forever.
    def self.vis_len(tok)
      case tok
      when '&&' then 1
      when /\A(\^#[0-9a-fA-F]{6}|\^\d{3}|&\d{1,3}\.\d{1,3}\.\d{1,3}|&#[0-9a-fA-F]{6}|&\d{3}|&[DIU]|&k|&\?)\z/ then 0
      when /\A&(.)\z/ then NAMED[$1] ? 0 : tok.length
      end
    end

    # visible column width per line.
    def self.widths(src)
      ws = []
      cur = 0
      src.split(RE).each do |tok|
        n = vis_len(tok)
        if n then cur += n
        else
          tok.split("\n", -1).each_with_index do |l, i|
            (ws << cur; cur = 0) if i > 0
            cur += l.length
          end
        end
      end
      ws << cur
      ws
    end

    # the belt for line length: warn on every over long line,
    # xterm_max_strict in config makes it refuse the build.
    def self.check(src, label, site)
      max = site.config['xterm_max_width'].to_i
      return if max <= 0
      bad = widths(src).each_with_index.select { |w, _| w > max }
      return if bad.empty?
      bad.each do |w, i|
        Jekyll.logger.warn 'xterm:', "#{label}:#{i + 1} is #{w} fat cols (limit #{max})"
      end
      raise "nope: #{label} too wide" if site.config['xterm_max_strict']
    end

    # autowrap: over long lines break at the last space before
    # the limit (hard cut if a single word fills it). color
    # state carries across inserted newlines for free because
    # render() never resets state at line breaks.
    def self.wrap(src, site)
      max = site.config['xterm_max_width'].to_i
      return src if max <= 0
      out = String.new
      col = 0
      last_sp = -1
      src.split(RE).each do |tok|
        n = vis_len(tok)
        if n
          out << tok
          col += n
        else
          tok.each_char do |ch|
            if ch == "\n"
              out << ch
              col = 0
              last_sp = -1
            else
              out << ch
              col += 1
              last_sp = out.length - 1 if ch == ' '
              if col > max
                if last_sp >= 0
                  out[last_sp] = "\n"
                  col = out.length - last_sp - 1
                  last_sp = -1
                else
                  out << "\n"
                  col = 0
                end
              end
            end
          end
        end
      end
      out
    end

    # slug -> piece doc, memoized per site object. a linear
    # docs.find per render turns quadratic around a thousand.
    def self.doc_for(site, slug)
      @docmap ||= {}
      docs = (@docmap[site.object_id] ||= site.collections['pieces']&.docs&.to_h { |d| [d.data['slug'], d] })
      docs&.[](slug)
    end

    # width bucket for font scaling: s fits at 14px anywhere,
    # m steps down a point, l (the 80col ceiling zone) two.
    # plus overflow-x: clip, no scrollbar can ever appear.
    def self.wclass(src)
      w = widths(src).max
      w <= 66 ? 'w-s' : w <= 78 ? 'w-m' : 'w-l'
    end

    def self.render(src)
      cls = style = bgcls = bgstyle = nil
      it = ul = kw = false
      out = String.new
      push = lambda do |text|
        next if text.empty?
        t = CGI.escapeHTML(text)
        classes = [cls, bgcls, ('it' if it), ('ul' if ul), ('kw' if kw)].compact.join(' ')
        css = [style, bgstyle].compact.join(';')
        attrs = [
          ( %(class="#{classes}") unless classes.empty? ),
          ( %(style="#{css}") unless css.empty? ),
        ].compact.join(' ')
        out << (attrs.empty? ? t : %(<b #{attrs}>#{t}</b>))
      end
      src.split(RE).each do |tok|
        case tok
        when '&&' then push.call('&')
        when /^&#([0-9a-fA-F]{6})$/ then style = "color:##{$1.downcase}"; cls = nil
        when /^\^#([0-9a-fA-F]{6})$/ then bgstyle = "background:##{$1.downcase}"; bgcls = nil
        when /^\^(\d{3})$/ then bgcls = "b#{$1}"; bgstyle = nil
        when /^&(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/ then
          style = 'color:#' + [$1, $2, $3].map { |n| n.to_i.to_s(16).rjust(2, '0') }.join
          cls = nil
        when /^&(\d{3})$/ then cls = "c#{$1}"; style = nil
        when '&D' then cls = style = bgcls = bgstyle = nil; it = ul = kw = false
        when '&I' then it = true
        when '&U' then ul = true
        when '&k' then kw = !kw
        when '&?' then cls = format('c%03d', rand(256)); style = nil
        when /^&(.)$/ then
          if NAMED[$1] then cls = NAMED[$1]; style = nil
          else push.call(tok)
          end
        else push.call(tok)
        end
      end
      out
    end
  end

  # {% xterm %} colored text {% endxterm %} for inline use in posts.
  class XtermBlock < Liquid::Block
    def render(context)
      src = super
      page = context.registers[:page]['url'] rescue 'page'
      site = context.registers[:site]
      XtermArt.check(src, "xterm block on #{page}", site)
      src = XtermArt.wrap(src, site)
      %(<pre class="xterm #{XtermArt.wclass(src)}">#{XtermArt.render(src)}</pre>)
    end
  end

  # {% xterm_file droid.txt %} or {% xterm_file p.slug %} in a loop;
  # unquoted markup resolves through the context. .txt appended.
  class XtermFileTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      # {% xterm_file droid.txt cap:left %}. first token is the
      # file, rest are options. cap:left/right parks the caption
      # in that margin, default is under the art.
      parts = markup.strip.split(/\s+/)
      @file = parts.shift
      @cap = (parts.find { |o| o.start_with?('cap:') } || '')[4..]
    end

    def render(context)
      site = context.registers[:site]
      name = @file =~ /\A["'](.*)["']\z/ ? $1 : (context[@file] || @file).to_s
      name = name.sub(/\.(md|txt)\z/, '') + '.txt'
      path = File.join(site.source, 'art', File.basename(name))
      unless File.exist?(path)
        raise "xterm_file: no art/#{name}"
      end
      src = File.read(path)
      XtermArt.check(src, "art/#{name}", site)
      src = XtermArt.wrap(src, site)
      body = XtermArt.render(src)
      # pieces carry their museum label everywhere they appear
      # an announce as an image, not two thousand chars of span
      # soup. figure wraps pre+caption so flex rows cant split
      # them. art with no doc (banner etc) stays chrome, an
      # decorative chrome hides from screen readers entirely.
      doc = XtermArt.doc_for(site, File.basename(name, '.txt'))
      unless doc
        return %(<pre class="xterm #{XtermArt.wclass(src)}" aria-hidden="true">#{body}</pre>)
      end
      alabel = CGI.escapeHTML("#{doc.data['title']}. hand colored text")
      pre = %(<pre class="xterm #{XtermArt.wclass(src)}" role="img" aria-label="#{alabel}">#{body}</pre>)
      # datemark is a bare date or nothing; non date values
      # like "uncatalogued" never reach the label
      mark = doc.data['date']
      mark = mark.strftime('%Y-%m-%d') if mark.respond_to?(:strftime)
      mark ||= doc.data['era'] if doc.data['era'] =~ /\A[\d.\/-]+\z/
      # the piece page itself already h1s the title. the
      # caption there only needs the datemark an the link.
      # parts join so nothing renders a leading separator
      parts = []
      parts << %(<span class="cap-t">#{doc.data['title']}</span>) unless context.registers[:page]['layout'] == 'piece'
      parts << mark if mark
      cap = parts.join('. ')
      cap += '. ' unless cap.empty?
      cls = %w[left right].include?(@cap) ? %(xterm-fig cap-#{@cap[0]}) : 'xterm-fig'
      %(<figure class="#{cls}">#{pre}<figcaption class="cap">#{cap}<a href="#{site.baseurl}/art/#{name}" target="_blank" rel="noopener">source</a></figcaption></figure>)
    end
  end
end

Liquid::Template.register_tag('xterm', Jekyll::XtermBlock)
Liquid::Template.register_tag('xterm_file', Jekyll::XtermFileTag)
