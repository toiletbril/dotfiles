---
name: gg-sync
description: Parse a sync-14x patch-tracking spreadsheet, find not-merged PRs missing required approvals, substantively review each, and approve those with no diff concerns. Use when the user points at a sync xlsx and asks to chase missing approvals.
argument-hint: [path-to-xlsx | path-to-csv | pasted rows] (default ~/Downloads/sync-14x-b12.xlsx)
allowed-tools:
  - Bash(python3 *)
  - Bash(gh pr view *)
  - Bash(gh pr diff *)
  - Bash(gh pr review *)
  - Bash(gh auth status *)
  - Bash(git remote *)
  - Bash(git fetch *)
  - Bash(git worktree *)
---

# /gg-sync

Chase missing approvals on the 14x sync patch set.

## Spreadsheet format

Each row is one conflicting file with its PR. Column layout:

`Конфликт | Решает | Пиар | Слито | Георгий | Виктор | Владимир | Максим | Евгений`

- `Конфликт` — the file or failure the patch addresses.
- `Решает` — the patch author (the colleague making the patch).
- `Пиар` — PR link. May instead be free text like `локально не воспроизвелось` (no PR — ignore that row).
- `Слито` — `+` means merged.
- Name columns — reviewers self-add `+` when they approve. `?` means an open, unresolved review.
- Exception: in the author's own name column the author writes the required approval count as a number (`1`, `2`, `3`).

## Input

The argument is one of:

- An `.xlsx` path (or none, defaulting to `~/Downloads/sync-14x-b12.xlsx`).
- A `.csv` path.
- A set of rows pasted directly into the prompt, one row per line, columns
  separated by tabs or runs of whitespace, no header.

Whatever the source, normalize to the same column order:
`Конфликт | Решает | Пиар | Слито | Георгий | Виктор | Владимир | Максим | Евгений`.
Pasted or csv rows may omit trailing empty columns; treat missing cells as
empty. A pasted row's sheet row number is its 1-based position in the paste.

## Procedure

1. Parse the input:
   - `.xlsx`: stdlib only (no openpyxl), `zipfile` + `xml.etree`, reading
     `xl/sharedStrings.xml` and `xl/worksheets/sheet1.xml`. Map cell refs to
     columns. Sheet row number is parse index `+ 1` (header is sheet row 1).
   - `.csv`: `csv` module; skip a header row if the first row's `Пиар` is the
     literal `Пиар`. Sheet row number is 1-based line position.
   - Pasted rows: split each line on tabs, or on runs of 2+ spaces, into the
     normalized columns.

2. Select candidate rows where ALL hold:
   - `Пиар` starts with `http`.
   - `Слито` is not `+` (not merged).
   - Approvals received (count of `+` in name columns other than the author's)
     is less than the required number in the author's own column.
     `?` is an open review, not an approval.

3. Build the GitHub login to name map. For several PRs run
   `gh pr view <n> --json author --jq .author.login` and match the login
   against that row's `Решает` value. The account from `gh auth status` is the
   user; record which name it maps to.

4. For each candidate PR, in ascending PR order:
   - Re-check live state: `gh pr view <pr> --json state,reviewDecision,reviews`.
     If it is merged, skip and report skipped.
     If it already has enough approvals to meet the required count, skip and
     report skipped (no action on the PR).
   - Substantive per-PR review of the full `gh pr diff <pr>`:
     - Expected-output patches: confirm the new output is a plausible GPDB
       consequence of the sync (motion nodes, hash joins, ORCA/Postgres
       optimizer line, row counts), no stray conflict markers, query result
       sets unchanged when only plans changed.
     - Code patches: verify the conflict resolution is logically correct, no
       uninitialized use or leaks, test-only guards (`#ifdef FAULT_INJECTOR`)
       contain the change.
     - Open `COMMENTED` threads from other colleagues do not affect the
       decision — review independently.
   - If the diff looks good with no concerns, submit
     `gh pr review <pr> --approve` with no body. Do not ask first.
   - Only if the review surfaces a real issue, raise it; comments are the
     pushback case.
   - Verify the review landed: re-query `reviews` for the user's account.

5. Branch state does not matter; switch or use a worktree freely if deeper
   inspection is needed.

## Final report

Print a table with one row per candidate:

`Sheet row | PR | Action (Approved / Skipped / Commented) | Reason`

For approved or already-satisfied PRs, also state which name column to mark
`+` in the spreadsheet (the user's own column for a fresh approval, plus any
GitHub approval missing from the sheet), and whether the requirement is now
met or still short.
