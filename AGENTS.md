# .dotfiles

Instructions for coding agents working in this repo. `CLAUDE.md` imports this file, so Claude Code reads it too.

My macOS setup. This repo is **public**, so nothing private may ever be committed.

## Layout

- `.zshrc`, `.zprofile`, `.gitconfig`: symlinked from the home folder (`~/.zshrc -> ~/.dotfiles/.zshrc`), so editing either path edits the repo file.
- `Brewfile`: generated, never edited by hand.
- `lunar/fyi.lunar.Lunar.plist.xml`: Lunar display settings, written by `scripts/lunar-backup.sh`.
- `scripts/lunar-backup.sh`, `scripts/lunar-restore.sh`: save and apply Lunar settings.
- `.claude/skills/fix-monitor/`: steps for when the external monitor is not detected (a Claude Code skill, but plain Markdown any agent can follow). It is symlinked into `~/.claude/skills/` so it works from any folder.
- `Raycast.rayconfig`: Raycast export, imported by hand.
- `README.md`: the new Mac setup guide. Keep it in sync when something here changes.

## Secrets

- `.zshrc` holds a real `GOOGLE_API_KEY` locally. In git it must always be `export GOOGLE_API_KEY=**********`.
- To commit other `.zshrc` changes, stage a copy with the placeholder and leave the working file alone:

  ```bash
  h=$(sed 's/^export GOOGLE_API_KEY=.*/export GOOGLE_API_KEY=**********/' .zshrc | git hash-object -w --stdin)
  git update-index --cacheinfo 100644,$h,.zshrc
  ```

  Then check `git show :.zshrc | grep AIza` prints nothing before committing. After the commit, `.zshrc` shows as modified again because of the key. That is expected.
- `secrets.txt` and `.claude/settings.local.json` are gitignored. Never stage them.
- Before every commit, scan the staged diff: `git diff --cached | grep '^+' | grep -iE 'AIza|api_?key|secret|token|password'`.
- When editing `.gitignore`, make sure the last line ends with a newline before appending, or the new entry joins the previous one.

## Common tasks

**Update the Brewfile**

```bash
brew bundle dump --file ~/.dotfiles/Brewfile --force
```

Do not pass `--describe` (removed in Homebrew 7). Review `git diff Brewfile` and mention what was added or removed.

**Back up Lunar settings** after changing them: `./scripts/lunar-backup.sh`. It strips the API key, location and licence data. Keep `updateChannel` at `0` (stable). It was once switched to `1` (beta), which pulled in a Lunar 7 beta.

**External monitor not detected**: follow `.claude/skills/fix-monitor/SKILL.md`.

## Commits

- Plain message: a subject line and an optional body. Never add `Co-Authored-By` or any Claude or Anthropic trailer.
- Commits are GPG signed (`commit.gpgsign = true` in `.gitconfig`).
- Stage files by name, not `git add -A`, so local only changes do not slip in.
- Branch is `main`, pushed straight to `origin`.

## Writing style

No em dashes or en dashes in prose, comments or commit messages. Keep wording plain.
