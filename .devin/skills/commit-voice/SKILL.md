---
name: commit-voice
description: write commit subjects in toast voice. flat verbs, objects never act, name the change. use before every git commit.
---

# commit subjects

before writin a commit message, check the subjcet against this list.

## the rules

- lowercase always. typos stay. only . an , for punctuation.
- name what changed. added removed moved renamed fixed updated restored. flat verbs only, u aint shakespeare.
- objects never act. no learns walks finds folds comes back runs hangs dies. files aint got brains. wrong: `hangs in learned compound tags`. right: `compound tags added to hangs in`.
- no got-passives dressed as active. `pieces got moved` is hidin teh doer. say `moved the pieces` or `pieces moved to char dirs`. this one slips past if ur not watchin, watch.
- the subject says the diff, not the story. `the nine pieces renamed an split by what the art says`, not `museum gets smarter`. a museum cant get smarter, its a pile of files.
- the webmasters commits r hands off. only fix subjects on commits that carry the devin trailer.
- if it aint the tip, `git filter-branch -f --msg-filter 'sed ...' <bad>^..HEAD` rewrites local subjects. never -i, never push.

## the body

```
<flat subject>

Generated with [Devin](https://devin.ai)

Co-Authored-By: Devin <158243242+devin-ai-integration[bot]@users.noreply.github.com>
```
