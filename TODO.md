1. list: --short — show only branch names (no paths), useful for scripting
2. rename: — rename a worktree's branch and directory atomically
3. git wt add <branch> [<name>] — allow an optional second argument to override
   the directory suffix (useful when branch names are long or contain slashes
   like feature/foo)
   - The add [<name>] override would also cleanly resolve the slash-in-branch
     naming complexity currently handled by path substitution.
