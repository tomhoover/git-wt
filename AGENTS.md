# Repository Guidelines

## Project Structure & Module Organization
- `src/git-wt` is the main Bash script (installed as `git-wt` / `git wt`).
- `test/git-wt.bats` contains the bats-core test suite.
- `completions/` holds shell completion scripts for bash and zsh.
- `scripts/` contains helper scripts such as `check-commit-msg`.
- `Makefile` is the primary task runner.

## Build, Test, and Development Commands
```bash
make            # run lint + test (default)
make lint       # shellcheck + shfmt check
make fmt        # auto-format with shfmt
make test       # run bats tests (requires make deps)
make test-tap   # bats with TAP output (CI-friendly)
make test-verbose
make deps       # install bats-assert and bats-support into test/libs
make clean      # remove deps and stray bats worktrees
```

## Coding Style & Naming Conventions
- Bash scripts use 2-space indentation and are formatted with `shfmt -i 2 -bn -ci`.
- Linting uses `shellcheck` with bash settings.
- Executable scripts omit file extensions; libraries use `.sh`.
- Scripts start with `set -eu -o pipefail` and functions use `#{{{` / `#}}}` fold markers.

## Testing Guidelines
- Tests are written with `bats-core` plus `bats-assert` and `bats-support` in `test/libs/`.
- Run all tests with `make test` after `make deps`.
- To run a single test:
```bash
bats test/git-wt.bats --filter "git wt add bats_xyz"
```
- Tests create real git worktrees; cleanup happens in `teardown_file`.

## Commit & Pull Request Guidelines
- Commit messages follow Conventional Commits, e.g. `feat: add new flag` or `fix(ci): handle missing tool`.
- Common types include `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `build`.
- PRs should describe behavior changes, include relevant commands run (e.g. `make lint`, `make test`), and link related issues. Add screenshots only if user-facing output changes.

## Tooling & Configuration Notes
- Tool versions are managed via `mise` (`.mise.toml`).
- See `CLAUDE.md` for deeper contributor notes and release workflow details.
