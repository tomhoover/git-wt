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
git wt [options] <command> [<worktree>]
```

### Commands

| Command | Aliases | Description |
|---------|---------|-------------|
| `add [<branch>]` | `a` | Create a worktree for `<branch>` (defaults to current branch; checks out existing or creates new) |
| `list` | `l`, `ls` | List all worktrees; highlights the current one |
| `remove <branch>` | `r`, `rm` | Remove the worktree for `<branch>` |
| `prune` | `p`, `pr` | Prune stale worktree references |
| `switch [<branch>]` | `s`, `sw` | Print path to worktree; no arg = main worktree (use with `cd` — see below) |
| `version` | `v` | Print version |

### Options

| Option | Description |
|--------|-------------|
| `-h` | Show help |
| `-d`, `--debug` | Enable bash trace (`set -x`) |
| `-f`, `--force` | Force removal of a dirty worktree |
| `-v`, `--verbose` | Verbose output (passed to underlying git commands) |

### Examples

```bash
git wt add                # creates worktree for current branch
git wt add feature-x      # creates ../repo+feature-x
git wt ls                 # list all worktrees
git wt remove feature-x   # remove the worktree
git wt -f remove feature-x  # force-remove a dirty worktree
git wt prune              # prune stale entries
cd "$(git wt switch feature-x)"  # cd into a worktree
cd "$(git wt switch)"            # cd back to main worktree
```

Because `switch` prints the path rather than changing directories (a subprocess cannot affect the parent shell), wrap it in a shell function for convenience:

```bash
# Add to ~/.zshrc or ~/.bashrc
gws() { cd "$(git wt switch "$@")"; }
```

## Shell completion

Completes commands, branch names (for `add`), and worktree names (for `remove` and `switch`).

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

## Development

### Requirements

Tools are managed via [mise](https://mise.jdx.dev/). Run `mise install` to install them.

### Setup

```bash
make deps   # install bats-assert and bats-support into test/libs
```

### Common tasks

```bash
make              # lint + test
make lint         # run shellcheck and shfmt check
make fmt          # auto-format source and tests with shfmt
make test         # run all tests
make test-tap     # run tests with TAP output (for CI)
make test-verbose # run tests with verbose output
make clean        # remove deps and stray test worktrees
make check-tools  # verify required tools are installed
```

Run a single test:

```bash
bats test/git-wt.bats --filter "git wt add"
```
