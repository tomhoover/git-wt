# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) and to [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

## v0.16.0 (2026-03-09)

### Feature
- add --delete-branch flag to remove command [`52d9008`](git@github.com:tomhoover/git-wt/commit/52d9008)

## v0.15.0 (2026-03-09)

### Feature
- fzf integration for wt cd [`c821a0f`](git@github.com:tomhoover/git-wt/commit/c821a0f)

## v0.14.0 (2026-03-09)

### Feature
- add 'cd <TAB>' completion for wt alias [`6efd1ba`](git@github.com:tomhoover/git-wt/commit/6efd1ba)

### Continuous Integration
- ensure HEAD is on a named branch to fix list tests [`7259a4e`](git@github.com:tomhoover/git-wt/commit/7259a4e)
- checkout branch by name to avoid detached HEAD in tests [`1fd45c1`](git@github.com:tomhoover/git-wt/commit/1fd45c1)
- add GitHub Actions workflow to run lint and bats tests [`d1f60e5`](git@github.com:tomhoover/git-wt/commit/d1f60e5)

### Documentation
- fix typo in README.md (#5) [`09c3cb3`](git@github.com:tomhoover/git-wt/commit/09c3cb3)

### Test
- broaden list assertions to match any branch name [`9ad1110`](git@github.com:tomhoover/git-wt/commit/9ad1110)
- add missing coverage for list, cd, and verbose flag tests [`aa5c064`](git@github.com:tomhoover/git-wt/commit/aa5c064)
- add missing status tests for dirty worktree and current worktree marker [`aaec6a1`](git@github.com:tomhoover/git-wt/commit/aaec6a1)

### Other
- Merge pull request #8 from tomhoover/claude [`583959d`](git@github.com:tomhoover/git-wt/commit/583959d)
- Merge pull request #7 from tomhoover/claude [`fa10fb6`](git@github.com:tomhoover/git-wt/commit/fa10fb6)
- Merge pull request #6 from tomhoover/claude [`1d0b8b7`](git@github.com:tomhoover/git-wt/commit/1d0b8b7)

## v0.13.0 (2026-03-09)

### Feature
- add a 'dirty' indicator to the 'list' command [`cdb3d67`](git@github.com:tomhoover/git-wt/commit/cdb3d67)

### Bug Fixes
- exclude merge commits from conventional commit check [`a03a0da`](git@github.com:tomhoover/git-wt/commit/a03a0da)

### Continuous Integration
- add GitHub Actions workflow to enforce conventional commits [`71b6f6e`](git@github.com:tomhoover/git-wt/commit/71b6f6e)

### Other
- Merge pull request #2 from tomhoover/claude [`6c51e2f`](git@github.com:tomhoover/git-wt/commit/6c51e2f)

## v0.12.1 (2026-03-08)

### Documentation
- add additional examples to 'Usage' [`c18b09d`](git@github.com:tomhoover/git-wt/commit/c18b09d)

## v0.12.0 (2026-03-08)

### Feature
- show wt-aware usage when called via wrapper function [`38e9fe6`](git@github.com:tomhoover/git-wt/commit/38e9fe6)

### Other
- Merge pull request #1 from tomhoover/tomhoover-patch-1 [`e96924e`](git@github.com:tomhoover/git-wt/commit/e96924e)
- Update README.md [`81f9137`](git@github.com:tomhoover/git-wt/commit/81f9137)

## v0.11.1 (2026-03-08)

### Documentation
- clarification of 'remove' command options (-f|--force) [`599e263`](git@github.com:tomhoover/git-wt/commit/599e263)

## v0.11.0 (2026-03-08)

### Feature
- improve bash completion and move -f flag to remove subcommand [`eb59dc4`](git@github.com:tomhoover/git-wt/commit/eb59dc4)

### Documentation
- add MIT license [`6827470`](git@github.com:tomhoover/git-wt/commit/6827470)

### Refactor
- vim folding [`6dbe6be`](git@github.com:tomhoover/git-wt/commit/6dbe6be)

## v0.10.0 (2026-03-06)

### Feature
- rename switch→cd, add status subcommand [`afe5ea4`](git@github.com:tomhoover/git-wt/commit/afe5ea4)

## v0.9.0 (2026-03-06)

### Feature
- add init subcommand for shell integration [`f32e6ff`](git@github.com:tomhoover/git-wt/commit/f32e6ff)

## v0.8.0 (2026-03-06)

### Feature
- add prefix matching to switch subcommand [`3ce0756`](git@github.com:tomhoover/git-wt/commit/3ce0756)

### Chore
- bump version to 0.8.0 [`70737ad`](git@github.com:tomhoover/git-wt/commit/70737ad)

## v0.7.2 (2026-03-06)

### Feature
- show (new branch) or (existing branch) after add [`e106437`](git@github.com:tomhoover/git-wt/commit/e106437)

## v0.7.1 (2026-03-06)

### Feature
- improve list output with CHANGELOG.md CLAUDE.md completions DONE.md LICENSE Makefile README.md scripts src test TODO.md marker and color [`1db18d6`](git@github.com:tomhoover/git-wt/commit/1db18d6)

## v0.7.0 (2026-03-06)

### Chore
- add src/ to PATH via mise and update tests [`ffbe64f`](git@github.com:tomhoover/git-wt/commit/ffbe64f)
- bump version to 0.7.0 [`da06072`](git@github.com:tomhoover/git-wt/commit/da06072)

## v0.6.3 (2026-03-05)

### Documentation
- remove development section from README [`5b5a424`](git@github.com:tomhoover/git-wt/commit/5b5a424)

## v0.6.2 (2026-03-05)

### Test
- verify -v flag is forwarded to git worktree prune [`1305cd0`](git@github.com:tomhoover/git-wt/commit/1305cd0)

## v0.6.1 (2026-03-05)

### Feature
- add completion subcommand for eval-based shell setup [`48fe5eb`](git@github.com:tomhoover/git-wt/commit/48fe5eb)

## v0.6.0 (2026-03-05)

### Feature
- add shell completion for zsh and bash [`1509a78`](git@github.com:tomhoover/git-wt/commit/1509a78)

### Chore
- bump version to 0.6.0 [`0c9da7d`](git@github.com:tomhoover/git-wt/commit/0c9da7d)
- bump version to 0.5.1 [`98b7939`](git@github.com:tomhoover/git-wt/commit/98b7939)

## v0.5.1 (2026-03-05)

### Feature
- switch with no args returns main worktree path [`7f5fea3`](git@github.com:tomhoover/git-wt/commit/7f5fea3)

## v0.5.0 (2026-03-05)

### Feature
- add no-args support to add command [`55032a8`](git@github.com:tomhoover/git-wt/commit/55032a8)

## v0.4.0 (2026-03-05)

### Feature
- add switch command to print worktree path [`f17cfa0`](git@github.com:tomhoover/git-wt/commit/f17cfa0)

### Chore
- bump version to 0.4.0 [`b039435`](git@github.com:tomhoover/git-wt/commit/b039435)

## v0.3.0 (2026-03-05)

### Documentation
- rewrite README [`39a74ee`](git@github.com:tomhoover/git-wt/commit/39a74ee)

### Chore
- improve Makefile [`7fa6ec5`](git@github.com:tomhoover/git-wt/commit/7fa6ec5)
- add tools to mise.toml [`55951c0`](git@github.com:tomhoover/git-wt/commit/55951c0)
- update pre-commit hooks [`f4abb0a`](git@github.com:tomhoover/git-wt/commit/f4abb0a)

### Style
- switch to 2-space indent [`69a990d`](git@github.com:tomhoover/git-wt/commit/69a990d)

### Refactor
- rename test/.bats_deps to test/libs [`5df8d5e`](git@github.com:tomhoover/git-wt/commit/5df8d5e)

## v0.1.0 (2026-02-27)

### Other
- MVP [`afe2701`](git@github.com:tomhoover/git-wt/commit/afe2701)
- Initial commit [`62ed334`](git@github.com:tomhoover/git-wt/commit/62ed334)
