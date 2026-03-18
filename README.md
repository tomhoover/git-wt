# git-wt

A lightweight `git worktree` wrapper that enforces a consistent naming convention: worktrees are created as siblings of the repo root, suffixed with the branch name.

```
/path/to/repo          ← main worktree
/path/to/repo+feature  ← worktree for branch "feature"
/path/to/repo+hotfix   ← worktree for branch "hotfix"
```

## Installation

### Quick install (latest release)

```bash
curl -Lo ~/bin/git-wt https://github.com/tomhoover/git-wt/releases/latest/download/git-wt
chmod +x ~/bin/git-wt
```

Replace `~/bin/` with any directory on your `PATH` (e.g., `~/.local/bin/`).

### Installation via Homebrew

```bash
brew install tomhoover/git-wt/git-wt
```

### Manual install from source

```bash
cp src/git-wt ~/.local/bin/git-wt
chmod +x ~/.local/bin/git-wt
```

Because the script is named `git-wt`, git automatically exposes it as the `git wt` subcommand.

**Optional:** Install [fzf](https://github.com/junegunn/fzf) to enable interactive fuzzy selection when `cd` finds multiple matching worktrees.

## Usage

```
git wt [options] <command> [--] <positional-args>
```

_NOTE: Global options must appear before the command. Command options may appear before or after positional arguments. Use `--` to end command option parsing when needed._

### Options:

| Option | Description |
|--------|-------------|
| `-h` | Show help |
| `--debug` | Enable bash trace (`set -x`) |

### Command options:
_Command options apply only to the selected command._

| Command | Option | Description |
|--------|----------------|-------------|
| `add` | `--cd` | changes into the new worktree immediately (requires the `wt` shell function) |
| `remove` | `-f` \| `--force` | removes a dirty worktree |
| `remove` | `-d` \| `--delete-branch` | also deletes the branch using `git branch -d` |

### Commands:

| Command | Aliases | Description |
|---------|---------|-------------|
| `add <branch> [<base>] [--cd]` | `a` | <ul><li>Create a worktree for `<branch>` (checks out existing or creates new branch from `HEAD`)</li><li>if `<base>` is given, always creates a new branch from that base</li><li>`--cd` changes into the new worktree immediately (requires the `wt` shell function)</li><li>copies files listed in `.git-wt-copy`</li></ul> |
| `list` | `l`, `ls` | <ul><li>List all worktrees</li><li>highlights the current one</li><li>appends a '!' to indicate a dirty worktree)</li></ul> |
| `remove <branch> [-f\|--force] [-d\|--delete-branch]` | `r`, `rm` | <ul><li>Remove the worktree for `<branch>`</li><li>`-f` removes a dirty worktree</li><li>`-d` also deletes the branch using `git branch -d` (refuses if unmerged — `-f` does **not** force branch deletion)</li></ul> |
| `prune` | `p`, `pr` | Prune stale worktree references |
| `cd [<branch>]` | `c` | <ul><li>Print path to worktree</li><li>accepts exact, prefix, or segment match</li><li>no arg = main worktree, or launches `fzf` selector when multiple worktrees exist</li><li>if multiple worktrees exist and `fzf` is not available, lists all worktrees and exits with an error</li></ul> |
| `status` | `s`, `st` | Show git status across all worktrees |
| `completion <shell>` | | Output shell completion script (`bash` or `zsh`) |
| `init <shell>` | | Output shell integration `wt` function (`bash` or `zsh`) |
| `version` | `v` | Print version |

### Examples:

```bash
git wt add feature-x           # creates ../repo+feature-x (from HEAD, or checks out existing branch)
git wt add feature-x main      # creates ../repo+feature-x as a new branch from main
wt add feature-x --cd          # create worktree and cd into it immediately
wt add feature-x main --cd     # create from base and cd in
                               # note: --cd requires the wt shell function;
                               #   'git wt add --cd' without it shows a cd hint instead
git wt ls                      # list all worktrees
git wt remove feature-x        # remove the worktree
git wt remove -f feature-x     # force-remove a dirty worktree (branch untouched)
git wt remove -d feature-x     # remove worktree and delete branch (refuses if unmerged)
git wt remove -f -d feature-x  # force-remove dirty worktree and delete branch
git wt remove feature-x -f -d  # options may also appear after the worktree name
                               # note: -f only forces the worktree removal;
                               #   branch deletion always uses 'git branch -d' (safe, never -D)
git wt prune                   # prune stale entries
cd "$(git wt cd feature-x)"    # cd into a worktree
cd "$(git wt cd)"              # cd back to main worktree
wt cd feature-x                # cd into a worktree (with init function, see below)
```

Because `cd` prints the path rather than changing directories (a subprocess cannot affect the parent shell), use `git wt init` to install a `wt` shell function:

```bash
# Add to ~/.zshrc or ~/.bashrc
eval "$(git wt init zsh)"   # or: eval "$(git wt init bash)"
```

This defines a `wt` function that can perform a directory change within the current shell:

```bash
wt add feature-x      # same as: git wt add feature-x
wt cd feature-x       # cd into the worktree (exact or partial name match)
wt cd feat            # cd into a worktree whose name starts with "feat"
wt cd                 # cd back to main worktree (or launch fzf selector if installed)
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

## Seeding new worktrees with `.git-wt-copy`

Place a `.git-wt-copy` file in the repo root (and commit it) to automatically copy untracked files or directories into every new worktree created by `git wt add`.

```
# .git-wt-copy — one path per line, relative to repo root
# Lines starting with # and blank lines are ignored.

.env
.env.local
config/local.yml
tmp/cache/
```

### Rules:
- Paths are relative to the repo root; absolute paths and paths containing `..` are rejected with a warning.
- Directory entries conventionally end with `/` but the trailing slash is optional.
- If a listed path does not exist in the source worktree, a warning is printed and the entry is skipped — the `add` still succeeds.
- Files are always sourced from the worktree you are running `git wt add` from, even when a `<base>` branch is specified.
- Copies use copy-on-write (`cp -c` on macOS 12+, `cp --reflink=auto` on Linux) to minimise disk usage, with a plain `cp -r` fallback on filesystems or OS versions that don't support it.

## Environment Variables

| Variable | Purpose |
|----------|---------|
| `NO_COLOR` | Set to any non-empty value to disable all color output (see [no-color.org](https://no-color.org/)). |
| `GIT_WT_ADD_CD` | Set to any non-empty value to make `wt add` always cd into the new worktree (equivalent to always passing `--cd`). Requires the `wt` shell function. |
| `GIT_WT_DEBUG` | Set to any non-empty value to enable bash trace (`set -x`) for debugging. |
| `GIT_WT_FZF` | Override the `fzf` binary path used for interactive selection. |
| `GIT_WT_MISE` | Override the `mise` binary path used for `mise trust` after `add`. |

## License

MIT — see [LICENSE](LICENSE).
