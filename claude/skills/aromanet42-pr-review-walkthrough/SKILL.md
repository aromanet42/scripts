---
name: aromanet42-pr-review-walkthrough
description: Use when addressing GitHub PR review comments from one or more reviewers — deciding whether each comment is valid, fixing it, replying to the reviewer, and committing the changes per reviewer.
---

# PR Review Walkthrough (aromanet42)

## Overview

Process every review comment on a GitHub PR interactively, **one comment at a time**, grouped by author. Each comment gets its own analysis, its own discussion with the user, and its own approval gate before anything is changed. Comments are never batch-processed and the user's decision is never assumed or invented.

## When to use

- The user wants to work through PR review comments/feedback with you.
- Multiple reviewers left comments that need answers and/or fixes.

Not for: a quick "just apply all the cosmetic nits" pass with no discussion — this skill's whole point is a human-in-the-loop decision per comment, so if that loop isn't wanted, this isn't the right skill.

## Invocation

```
/aromanet42-pr-review-walkthrough [PR number or URL]
```

If omitted, auto-detect the PR from the current branch via `gh pr view`. If none is found, ask the user for the PR number or URL — do not guess.

## The rule this skill exists to enforce

**Every comment gets analyzed, discussed, and approved individually. Never fabricate the user's answer, never bundle multiple comments' fixes together, never move to the next comment without an explicit go-ahead from the user — even under time pressure.**

If the user says "hurry", "just batch it", "skip the back-and-forth": say plainly that you'll still go comment-by-comment, then proceed comment-by-comment anyway. Speed pressure is exactly the scenario this skill is guarding against, not an exception to it.

| Excuse | Reality |
|---|---|
| "User's in a hurry, I'll bundle a few comments together" | Bundling defeats the one-at-a-time review this skill exists for. Go one at a time anyway. |
| "The fix is obviously correct, I can skip the discussion" | Every comment gets the same protocol regardless of how obvious the fix looks. |
| "I'll guess a plausible answer so I don't stall" | Never invent the user's decision. Stop and wait for real input. |
| "I'll post one combined reply for all of this author's comments" | One GitHub reply per comment, always. |
| "I'll use the repo's usual JIRA-ticket commit convention" | The commit message for this skill is fixed: `fix: {author} review`, no ticket prefix, no exceptions. |

Red flags — stop if you notice yourself about to: move to the next comment without the user having replied; write one commit spanning two authors; post one combined "fixed a few things" reply instead of per-comment replies.

## Step 1 — Identify the PR

```bash
gh pr view [PR_NUMBER] --json number,title,baseRefName,headRefName,commits
```

If no PR number was given, run `gh pr view` against the current branch. If that fails, ask the user.

## Step 2 — Fetch every comment

Pull from all three sources — none should be skipped (then drop the ignorable bot comments, see below). Run each command on its own, never chained with `&&` or `;`:

**Inline review threads** (grouped by thread, with resolution status and the diff context):
```bash
gh api graphql -F owner="{owner}" -F repo="{repo}" -F pr={n} -f query='
  query($owner: String!, $repo: String!, $pr: Int!) {
    repository(owner: $owner, name: $repo) {
      pullRequest(number: $pr) {
        reviewThreads(first: 100) {
          nodes {
            isResolved
            comments(first: 100) {
              nodes { databaseId body author { login } path line diffHunk createdAt }
            }
          }
        }
      }
    }
  }
'
```
Skip any thread where `isResolved` is `true` — it's already handled.

Use the `diffHunk` field, not the `line` number, to locate the code being discussed — inline comments anchor to a commit snapshot and line numbers can drift as the branch evolves. Read the current file for up-to-date context, but identify *which* code the comment is about from `diffHunk`.

**Formal review bodies** (APPROVED/CHANGES_REQUESTED/COMMENTED with a written summary):
```bash
gh api repos/{owner}/{repo}/pulls/{n}/reviews
```
Only reviews with a non-empty `body` count as a comment to process.

