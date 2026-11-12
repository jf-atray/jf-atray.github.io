# agents notes

## build

    bundle exec jekyll build    # output in _site
    bundle exec jekyll serve    # local preview, auto-regenerates

## voice

site copy is toast voice. lowercase, small sentences, . an ,
nothin else for punctuation. opinions not disclaimers, one
thought per line, no analogies, no surveys, no reportin what
the page already says. the webmaster is jonf or the webmaster,
never he or him. characters inside the art keep whatever
pronouns they got, thats fiction an hands off.

the placeholders that ask for jonfs words r jonfs to write.
dont ghostwrite the webmaster.

## shape

jekyll 4 site. the art renderer is `_plugins/xterm_art.rb`
(`{% xterm %}` inline, `{% xterm_file x.txt %}` from `art/`).
pieces r a flat collection in `_pieces/`, curated views r
loose files in `pieces/`.

`art/` is finished renderable work only. process material,
drafts, frameworks, discovery notes go in `art/_drafts/`:
the renderer cant reach it there (basename lookup) an jekyll
wont publish it (underscore dir). split files at the authors
own divider walls. `notes/` is excluded from the build, more
process junk can stay there.

art lines over `xterm_max_width` (80 in config) warn at
build. set `xterm_max_strict: true` to make em fail instead.

## writing

- a post: `_posts/YYYY-MM-DD-slug.md` with `title:` only.
  layout, parent crumb, an `/posts/slug/` url come from the
  defaults scope. renders newest first, groups by year.
  `_drafts/` hides work in progress (`serve --drafts`).
  posts dated past the build clock skip with a warning.
- a page: a file with `title:` plus a node in `_data/map.yml`
  or the sitemap build warns it is unmapped. top level nav
  is hardcoded in `_layouts/default.html`. `lx:` in front
  matter picks a body class (`marg` for margin notes,
  `caps-l` on piece pages).
- a piece: `_pieces/slug.md` with `title:` an `era:`
  (`date:` adds a datemark to the museum label). the body is
  markdown, `{% xterm_file name.txt %}` takes `cap:left` or
  `cap:right` for margin captions, `{% xterm %}` works inline.
  the ribbon walks filename order; renaming a file reorders
  the gallery. view pages list slugs, the piece names nothing.
  `comments:` (list of `who:` + `text:`) puts a folded
  museum-comments block under the piece on its own page.
  `comments_open: true` opens it by default. walls an
  catalogue dont show em, the front door feature does.
- an era wall: `pieces/era-X.md` w `layout: era` an `era: X`.
  it lists its own pieces, needs no body.
- a recipe: `_recipes/slug.md` w `title:`. the pantry page
  lists em, empty till the first dish.
- kramdown passes ascii through: straight quotes stay
  straight, `--` an `...` stay literal.
- machinery notes: `_drafts` is posts-only, collections use
  `published: false` or files outside the dir. collection
  `order:` (explicit list) an `sort_by:` (data key) exist in
  config if curation order ever leaves the filename.
- section indexes get the views strip from
  `_includes/views.html`, it lists sibling pages by dir.

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
  cache so a dead api never blanks the wall. still points at
  the placeholder post till jonf makes a real one.

## props

- `index.html` front matter `feature:`, the pinned piece on
  the front door, a slug from `_pieces`.
- `_includes/rail.html`, the visitor count hotlinks xbawx.com
  an counts for real.
- `/toast/` is my room. knock first.
