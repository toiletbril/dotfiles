---
name: pr
description: Create a pull request into a target branch with a well-crafted description. Use when the user wants to open a PR or says "make a PR into X".
argument-hint: <target-branch>
allowed-tools:
  - Bash(git log *)
  - Bash(git diff *)
  - Bash(git show *)
  - Bash(git branch *)
  - Bash(git status *)
  - Bash(gh pr create *)
  - Bash(gh pr view *)
---

# /pr

Creates a pull request from the current branch into `$ARGUMENTS` (the target branch).

Arguments: `$ARGUMENTS` -- the target branch, e.g. `master` or `staging`.

---

## Steps

1. **Gather context**

   ```bash
   git log --oneline $ARGUMENTS..HEAD
   git diff $ARGUMENTS...HEAD --stat
   git diff $ARGUMENTS...HEAD
   ```

   Read all commits and the full diff. Understand the *why* behind every
   change before writing a single word.

2. **Draft the title**

   - Imperative verb, no period, 50-70 chars.
   - Describes the change, not the mechanism.
   - Match the register of these examples:
     - "Detect filesystem-level WAL duplicates"
     - "Report resource groups to pg_stat_activity for segment backends"

3. **Draft the body**

   Write in confident, spare technical prose. No bullets unless there are
   truly enumerable independent points. No hype. No "this PR", no "I".

   Body structure (adapt to what fits -- not every section is always needed):

   ```
   <current state / problem being solved, 1-3 sentences>

   <what the patch does and why, 1-3 sentences or a numbered list if
    there are multiple distinct logical steps>

   <optional: outcome / observable effect, 1 sentence>
   ```

   If the user provided an issue description or quote in `$ARGUMENTS` or
   nearby context, include it as an "Initial context:" block:

   ```
   Initial context:

   > <verbatim quote from issue/request>
   ```

   Style reference -- match this register exactly:

   ---
   Detect filesystem-level WAL duplicates

   UNFS3 resets its global rcookie to 0 on directory modification instead
   of returning NFS3ERR_BAD_COOKIE, so readdir() restarts and returns
   entries already seen by the client.

   Emit a dedicated NFS hint instead of misattributing the duplication to
   multiple archiving primaries by listing identical names before the
   hash-diversity checks.
   ---

   ---
   Report resource groups to pg_stat_activity for segment backends

   Current state of affairs, from upstream docs:

       When resource groups are enabled. Only query dispatcher (QD) processes
       will have a rsgid and rsgname. Other server processes such as a query
       executer (QE) process or session connection processes will have a rsgid
       value of 0 and a rsgname value of unknown.

   1. Only the DISPATCHER and EXECUTOR roles change resource groups. UTILITY
      does not interact with resource groups.
   2. The patch forces segments (EXECUTOR) to report their resource group
      status to pg_stat_activity.
   3. pg_resgroup_move_query() sends a request from the coordinator to segment
      processes with the same session ID, which is looked up by PID in shared
      memory.
   ---

4. **Create the PR**

   ```bash
   gh pr create --base $ARGUMENTS --title "<title>" --body "$(cat <<'EOF'
   <body>
   EOF
   )"
   ```

   Print the returned PR URL to the user.

---

## Notes

- Never invent context that is not in the diff or commits.
- If the branch has no commits ahead of the target, stop and tell the user.
- If `gh` is not authenticated, tell the user to run `gh auth login`.
- Do not add a "Test plan" section -- this project does not use that format.
