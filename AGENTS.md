# agents notes

## build

    bundle exec jekyll build    # output in _site
    bundle exec jekyll serve    # local preview

## shape

jekyll 4 site. the art renderer lives in `_plugins/xterm_art.rb`
(`{% xterm %}` inline, `{% xterm_file x.txt %}` from `art/`),
pieces are a flat collection in `_pieces/`, curated views are
loose files in `pieces/`.

`art/` holds finished renderable work only. process material,
drafts, frameworks, discovery notes, lives in `art/_drafts/`:
the renderer cant reach it there (basename lookup) and jekyll
wont publish it (underscore dir). split files at the authors
own divider walls.

## writing

- a post: `_posts/YYYY-MM-DD-slug.md` with `title:` only.
  layout, parent crumb, an `/posts/slug/` url come from the
  defaults scope. renders newest first, groups by year.
  `_drafts/` hides work in progress (`serve --drafts`).
  posts dated past the build clock skip with a warning.
- a page: a file with `title:` plus a node in `_data/map.yml`
  or the sitemap build warns it is unmapped. top level nav
  is hardcoded in `_layouts/default.html`.
- a piece: `_pieces/slug.md` with `title:` an `era:`
  (`date:` adds a datemark to the museum label). the body is
  markdown, `{% xterm_file name.txt %}` takes `cap:left` or
  `cap:right` for margin captions, `{% xterm %}` works inline.
  the ribbon walks filename order; renaming a file reorders
  the gallery. view pages list slugs, the piece names nothing.
- kramdown passes ascii through: straight quotes stay
  straight, `--` an `...` stay literal.
- machinery notes: `_drafts` is posts-only, collections use
  `published: false` or files outside the dir. collection
  `order:` (explicit list) an `sort_by:` (data key) exist in
  config if curation order ever leaves the filename.

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
