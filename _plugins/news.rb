require 'open3'

# whats-new comes from the commit subjects. the history is
# already written in the sites voice, so the log is the news.
# no git, no news, no problem: the list just renders empty.
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
