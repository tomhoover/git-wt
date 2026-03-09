# git-wt

A lightweight `git worktree` wrapper that enforces a consistent naming convention: worktrees are created as siblings of the repo root, suffixed with the branch name.

```
/path/to/repo          ← main worktree
/path/to/repo+feature  ← worktree for branch "feature"
/path/to/repo+hotfix   ← worktree for branch "hotfix"
```

## Installation

Copy (or symlink) `src/git-wt` to a directory on your `PATH`:

```bash
cp src/git-wt ~/.local/bin/git-wt
chmod +x ~/.local/bin/git-wt
```

Because the script is named `git-wt`, git automatically exposes it as the `git wt` subcommand.

## Usage

```
git wt [options] <command> [<command_options>] [<worktree>]
```

### Commands

| Command | Aliases | Description |
|---------|---------|-------------|
| `add <branch>` | `a` | Create a worktree for `<branch>` (checks out existing or creates new) |
| `list` | `l`, `ls` | List all worktrees; highlights the current one; appends a '!' to indicate a dirty worktree) |
| `remove [-f\|--force] <branch>` | `r`, `rm` | Remove the worktree for `<branch>`; use `-f|--force` to force-remove a dirty worktree |
| `prune` | `p`, `pr` | Prune stale worktree references |
| `cd [<branch>]` | `c` | Print path to worktree; no arg = main worktree (use with `cd` — see below) |
| `status` | `s`, `st` | Show git status across all worktrees |
| `completion <shell>` | | Output shell completion script (`bash` or `zsh`) |
| `init <shell>` | | Output shell integration `wt` function (`bash` or `zsh`) |
| `version` | `v` | Print version |

### Options

| Option | Description |
|--------|-------------|
| `-h` | Show help |
| `-d`, `--debug` | Enable bash trace (`set -x`) |
| `-v`, `--verbose` | Verbose output (passed to underlying git commands) |

### Examples

```bash
git wt add feature-x      # creates ../repo+feature-x
git wt ls                 # list all worktrees
git wt remove feature-x   # remove the worktree
git wt remove -f feature-x  # force-remove a dirty worktree
git wt prune              # prune stale entries
cd "$(git wt cd feature-x)"      # cd into a worktree
cd "$(git wt cd)"                # cd back to main worktree
wt cd feature-x                  # cd into a worktree (with init function, see below)
```

Because `cd` prints the path rather than changing directories (a subprocess cannot affect the parent shell), use `git wt init` to install a `wt` shell function:

```bash
# Add to ~/.zshrc or ~/.bashrc
eval "$(git wt init zsh)"   # or: eval "$(git wt init bash)"
```

This defines a `wt` function that delegates to `git wt` for all commands, except `cd`/`c` where it performs the directory change in the current shell:

```bash
wt add feature-x      # same as: git wt add feature-x
wt cd feature-x       # cd into the worktree (no subshell needed)
wt cd                 # cd back to main worktree
```

## Shell integration

Install a `wt` convenience function that wraps `git wt` and handles `cd` in the current shell:

### Zsh

Add to `~/.zshrc`:

```zsh
eval "$(git wt init zsh)"
```

### Bash

Add to `~/.bashrc`:

```bash
eval "$(git wt init bash)"
```

## Shell completion

Completes commands, branch names (for `add`), and worktree names (for `remove` and `cd`).

### Zsh

Add to `~/.zshrc`:

```zsh
eval "$(git wt completion zsh)"
```

### Bash

Add to `~/.bashrc`:

```bash
eval "$(git wt completion bash)"
```

### Alternative: file-based install

Standalone completion scripts are also available in `completions/` — see the comments at the top of each file for instructions.

## License

MIT — see [LICENSE](LICENSE).
