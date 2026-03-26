# Personal Claude preferences — Audrey Romanet

## Git commit messages

Three accepted formats:
- **Conventional commits**: `feat: summary`, `fix: summary`, `chore: summary`, etc.
- **Mirakl format**: `[JIRA-123] Summary`
- **Mixed**: `feat(JIRA-123): Summary`, `fix(JIRA-123): Summary`

### Which format to use

1. Check the project's `AGENTS.md` / `CLAUDE.md` first — it may specify a format.
2. If nothing there, look at the last 10 commits (`git log --oneline -10`) to detect the pattern in use.
3. If still unclear, ask me.

**Rules of thumb by repo type:**
- `app-*` repositories → Mirakl format (`[JIRA-123] Summary`)
- Helm manifests (`chart/` folder) → always conventional commits, always `feat` or `fix` (triggers release-please)
- Helm manifests (`instances/` folder) → always conventional commits, always `chore`

## Git branches

- **Never commit on `master`.**
- If the current branch is `master`, always ask me what name to use for a new branch before doing anything.
- If the current branch is not `master`, always ask me whether this is the correct branch before starting work.

## Git history

- For simple tasks: **one commit only**.
- For complex tasks: analyse whether multiple commits make sense, then confirm with me before splitting.
- During iterative work, you may create intermediate commits using autosquash prefixes (`fixup!`, `squash!`), then consolidate with `git rebase --autosquash`.
- **Never use `git reset` to undo work without my explicit consent.**
