---
name: reword-commits
description: Rewrite titles and bodies of unpushed commits. Use when the user asks to improve, rename, or add bodies to recent commits, or when commit messages need updating.
argument-hint: [count]
allowed-tools:
  - Bash(git log *)
  - Bash(git show *)
  - Bash(git commit --amend *)
  - Bash(GIT_SEQUENCE_EDITOR=* GIT_EDITOR=* git rebase *)
  - Write
---

# /reword-commits

Rewrites commit messages for the N most recent unpushed commits
(default: all unpushed) using non-interactive rebase.

Arguments: `$ARGUMENTS` (optional count, e.g. `2` to reword last 2)

---

## Steps

1. **Inspect commits**

   ```bash
   git log --oneline origin/$(git branch --show-current)..HEAD
   git show <hash> --no-patch   # for each commit
   ```

   Understand what each commit does before writing a message.

2. **Write message files**

   Write one file per commit to `/tmp/msg_<n>.txt` using the project's
   commit style (check `git log --oneline -10` for conventions).

   Message format per CLAUDE.md:
   - Subject: imperative, no period, 50-70 chars
   - Body: blank line separator, why-not-what, numbered if multi-step
   - Reference functions with `()` suffix

3. **Write an editor script**

   Use the Write tool to create `/tmp/edit_msg.sh`. The script receives the
   commit message file path as its first shell positional argument. It reads
   the current subject line and overwrites the file with the right prepared
   message:

   ```
   #!/bin/bash
   FILE=(first positional arg)
   old=$(cat "$FILE")
   if echo "$old" | grep -qx "exact subject of commit 1"; then
       cat /tmp/msg_1.txt > "$FILE"
   elif echo "$old" | grep -qx "exact subject of commit 2"; then
       cat /tmp/msg_2.txt > "$FILE"
   fi
   ```

   Then: `chmod +x /tmp/edit_msg.sh`

   The script matches on the current subject line and replaces the whole
   file with the prepared message.

4. **Run non-interactive rebase**

   ```bash
   GIT_SEQUENCE_EDITOR="sed -i 's/^pick/reword/g'" \
   GIT_EDITOR=/tmp/edit_msg.sh \
   git rebase -i HEAD~<count>
   ```

5. **Verify**

   ```bash
   git log --oneline -<count>
   git show HEAD --no-patch   # spot-check body
   ```

---

## Notes

- Never amend commits that have already been pushed.
- If only rewriting HEAD, `git commit --amend` is simpler than rebase.
- The editor script matches on the old subject, so subjects must be unique
  among the commits being reworded.
