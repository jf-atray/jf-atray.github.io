require 'open3'

# whats-new reads commit subjects. the history is in my
# voice so the log IS the news. no git no news, renders
# empty an nobody dies.
module Jekyll
  class News < Generator
    safe true
    priority :high

    def generate(site)
      out, st = Open3.capture2('git', 'log', '-n', '12',
        '--date=short', '--format=%ad|%s', chdir: site.source)
      site.data['news'] = st.success? ? out.lines.map { |l|
        d, s = l.chomp.split('|', 2)
        { 'date' => d, 'msg' => s.to_s }
      } : []
    end
  end
end
