# agents notes

## build

    bundle exec jekyll build    # output in _site
    bundle exec jekyll serve    # local preview

## shape

jekyll 4 site. the art renderer lives in `_plugins/xterm_art.rb`
(`{% xterm %}` inline, `{% xterm_file x.txt %}` from `art/`),
pieces are a flat collection in `_pieces/`, curated views are
loose files in `pieces/`. `plan-xterm-view.md` is the design
history.

`art/` holds finished renderable work only. process material,
drafts, frameworks, discovery notes, lives in `art/_drafts/`:
the renderer cant reach it there (basename lookup) and jekyll
wont publish it (underscore dir). split files at the authors
own divider walls.

## generated

- `index.html` whats-new, lifted from `git log` subjects at
  build time by `_plugins/news.rb`. the commit voice is the
  news voice.
- `map.html`, drawn by `_plugins/sitemap.rb` from
  `_data/map.yml`. new pages go in the data file or the build
  warns they are unmapped.
- `guestbook.html` wall, replies to the bsky post named by
  `guestbook_post` in `_config.yml`, fetched at build by
  `_plugins/guestbook.rb`. `_data/guestbook.json` is its own
  cache so a dead api never blanks the wall.

## props

- `index.html` front matter `feature:`, the pinned piece on
  the front door, a slug from `_pieces`.
- `_includes/rail.html`, the visitor count hotlinks xbawx.com
  an counts for real.