To read the patch of a single file of the PR (`gh pr diff` accepts no path argument):
```bash
gh api repos/{owner}/{repo}/pulls/{n}/files --paginate --jq '.[] | select(.filename | endswith("...")) | .patch'
```

**Top-level PR conversation comments:**
```bash
gh pr view {n} --json comments
```

### Ignore global comments from bots

Ignore **global** comments (formal review bodies and top-level conversation comments) written by bots — an author whose type is `Bot` or whose login ends in `[bot]`, plus `github-actions`. They are summaries or CI results that add nothing to process. Keep **inline** threads from bots (e.g. `copilot-pull-request-reviewer`): those are real findings.

Tell the user in one line what was ignored ("ignoring 2 bot comments: ...") so they can override.

## Step 3 — Group by author

Group every comment gathered in Step 2 (inline + formal review body + top-level) by the comment author's login, after normalizing it: the sources disagree on the login of the same author (`copilot-pull-request-reviewer` in GraphQL, `copilot-pull-request-reviewer[bot]` in the REST reviews), so strip a trailing `[bot]` before grouping. Process authors in whatever order they first appear.

## Step 4 — Per author, per comment

For each author, for each of their comments in order:

1. **Display** the comment verbatim: author, location (`file:line`, or "general PR comment" / "review summary" if not inline), and the full comment text.
2. **Analyze**: is this pertinent? Classify it — bug, enhancement, nit, false positive/misunderstanding, or already fixed elsewhere — and state your reasoning.
3. **State a suggested fix**, or explicitly say no fix is needed and why.
4. **Stop.** Let the user respond: ask questions, challenge the analysis, request more detail. Keep discussing as long as they want. Do not treat your own steps 1–3 as approval, and do not proceed on a guessed answer.
5. Once the user has told you what to do, **do exactly that** (fix as suggested, fix differently, or no fix).
6. **Summarize concisely** what was actually done, or confirm nothing was changed.
7. **Stop again.** Wait for the user's explicit go-ahead before touching the next comment.

After all of one author's comments are resolved this way, and before moving to the next author:

- Reply on GitHub to **each of that author's comments individually** (Step 5 below).
- Make **exactly one commit** covering all of that author's approved fixes (Step 6 below).

## Step 5 — Reply on GitHub, one reply per comment

For a fixed comment: reply `Fixed` (add one short clause only if the fix meaningfully diverged from the suggestion, e.g. `Fixed — renamed to unroundedRefundAmount`). For a not-fixed comment: a concise one-line explanation of why. Never combine multiple comments' outcomes into a single reply. Never put a commit SHA in a reply: replies are posted before the user pushes, so GitHub cannot resolve it.

```bash
# Inline review comment thread:
gh api repos/{owner}/{repo}/pulls/{n}/comments/{comment_id}/replies -X POST -f body="..."
# Top-level comment or formal review body:
gh api repos/{owner}/{repo}/issues/{n}/comments -X POST -f body="..."
```

## Step 6 — One commit per author

Invoke the `git-commit` skill (required before any commit) but use exactly this message, regardless of the repo's normal commit convention (no JIRA/ticket prefix):

```
fix: {author} review
```

Stage only the files touched while addressing this author's comments.

## Quick reference

| Situation | Action |
|---|---|
| Thread already resolved | Skip, don't reanalyze |
| Comment's line number looks stale | Use `diffHunk` to find the real target |
| User hasn't replied yet | Do nothing, wait |
| Author's last comment just got approved | Reply to each of their comments, then one commit, then move to next author |
| Committing | Use the `git-commit` skill, message exactly `fix: {author} review` |

## Common mistakes

- Skipping the discussion step because the fix "seems obvious."
- Replying to GitHub once for an author instead of once per comment.
- Using the repo's usual commit convention (e.g. a JIRA prefix) instead of the fixed `fix: {author} review` format.
- Re-analyzing a comment on an already-resolved thread.
- Moving to the next comment or author without an explicit user go-ahead.
