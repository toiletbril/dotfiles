---
name: resolve-conflicts
description: Resolve git merge conflicts in one or more files, commit each resolution on its own branch (or all on a single branch), and open a PR per branch. Use when the user asks to resolve conflicts, finish a sync merge, or split conflict resolutions into per-file PRs.
argument-hint: <file1> [file2 ...] | all [target-branch]
allowed-tools:
  - Bash(git log *)
  - Bash(git show *)
  - Bash(git diff *)
  - Bash(git status *)
  - Bash(git branch *)
  - Bash(git switch *)
  - Bash(git checkout *)
  - Bash(git add *)
  - Bash(git commit *)
  - Bash(git push *)
  - Bash(git ls-remote *)
  - Bash(git rev-parse *)
  - Bash(git blame *)
  - Bash(grep *)
  - Bash(awk *)
  - Bash(gh pr create *)
  - Bash(gh pr view *)
  - Bash(gh auth status *)
  - Read
  - Edit
  - Write
---

# /resolve-conflicts

Resolves git merge conflicts in the listed files and ships each resolution
as its own PR. Default workflow assumes the conflicts come from a sync
merge between an upstream branch and a long-lived fork branch.

Arguments: `$ARGUMENTS`

- `<file1> [file2 ...]` -- resolve conflicts only in those files.
- `all` -- resolve every file in the working tree that has conflict markers.
- A trailing path that looks like a branch (no slash matching a real file)
  is treated as the **target branch** for PRs. If omitted, infer it from
  the current branch name or ask the user.

---

## Steps

### 1. Locate conflicts

```bash
git status -s
grep -rln "^<<<<<<< HEAD" <files-or-tree>
grep -n "<<<<<<<\|^=======\|>>>>>>> " <file>   # per file, list hunk lines
```

If `all` was passed, scan the whole working tree under `src/` (or the repo
root). Refuse to continue if there are zero conflict markers.

Identify the two sides of every hunk. The `<<<<<<< HEAD` side is the
fork's code, the `>>>>>>> <hash>` side is the incoming upstream commit.
Record the incoming hash -- it will be the base for citing upstream
commits later.

### 2. Trace each hunk to its origin commits

For every hunk, find:

- The **upstream commit** that introduced the conflicting upstream change.
  Usually the merge-in commit hash itself, or a recent ancestor that
  touched the same lines. Use:

  ```bash
  git log --oneline <incoming-hash> -- <file>
  git log --oneline --all -S '<symbol-or-string-from-upstream-side>' -- <file>
  git show <hash> -- <file>
  ```

- The **fork commit** that introduced the fork-specific code. Use the same
  `git log -S` form against tokens that only appear on the HEAD side
  (function names, GUC names, custom helpers). Fall back to
  `git blame` on the file in the pre-merge HEAD when `-S` is too noisy.

Record short hashes for both. They will go into the commit body.

### 3. Decide per-hunk resolution

For each hunk, pick one of: **take HEAD**, **take upstream**, or
**combine**. Justify with what the surrounding code (still in the file
and not in conflict) actually uses -- a function signature already
committed below the hunk dictates what the prototype above must say,
and so on.

Watch for two recurring traps:

- **Dropped declarations.** A 3-way merge can silently delete a local
  variable declaration whose only remaining users live on one side of a
  conflict. Diff against the pre-merge HEAD with
  `git show <pre-merge-HEAD-hash>:<file>` and confirm every local that
  the chosen resolution references is still declared.
- **Newly dead locals.** Conversely, the upstream side may have added a
  local that becomes unused once HEAD's branch is taken. Remove it, or
  the build will fail under `-Werror=unused-variable`.

### 4. Identify linked files

Other conflicted files in the tree that resolve symbols referenced by
the chosen resolutions (extern declarations, signatures, GUC defs) are
**linked**. Grep them out of the conflict-marker list:

```bash
grep -rln "^<<<<<<< HEAD" src/ | xargs -I{} grep -l "<symbol>" {}
```

The skill does **not** edit linked files, but it must list them so the
user knows what other PRs need to land for the resolution to compile.

### 5. Present the plan

Print one Markdown table per file:

| # | Lines | HEAD | Upstream | Resolution |
| - | ----- | ---- | -------- | ---------- |

Then a single linked-files table:

| File | Lines | Linked symbol | Why it matters |
| ---- | ----- | ------------- | -------------- |

Stop and wait for the user to approve. Do not edit anything yet.

### 6. Ask about branch layout

After approval, ask **exactly one** question:

> One branch for everything, or one branch per file with an iota suffix?
> What branch name should I use?

Accept either:

- A single name like `ADBDEV-9799` -- all commits go on that one branch.
- A name with `<iota>` placeholder like `ADBDEV-9799-<iota>` -- create
  `ADBDEV-9799-1`, `ADBDEV-9799-2`, ... one per file in the order the user
  listed them.

### 7. Resolve, commit, push, PR -- one file at a time

For each file (in order):

1. `git switch <target-branch> && git switch -c <branch>` (per-iota
   layout) or `git switch <branch>` if the single branch already exists.
2. Replace each conflict marker block with the chosen resolution using
   the `Edit` tool. Verify no markers remain:

   ```bash
   grep -n "<<<<<<<\|>>>>>>>\|=======" <file>
   ```

3. `git add <file>` then `git commit -m "$(cat <<'EOF' ... EOF)"` with
   the body format below.
4. `git push -u origin <branch>`.
5. `gh pr create --base <target-branch> --title "<subject>" --body "$(git log -1 <branch> --format='%B')"`.
   The PR body must equal the commit message verbatim, subject line
   included.

Commit message format -- match the project's existing resolve-conflict
commits. Subject is imperative, no period, 50-70 chars:

```
Resolve conflicts in <relative/path/to/file>

Commit <upstream-short> <one-clause description of upstream change>,
while earlier commit <fork-short> <one-clause description of fork code>
in the same place.

[optional: one short paragraph stating what was kept and any extra
edits made for the file to compile, e.g. restored declarations or
removed dead locals.]
```

If multiple upstream or fork commits contributed, list them and keep
the prose flowing -- no bullets, no semicolons, finite clauses only.

### 8. Verify

After all PRs are open:

```bash
gh pr view <number> --json author,title,baseRefName,headRefName,url
```

Confirm the `author.login` matches the user's intended GitHub account
(the gh CLI's active account). If `gh auth status` shows a different
active account, stop and ask the user to switch with
`gh auth switch -u <login>` before retrying.

Print a summary table:

| No | Branch | PR | Title |
| -- | ------ | -- | ----- |

---

## Notes

- Never edit `git config`. If `git config user.name` looks wrong, ask
  the user to fix it before committing -- do not override.
- Never push with `--force` or skip hooks. The fork's CI may run on
  push and the user will want to see the result.
- Linked files are read-only in this skill. If the user wants them
  resolved too, they should re-invoke the skill with those files in the
  argument list.
- A single hunk can hide multiple changes (a comment rename + a function
  signature change at the same line). Treat each logical change as a
  separate row in the per-file table even when they share a hunk.
- If the file has only comment-level conflicts, the resolution is still
  worth its own commit -- comment drift across forks is a real source
  of confusion later.
- The `iota` suffix starts at 1, not 0.
