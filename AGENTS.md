# Repository Guidelines

This file provides guidance to AI coding agents working in this repository.

## Project Overview

`git-wt` is a bash script (`src/git-wt`) that wraps `git worktree` commands. Invoked as `git wt <command>` or `git-wt`. Worktrees are created at `<REPO_ROOT>+<branch>` (e.g., `/path/to/repo+mybranch`).

## Project Structure

```
src/git-wt          # Main executable (no .sh extension)
test/git-wt.bats    # bats-core test suite
completions/        # bash and zsh completion scripts
scripts/            # Helper scripts (check-commit-msg, etc.)
Makefile            # Primary task runner
```

## Development Commands

### Quick Start
```bash
make            # lint + test (default target)
make deps       # install bats-assert and bats-support into test/libs/
```

### Linting & Formatting
```bash
make lint           # Run shellcheck + shfmt check
make fmt            # Auto-format with shfmt (in place)
```

### Testing
```bash
make test           # Run all bats tests
make test-tap       # TAP output (CI-friendly)
make test-verbose   # Verbose test output

# Run a single test by name:
bats test/git-wt.bats --filter "git wt add bats_xyz"

# Run all tests matching a pattern:
bats test/git-wt.bats --filter "git wt cd"
```

### Cleanup
```bash
make clean       # Remove deps and stray bats worktrees
make clean-deps  # Remove just the test/libs/ dependencies
```

### Pre-commit Hooks
```bash
pre-commit run --all-files    # Run all hooks manually
```

## Code Style

### Bash Script Conventions
- **Indentation**: 2 spaces (`shfmt -i 2`)
- **Error handling**: `set -eu -o pipefail` at top of all scripts
- **Function folds**: Use vim-style `#{{{` / `#}}}` markers
- **File extensions**: Executables have no extension; libraries use `.sh`
- **Shellcheck**: Enabled with `shellcheck --shell=bash --severity=warning`

### Naming Conventions
- Functions: `snake_case` or `camelCase` (follow existing pattern)
- Variables: `lower_case` with uppercase for globals (`GIT_WT_*`)
- Constants: `UPPER_SNAKE_CASE`

### Error Handling Patterns
```bash
# Check command success explicitly
if ! command_that_can_fail; then
  error "Descriptive message"
  exit 1
fi

# Use error function for user-facing errors
error "Failed to do something"
exit 1

# Capture and report command output
if ! output=$(some_command 2>&1); then
  echo "${output}" >&2
  error "Command failed"
  exit 1
fi
```

### String Handling
```bash
# Quote variables to handle spaces
"${variable}"

# Use [[ ]] for conditional tests (not [ ])

# Trim whitespace
entry="${entry#"${entry%%[!$' \t']*}"}"
entry="${entry%"${entry##*[!$' \t']}"}"
```

## Testing Guidelines

### Test Framework
- Use `bats-core` with `bats-assert` and `bats-support`
- Libraries loaded from `test/libs/` (install with `make deps`)

### Writing Tests
```bash
# Basic test structure
@test "description of test" {
  run -0 command           # expect exit 0
  run -1 command           # expect exit 1
  assert_output --partial "expected string"
  assert_line -n 0 -e "^regex$"
  refute_output --partial "unexpected"
}

# For tests that modify state:
# - Clean up in teardown_file() for cross-test persistence
# - Use unique worktree names (bats_xyz, bats_dirty, etc.)
# - Always force-remove before creating to avoid conflicts
```

### Test Isolation
- Tests run against the real git repository
- `teardown_file` cleans up worktrees: `bats_xyz`, `bats_dirty`, `bats_remote`, `bats_ns+bats_xyz`
- Create/remove worktrees in each test or clean up in teardown
- Use `BATS_TEST_TMPDIR` for temp files that need cleanup

### Environment Variables for Testing
| Variable | Purpose |
|----------|---------|
| `GIT_WT_FZF` | Override fzf binary path (use fake script for testing) |
| `GIT_WT_MISE` | Override mise binary path (use fake script to avoid side effects) |
| `GIT_WT_DEBUG` | Enable bash trace (`set -x`) for debugging |
| `GIT_WT_ADD_CD` | Make `wt add` default to cd behavior |

## Commit Guidelines

### Message Format (Conventional Commits)
```
<type>: <short description>

Types: feat, fix, docs, chore, refactor, test, build, perf, ci
```

### Examples
- `feat: add --short flag for script-friendly list output`
- `fix(ci): handle missing tool gracefully`
- `test: add tests for GIT_WT_DEBUG env var`

### Before Committing
1. Run `make lint` to check formatting and shellcheck
2. Run `make test` to verify tests pass
3. Ensure no secrets or credentials in changes
4. Verify working tree is clean (no stray files)

## Environment Variables

| Variable | Purpose |
|----------|---------|
| `NO_COLOR` | Disable all color output (standard; no-color.org) |
| `GIT_WT_FZF` | Override fzf binary path |
| `GIT_WT_MISE` | Override mise binary path |
| `GIT_WT_CALLER` | Set to `wt` when invoked via shell function |
| `GIT_WT_ADD_CD` | Default `wt add` to cd into new worktree |
| `GIT_WT_DEBUG` | Enable bash trace (`set -x`) |
| `GIT_WT_CD_FILE` | Internal: temp file for `--cd` cd path |

## Tooling

- **mise**: Tool versions in `.mise.toml` (bats, shellcheck, shfmt, git-cliff)
- **pre-commit**: Hooks in `.pre-commit-config.yaml`
- **git-cliff**: Changelog generation for releases
