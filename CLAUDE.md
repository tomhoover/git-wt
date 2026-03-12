# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

`git-wt` is a bash script (`src/git-wt`) that wraps `git worktree` commands. It is invoked as `git wt <command>` (git alias) or directly as `git-wt`. Worktrees are created at `<REPO_ROOT>+<branch>` (e.g., `/path/to/repo+mybranch`).

## Commands

```bash
make              # lint + test (default)
make lint         # shellcheck + shfmt check
make fmt          # auto-format with shfmt (in place)
make test         # run all bats tests
make test-tap     # bats with TAP output (for CI)
make test-verbose # bats with verbose output
make deps         # install bats-assert and bats-support into test/libs
make clean        # remove deps and stray test worktrees
make check-tools  # verify bats, shellcheck, shfmt are installed
```

Run a single test by name:
```bash
bats test/git-wt.bats --filter "git wt add bats_xyz"
```

## Tools

Managed via [mise](https://mise.jdx.dev/) (`.mise.toml`): `bats` 1.13, `shellcheck` 0.11, `shfmt` 3.12.

## Code Style

- Bash: 2-space indent (`shfmt -i 2`), functions use `#{{{` / `#}}}` fold markers
- Shell scripts: no extension for executables, `.sh` for libraries (enforced by pre-commit hooks)
- `set -eu -o pipefail` at the top of all scripts

## Testing

Tests live in `test/git-wt.bats` using [bats-core](https://github.com/bats-core/bats-core) with `bats-assert` and `bats-support` (installed via `make deps` into `test/libs/`). Tests run against the real git repository. The `teardown_file` cleans up test worktrees named `bats_xyz` and `bats_dirty`.

## Pre-commit Hooks

Pre-commit runs shellcheck, shfmt, and several file hygiene checks. The `no-commit-to-branch` hook prevents direct commits to protected branches. Run `pre-commit run --all-files` to check manually.

## Commit Messages

Use [Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>: <description>
```

Common types: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`.

Examples:
- `feat: automatically run mise trust on newly added worktree`
- `fix: show actionable git error when worktree add fails`
- `docs: update CLAUDE.md with conventional commit guidance`

## Environment Variables

| Variable | Purpose |
|---|---|
| `NO_COLOR` | Disable all color output (standard; see no-color.org) |
| `GIT_WT_FZF` | Override fzf binary path (useful for testing) |
| `GIT_WT_MISE` | Override mise binary path (useful for testing; set to a fake script to avoid calling real mise) |
| `GIT_WT_CALLER` | Set to `wt` when invoked via the shell function |
| `GIT_WT_ADD_CD` | Set to any non-empty value to make `wt add` always cd into the new worktree (user-facing default for `--cd`) |
| `GIT_WT_CD_FILE` | Temp file path written by the script when `--cd` is active; read by the `wt` shell function to perform the cd (internal, set by the shell function) |
