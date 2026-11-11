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

## generated

- `index.html` whats-new — lifted from `git log` subjects at
  build time by `_plugins/news.rb`. the commit voice is the
  news voice.

## props

- `index.html` front matter `feature:` — the pinned piece on
  the front door, a slug from `_pieces`.
- `_includes/rail.html` — the visitor count is a prop, not a
  real number.
