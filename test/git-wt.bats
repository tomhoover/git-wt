#!/usr/bin/env bats

bats_require_minimum_version 1.5.0

setup_file() { #{{{
  echo "Setting up environment"
} #}}}

teardown_file() { #{{{
  echo "Cleaning up environment"
  run git worktree remove --force "$(pwd -P)+bats_dirty"
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git worktree remove --force "$(pwd -P)+bats_remote"
  run git worktree remove --force "$(pwd -P)+bats_ns+bats_xyz"
  rm -rf "$(pwd -P)+bats_ns+bats_xyz"
  run git worktree remove --force "$(pwd -P)+bats_detach"
  run git branch -D bats_dirty
  run git branch -D bats_xyz
  run git branch -D bats_remote
  run git branch -D bats_ns/bats_xyz
  run git update-ref -d refs/remotes/origin/bats_remote
  run git worktree prune
} #}}}

setup() { #{{{
  load 'libs/bats-assert/load'
  load 'libs/bats-support/load'

  # get the containing directory of this file
  # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
  # as those will point to the bats executable's location or the preprocessed file respectively
  DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"

  # make executables in src/ visible to PATH
  PATH="$DIR/../src:$PATH"

  # Preserve any real .git-wt-copy the user has in their worktree
  if [[ -f "$(pwd -P)/.git-wt-copy" ]]; then
    cp "$(pwd -P)/.git-wt-copy" "${BATS_TEST_TMPDIR}/.git-wt-copy.saved"
  fi
} #}}}

teardown() { #{{{
  # Restore .git-wt-copy to its pre-test state
  if [[ -f "${BATS_TEST_TMPDIR}/.git-wt-copy.saved" ]]; then
    mv "${BATS_TEST_TMPDIR}/.git-wt-copy.saved" "$(pwd -P)/.git-wt-copy"
  else
    rm -f "$(pwd -P)/.git-wt-copy"
  fi
} #}}}

# ── Usage / Help ─────────────────────────────────────────────────────────────

@test "git wt (no args) shows usage" { #{{{
  run -0 git-wt
  assert_line -n 0 'Usage: git-wt [options] <command> [--] <positional-args>'
  run -0 git wt
  assert_line -n 0 'Usage: git-wt [options] <command> [--] <positional-args>'
} #}}}

@test "git wt -h shows usage and all options" { #{{{
  run -0 git wt -h
  assert_line -n 0 'Usage: git-wt [options] <command> [--] <positional-args>'
  assert_output -p '-h'
  assert_output -p '--debug'

  assert_output -p 'a | add         ) add a worktree; optional [<base>]'
  assert_output -p '--cd changes into new worktree after creation'
  assert_output -p 'GIT_WT_ADD_CD=1'
  assert_output -p 'l | ls | list'
  assert_output -p 'r | rm | remove'
  assert_output -p '--force'
  assert_output -p '--delete-branch'
  assert_output -p 'p | pr | prune'
  assert_output -p 'c | cd'
  assert_output -p 's | st | status'
  assert_output -p 'completion'
  assert_output -p 'init'
  assert_output -p 'v | version'
} #}}}

# ── Version ──────────────────────────────────────────────────────────────────

@test "git wt version" { #{{{
  run -0 git wt v
  assert_line -e '^git-wt version [0-9]+\.[0-9]+\.[0-9]+$'
  run -0 git wt version
  assert_output -p 'git-wt version'
} #}}}

@test "git wt version matches VERSION in script" { #{{{
  script_version=$(grep '^VERSION=' "$DIR/../src/git-wt" | cut -d'=' -f2 | tr -d '"')
  run -0 git wt version
  assert_output "git-wt version ${script_version}"
} #}}}

# ── Unknown argument ──────────────────────────────────────────────────────────

@test "git wt abcxyz (unknown argument)" { #{{{
  run -1 git wt abcxyz
  assert_line -e '^ERROR: Unknown argument: abcxyz$'
} #}}}

# ── Debug flag ────────────────────────────────────────────────────────────────

@test "git wt --debug (no command) shows trace then usage" { #{{{
  run -0 git wt --debug
  assert_output -p '+ shift
+ continue
+ [[ 0 -ge 1 ]]'
} #}}}

@test "git wt --debug abcxyz (unknown argument, with debug)" { #{{{
  run -1 git wt --debug abcxyz
  # shellcheck disable=SC2016
  assert_output -p '+ shift
+ continue
+ [[ 1 -ge 1 ]]
+ case "${1}" in
+ error'
  assert_line -e '^ERROR: Unknown argument: abcxyz$'
} #}}}

# ── Outside git repository ────────────────────────────────────────────────────

@test "git wt (add/list/remove/status/cd) fail outside a git repo" { #{{{
  run -1 bash -c 'cd /tmp && git wt add foo'
  assert_line -e '^ERROR: Not inside a git repository$'
  run -1 bash -c 'cd /tmp && git wt list'
  assert_line -e '^ERROR: Not inside a git repository$'
  run -1 bash -c 'cd /tmp && git wt remove foo'
  assert_line -e '^ERROR: Not inside a git repository$'
  run -1 bash -c 'cd /tmp && git wt status'
  assert_line -e '^ERROR: Not inside a git repository$'
  run -1 bash -c 'cd /tmp && git wt cd'
  assert_line -e '^ERROR: Not inside a git repository$'
} #}}}

# ── Add ───────────────────────────────────────────────────────────────────────

@test "git wt add (no args shows error)" { #{{{
  run -1 git wt a
  assert_output -p "ERROR: 'add' requires a worktree name"
  run -1 git wt add
  assert_output -p "ERROR: 'add' requires a worktree name"
} #}}}

@test "git wt add (unknown option)" { #{{{
  run -1 git wt add --bogus bats_xyz
  assert_line -e "^ERROR: Unknown option '--bogus'$"
} #}}}

@test "git wt add (extra positional args rejected)" { #{{{
  run -1 git wt add bats_xyz master extra
  assert_output -p "ERROR: Too many arguments: unexpected 'extra'"
} #}}}

@test "git wt add HEAD (commit reference rejected)" { #{{{
  run -1 git wt add HEAD
  assert_output -p "ERROR: Please provide a branch name, not a commit reference"
  run -1 git wt add HEAD~1
  assert_output -p "ERROR: Please provide a branch name, not a commit reference"
} #}}}

@test "git wt --debug add (no args shows error, with debug)" { #{{{
  run -1 git wt --debug add
  # shellcheck disable=SC2016
  assert_output -p '+ missing_worktree_name add'
  assert_output -p "ERROR: 'add' requires a worktree name"
} #}}}

@test "git wt --debug add bats_xyz (create, then duplicate)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz

  run -0 git wt --debug add bats_xyz
  # shellcheck disable=SC2016
  assert_output -p '+ add_worktree bats_xyz'
  assert_line -e '^HEAD is now at .*$'

  run -1 git wt --debug add bats_xyz
  assert_line -e '^ERROR: Worktree .* already exists$'
} #}}}

@test "git wt add --debug bats_xyz (debug after subcommand)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz

  run -0 git wt add --debug bats_xyz
  assert_output -p "+ add_worktree bats_xyz"

  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
} #}}}

@test "git wt add -- -bats_dash (branch name starting with dash is invalid)" { #{{{
  run git worktree remove --force "$(pwd -P)+-bats_dash"
  run git branch -D -- -bats_dash

  run -1 git wt add -- -bats_dash
  assert_output -p "not a valid branch name"
  assert_output -p "ERROR: Invalid branch name '-bats_dash'"
} #}}}

@test "git wt add bats_xyz (create, then duplicate)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz

  run -0 git wt add bats_xyz
  assert_line -e '^HEAD is now at .*$'
  assert_output -p "Worktree created at:"
  assert_output -p "(new branch)"
  assert_output -p "cd '"

  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run -0 git wt add bats_xyz
  assert_output -p "Worktree created at:"
  assert_output -p "(existing branch)"

  run -1 git wt add bats_xyz
  assert_line -e '^ERROR: Worktree .* already exists$'
} #}}}

@test "git wt add bats_xyz <base> (create new branch from base; worktree alongside base)" { #{{{
  # Use the current branch as base — it always has a worktree and exists in CI.
  local base_branch base_root
  base_branch=$(git rev-parse --abbrev-ref HEAD)
  base_root=$(pwd -P)
  run git worktree remove --force "${base_root}+bats_xyz"
  run git branch -D bats_xyz

  run -0 git wt add bats_xyz "${base_branch}"
  assert_output -p "Worktree created at:"
  assert_output -p "(new branch from ${base_branch})"
  assert_output -p "${base_root}+bats_xyz"

  run git worktree remove --force "${base_root}+bats_xyz"
  run git branch -D bats_xyz
} #}}}

@test "git wt add bats_xyz --cd (without wt function) shows cd hint, not marker" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz

  run -0 git wt add bats_xyz --cd
  assert_output -p "Worktree created at:"
  assert_output -p "cd '"
  refute_output -p "__WT_CD__"

  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
} #}}}

@test "wt add bats_xyz --cd changes into new worktree" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz

  run -0 bash --norc -c "
    eval \"\$(git wt init bash)\"
    wt add bats_xyz --cd || exit 1
    echo \"__dir__:\$(pwd -P)\"
  "
  assert_output -p "Worktree created at:"
  assert_output -p "__dir__:$(pwd -P)+bats_xyz"

  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
} #}}}

@test "wt add bats_xyz (GIT_WT_ADD_CD=1 default) changes into new worktree" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz

  run -0 bash --norc -c "
    eval \"\$(git wt init bash)\"
    GIT_WT_ADD_CD=1 wt add bats_xyz || exit 1
    echo \"__dir__:\$(pwd -P)\"
  "
  assert_output -p "Worktree created at:"
  assert_output -p "__dir__:$(pwd -P)+bats_xyz"

  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
} #}}}

@test "git wt add bats_xyz (nonexistent base fails with error)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz

  run -1 git wt add bats_xyz nonexistent_base_xyz
  assert_output -p "ERROR: Failed to create worktree for 'bats_xyz' from 'nonexistent_base_xyz'"
} #}}}

@test "git wt add from remote-only branch (DWIM)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_remote"
  run git branch -D bats_remote
  git update-ref refs/remotes/origin/bats_remote "$(git rev-parse HEAD)"

  run -0 git wt add bats_remote
  assert_output -p "Worktree created at:"
  assert_output -p "$(pwd -P)+bats_remote"

  git update-ref -d refs/remotes/origin/bats_remote
  run git worktree remove --force "$(pwd -P)+bats_remote"
  run git branch -D bats_remote
} #}}}

@test "git wt add bats_ns/bats_xyz (branch with slash uses + in path)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_ns+bats_xyz"
  rm -rf "$(pwd -P)+bats_ns+bats_xyz"
  run git branch -D bats_ns/bats_xyz

  run -0 git wt add bats_ns/bats_xyz
  assert_output -p "Worktree created at: $(pwd -P)+bats_ns+bats_xyz"
  assert_output -p "(new branch)"

  # cd resolves slash name to the + path
  run -0 git wt cd bats_ns/bats_xyz
  assert_output "$(pwd -P)+bats_ns+bats_xyz"

  run git worktree remove --force "$(pwd -P)+bats_ns+bats_xyz"
  run git branch -D bats_ns/bats_xyz
} #}}}

@test "git wt add bats_xyz runs mise trust after creating worktree" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz

  fake_mise=$(mktemp)
  printf '#!/bin/sh\nexit 0\n' >"${fake_mise}"
  chmod +x "${fake_mise}"

  run -0 env GIT_WT_MISE="${fake_mise}" git wt add bats_xyz
  assert_output -p "Worktree created at:"
  assert_output -p "mise trust applied"

  rm -f "${fake_mise}"
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
} #}}}

@test "git wt add bats_xyz warns and succeeds if mise trust fails" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz

  fake_mise=$(mktemp)
  printf '#!/bin/sh\nexit 1\n' >"${fake_mise}"
  chmod +x "${fake_mise}"

  run -0 env GIT_WT_MISE="${fake_mise}" git wt add bats_xyz
  assert_output -p "Worktree created at:"
  assert_line -e "^WARNING: mise trust failed.*$"

  rm -f "${fake_mise}"
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
} #}}}

# ── List ──────────────────────────────────────────────────────────────────────

@test "git wt list (all aliases)" { #{{{
  run -0 git wt l
  assert_line -n 0 -e '^.* \[.+\]( !)?$'
  run -0 git wt ls
  assert_line -n 0 -e '^.* \[.+\]( !)?$'
  run -0 git wt list
  assert_line -n 0 -e '^.* \[.+\]( !)?$'
} #}}}

@test "git wt list highlights current worktree" { #{{{
  escaped_pwd=$(printf '%s' "$(pwd -P)" | sed 's/[][\.*^$+(){}|]/\\&/g')
  run -0 git wt list
  assert_line -e "^\* ${escaped_pwd}.*$"
} #}}}

@test "git wt --debug list (with debug)" { #{{{
  run -0 git wt --debug list
  assert_output -p '+ git worktree list'
} #}}}

@test "git wt list shows linked worktrees" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  run -0 git wt add bats_xyz

  run -0 git wt list
  assert_output -p "$(pwd -P)+bats_xyz"
  assert_output -p "[bats_xyz]"
} #}}}

@test "git wt list shows dirty worktree with ! marker" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  run git wt add bats_xyz
  echo "make dirty" >>"$(pwd -P)+bats_xyz/src/git-wt"

  run -0 git wt list
  assert_output -p "$(pwd -P)+bats_xyz"
  assert_output -p "!"
} #}}}

@test "git wt list shows broken worktree with !! (directory missing) marker" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  run git wt add bats_xyz
  rm -rf "$(pwd -P)+bats_xyz"

  run -0 git wt list
  assert_output -p "$(pwd -P)+bats_xyz"
  assert_output -p "!! (directory missing)"

  run git worktree prune
} #}}}

@test "git wt list does not show phantom detached entry" { #{{{
  run -0 git wt list
  refute_output -p "[detached]"
} #}}}

# ── Add: .git-wt-copy ─────────────────────────────────────────────────────────

@test "git wt add: no .git-wt-copy — silent success" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  rm -f "$(pwd -P)/.git-wt-copy"

  run -0 git wt add bats_xyz
  refute_output -p "Copied"
  refute_output -p "WARNING"

  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
} #}}}

@test "git wt add: .git-wt-copy copies file to new worktree" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  echo "test-seed-content" >"$(pwd -P)/.git-wt-copy-seed"
  echo ".git-wt-copy-seed" >"$(pwd -P)/.git-wt-copy"

  run -0 git wt add bats_xyz
  assert_output -p "Copied 1 item(s) from .git-wt-copy"
  [[ -f "$(pwd -P)+bats_xyz/.git-wt-copy-seed" ]]

  rm -f "$(pwd -P)/.git-wt-copy" "$(pwd -P)/.git-wt-copy-seed"
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
} #}}}

@test "git wt add: .git-wt-copy copies directory to new worktree" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  mkdir -p "$(pwd -P)/.git-wt-copy-dir"
  echo "inner" >"$(pwd -P)/.git-wt-copy-dir/inner.txt"
  printf '.git-wt-copy-dir/\n' >"$(pwd -P)/.git-wt-copy"

  run -0 git wt add bats_xyz
  assert_output -p "Copied 1 item(s) from .git-wt-copy"
  [[ -f "$(pwd -P)+bats_xyz/.git-wt-copy-dir/inner.txt" ]]

  rm -rf "$(pwd -P)/.git-wt-copy" "$(pwd -P)/.git-wt-copy-dir"
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
} #}}}

@test "git wt add: .git-wt-copy skips missing source with warning" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  echo "no-such-file-xyz" >"$(pwd -P)/.git-wt-copy"

  run -0 git wt add bats_xyz
  assert_output -p "WARNING"
  refute_output -p "Copied"

  rm -f "$(pwd -P)/.git-wt-copy"
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
} #}}}

@test "git wt add: .git-wt-copy ignores comments and blank lines" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  echo "test-seed-content" >"$(pwd -P)/.git-wt-copy-seed"
  printf '# this is a comment\n\n.git-wt-copy-seed\n' >"$(pwd -P)/.git-wt-copy"

  run -0 git wt add bats_xyz
  assert_output -p "Copied 1 item(s) from .git-wt-copy"
  [[ -f "$(pwd -P)+bats_xyz/.git-wt-copy-seed" ]]

  rm -f "$(pwd -P)/.git-wt-copy" "$(pwd -P)/.git-wt-copy-seed"
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
} #}}}

@test "git wt add: .git-wt-copy rejects absolute paths" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  echo "/etc/passwd" >"$(pwd -P)/.git-wt-copy"

  run -0 git wt add bats_xyz
  assert_output -p "WARNING"
  refute_output -p "Copied"

  rm -f "$(pwd -P)/.git-wt-copy"
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
} #}}}

@test "git wt add: .git-wt-copy rejects paths with .." { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  echo "../something" >"$(pwd -P)/.git-wt-copy"

  run -0 git wt add bats_xyz
  assert_output -p "WARNING"
  refute_output -p "Copied"

  rm -f "$(pwd -P)/.git-wt-copy"
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
} #}}}

# ── Remove ────────────────────────────────────────────────────────────────────

@test "git wt remove (missing name)" { #{{{
  run -1 git wt r
  assert_output -p "ERROR: 'remove' requires a worktree name"
  run -1 git wt rm
  assert_output -p "ERROR: 'remove' requires a worktree name"
  run -1 git wt remove
  assert_output -p "ERROR: 'remove' requires a worktree name"
} #}}}

@test "git wt remove (unknown option)" { #{{{
  run -1 git wt remove --bogus bats_xyz
  assert_line -e "^ERROR: Unknown option '--bogus'$"
} #}}}

@test "git wt remove (extra positional args rejected)" { #{{{
  run -1 git wt remove bats_xyz extra
  assert_line -e "^ERROR: Too many arguments: unexpected 'extra'$"
} #}}}

@test "git wt remove (worktree not found)" { #{{{
  run -1 git wt remove nonexistent_worktree
  assert_line -e '^ERROR: Worktree .* not found$'
} #}}}

@test "git wt --debug remove (missing name, with debug)" { #{{{
  run -1 git wt --debug remove
  # shellcheck disable=SC2016
  assert_output -p '+ missing_worktree_name remove
+ error'
  assert_output -p "ERROR: 'remove' requires a worktree name"
} #}}}

@test "git wt --debug remove bats_xyz (remove, then remove again)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  run git wt add bats_xyz

  run -0 git wt --debug remove bats_xyz
  # shellcheck disable=SC2016
  assert_output -p '++ git worktree list --porcelain'

  run -1 git wt --debug remove bats_xyz
  assert_line -e '^ERROR: Worktree .* not found$'
} #}}}

@test "git wt remove bats_xyz (remove, then remove again)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  run git wt add bats_xyz

  run -0 git wt remove bats_xyz
  assert_line -e "^SUCCESS: Worktree '.*' removed successfully$"

  run -1 git wt remove bats_xyz
  assert_line -e '^ERROR: Worktree .* not found$'
} #}}}

# ── Force remove ──────────────────────────────────────────────────────────────

# Note: this test intentionally leaves bats_dirty in place (dirty);
# subsequent tests clean up defensively before setup
@test "git wt remove bats_dirty (dirty worktree, no force)" { #{{{
  run git wt add bats_dirty
  echo "make dirty" >>"$(pwd -P)+bats_dirty/src/git-wt"

  run ! git wt remove bats_dirty
  assert_line -e '^fatal: .* contains modified or untracked files, use --force to delete it$'
} #}}}

@test "git wt remove (options accepted after positional arg)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  run git wt add bats_xyz

  run -0 git wt remove bats_xyz -d
  assert_line -e "^SUCCESS: Worktree '.*' removed successfully$"
  assert_line -e "^SUCCESS: Branch '.*' deleted$"
} #}}}

@test "git wt remove -- bats_xyz (double-dash end of options)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  run git wt add bats_xyz

  run -0 git wt remove -- bats_xyz
  assert_line -e "^SUCCESS: Worktree '.*' removed successfully$"
} #}}}

@test "git wt remove -f bats_dirty (dirty worktree, with force)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_dirty"
  run git branch -D bats_dirty
  run git wt add bats_dirty
  assert_success

  echo "make dirty" >>"$(pwd -P)+bats_dirty/src/git-wt"

  run -0 git wt remove -f bats_dirty
  assert_line -e "^SUCCESS: Worktree '.*' removed successfully$"

  run -1 git wt remove -f bats_dirty
  assert_line -e '^ERROR: Worktree .* not found$'
} #}}}

@test "git wt remove -d bats_xyz (delete branch after remove)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  run git wt add bats_xyz

  run -0 git wt remove -d bats_xyz
  assert_line -e "^SUCCESS: Worktree '.*' removed successfully$"
  assert_line -e "^SUCCESS: Branch '.*' deleted$"

  run git branch --list bats_xyz
  assert_output ""
} #}}}

@test "git wt remove --delete-branch bats_xyz (long flag)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  run git wt add bats_xyz

  run -0 git wt remove --delete-branch bats_xyz
  assert_line -e "^SUCCESS: Worktree '.*' removed successfully$"
  assert_line -e "^SUCCESS: Branch '.*' deleted$"
} #}}}

@test "git wt remove -d (detached HEAD warns, does not delete branch)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_detach"
  git worktree add --detach "$(pwd -P)+bats_detach" HEAD

  run -0 git wt remove -d bats_detach
  assert_line -e "^SUCCESS: Worktree '.*' removed successfully$"
  assert_output -p "WARNING:"
} #}}}

@test "git wt remove -f -d bats_dirty (force + delete-branch)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_dirty"
  run git branch -D bats_dirty
  run git wt add bats_dirty
  echo "make dirty" >>"$(pwd -P)+bats_dirty/src/git-wt"

  run -0 git wt remove -f -d bats_dirty
  assert_line -e "^SUCCESS: Worktree '.*' removed successfully$"
  assert_line -e "^SUCCESS: Branch '.*' deleted$"

  run git branch --list bats_dirty
  assert_output ""
} #}}}

@test "git wt --debug remove -f bats_dirty (dirty worktree, force + debug)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_dirty"
  run git branch -D bats_dirty
  run git wt add bats_dirty
  assert_success

  echo "make dirty" >>"$(pwd -P)+bats_dirty/src/git-wt"

  # Without --force on a dirty worktree: should fail
  run ! git wt --debug remove bats_dirty
  # shellcheck disable=SC2016
  assert_output -p '++ git worktree list --porcelain'

  # With --force: should succeed
  run -0 git wt --debug remove -f bats_dirty
  assert_line -e "^SUCCESS: Worktree '.*' removed successfully$"

  # Already removed: should fail
  run -1 git wt --debug remove -f bats_dirty
  assert_line -e '^ERROR: Worktree .* not found$'
} #}}}

@test "git wt remove (prefix match)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  run git wt add bats_xyz

  run -0 git wt remove bats_x
  assert_line -e "^SUCCESS: Worktree 'bats_xyz' removed successfully$"

  run -1 git wt remove bats_x
  assert_line -e '^ERROR: Worktree .* not found$'
} #}}}

@test "git wt remove (ambiguous prefix)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git worktree remove --force "$(pwd -P)+bats_dirty"
  run git branch -D bats_xyz
  run git branch -D bats_dirty
  run git wt add bats_xyz
  run git wt add bats_dirty

  run -1 git wt remove bats
  assert_line -e "^ERROR: Ambiguous worktree 'bats'.*$"
  assert_output -p "bats_xyz"
  assert_output -p "bats_dirty"
} #}}}

@test "git wt remove bats_ns/bats_xyz (slash branch)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_ns+bats_xyz"
  rm -rf "$(pwd -P)+bats_ns+bats_xyz"
  run git branch -D bats_ns/bats_xyz
  run git wt add bats_ns/bats_xyz

  run -0 git wt remove bats_ns/bats_xyz
  assert_line -e "^SUCCESS: Worktree '.*' removed successfully$"

  run git branch --list bats_ns/bats_xyz
  assert_output -p "bats_ns/bats_xyz"
} #}}}

@test "git wt remove -d bats_ns/bats_xyz (slash branch + delete-branch)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_ns+bats_xyz"
  rm -rf "$(pwd -P)+bats_ns+bats_xyz"
  run git branch -D bats_ns/bats_xyz
  run git wt add bats_ns/bats_xyz

  run -0 git wt remove -d bats_ns/bats_xyz
  assert_line -e "^SUCCESS: Worktree '.*' removed successfully$"
  assert_line -e "^SUCCESS: Branch '.*' deleted$"

  run git branch --list bats_ns/bats_xyz
  assert_output ""
} #}}}

# ── Cd ────────────────────────────────────────────────────────────────────────

@test "git wt cd (no args prints main worktree)" { #{{{
  main_worktree=$(git worktree list --porcelain | awk 'NR==1{print $2}')
  run -0 git wt c
  assert_output "${main_worktree}"
  run -0 git wt cd
  assert_output "${main_worktree}"
} #}}}

@test "git wt cd (worktree not found)" { #{{{
  run -1 git wt cd nonexistent_worktree
  assert_line -e "^ERROR: Worktree '.*' not found$"
} #}}}

@test "git wt cd bats_xyz (prints path)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  run git wt add bats_xyz

  run -0 git wt c bats_xyz
  assert_output "$(pwd -P)+bats_xyz"
  run -0 git wt cd bats_xyz
  assert_output "$(pwd -P)+bats_xyz"
} #}}}

@test "git wt cd (prefix match)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_dirty"
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_dirty
  run git branch -D bats_xyz
  run git wt add bats_xyz

  run -0 git wt cd bats_x
  assert_output "$(pwd -P)+bats_xyz"
  run -0 git wt cd bats_xy
  assert_output "$(pwd -P)+bats_xyz"
} #}}}

@test "git wt cd (segment match)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  run git worktree remove --force "$(pwd -P)+bats_ns+bats_xyz"
  rm -rf "$(pwd -P)+bats_ns+bats_xyz"
  run git branch -D bats_ns/bats_xyz
  run git wt add bats_ns/bats_xyz

  # "bats_xyz" matches the trailing segment of "+bats_ns+bats_xyz"
  run -0 git wt cd bats_xyz
  assert_output "$(pwd -P)+bats_ns+bats_xyz"

  run git worktree remove --force "$(pwd -P)+bats_ns+bats_xyz"
  run git branch -D bats_ns/bats_xyz
} #}}}

@test "git wt cd (ambiguous prefix)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git worktree remove --force "$(pwd -P)+bats_dirty"
  run git branch -D bats_xyz
  run git branch -D bats_dirty
  run git wt add bats_xyz
  run git wt add bats_dirty

  run -1 git wt cd bats
  assert_line -e "^ERROR: Ambiguous worktree 'bats'.*$"
  assert_output -p "bats_xyz"
  assert_output -p "bats_dirty"
} #}}}

@test "git wt cd (no args invokes fzf when linked worktrees exist)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  run git wt add bats_xyz

  # fake fzf: select whichever candidate contains "bats_xyz"
  fake_fzf=$(mktemp)
  printf '#!/bin/sh\ngrep "bats_xyz"\n' >"${fake_fzf}"
  chmod +x "${fake_fzf}"

  run -0 env GIT_WT_FZF="${fake_fzf}" git wt cd
  assert_output "$(pwd -P)+bats_xyz"

  rm -f "${fake_fzf}"
} #}}}

@test "git wt cd (fzf cancelled returns non-zero)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  run git wt add bats_xyz

  fake_fzf=$(mktemp)
  printf '#!/bin/sh\nexit 130\n' >"${fake_fzf}"
  chmod +x "${fake_fzf}"

  run -1 env GIT_WT_FZF="${fake_fzf}" git wt cd

  rm -f "${fake_fzf}"
} #}}}

@test "git wt cd (ambiguous prefix invokes fzf)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git worktree remove --force "$(pwd -P)+bats_dirty"
  run git branch -D bats_xyz
  run git branch -D bats_dirty
  run git wt add bats_xyz
  run git wt add bats_dirty

  # fake fzf: always select bats_xyz
  fake_fzf=$(mktemp)
  printf '#!/bin/sh\ngrep "bats_xyz"\n' >"${fake_fzf}"
  chmod +x "${fake_fzf}"

  run -0 env GIT_WT_FZF="${fake_fzf}" git wt cd bats
  assert_output "$(pwd -P)+bats_xyz"

  rm -f "${fake_fzf}"
} #}}}

# ── Status ────────────────────────────────────────────────────────────────────

@test "git wt status (all aliases)" { #{{{
  run -0 git wt s
  assert_output -p "$(git worktree list --porcelain | awk 'NR==1{print $2}')"
  run -0 git wt st
  assert_output -p "$(git worktree list --porcelain | awk 'NR==1{print $2}')"
  run -0 git wt status
  assert_output -p "$(git worktree list --porcelain | awk 'NR==1{print $2}')"
} #}}}

@test "git wt status shows clean for main worktree" { #{{{
  run -0 git wt status
  assert_output -p "clean"
} #}}}

@test "git wt status highlights current worktree" { #{{{
  escaped_pwd=$(printf '%s' "$(pwd -P)" | sed 's/[][\\.*^$+(){}|]/\\&/g')
  run -0 git wt status
  assert_line -e "^\* ${escaped_pwd}.*$"
} #}}}

@test "git wt status shows dirty worktree" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  run git wt add bats_xyz
  echo "make dirty" >>"$(pwd -P)+bats_xyz/src/git-wt"

  run -0 git wt status
  assert_output -p "$(pwd -P)+bats_xyz"
  assert_output -p " M src/git-wt"
} #}}}

@test "git wt status shows broken for missing worktree directory" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  run git wt add bats_xyz
  rm -rf "$(pwd -P)+bats_xyz"

  run -0 git wt status
  assert_output -p "$(pwd -P)+bats_xyz"
  assert_output -p "broken (directory missing)"

  run git worktree prune
} #}}}

@test "git wt status does not show phantom detached entry" { #{{{
  run -0 git wt status
  refute_output -p "[detached]"
} #}}}

# ── Completion ────────────────────────────────────────────────────────────────

@test "git wt completion bash" { #{{{
  run -0 git wt completion bash
  assert_output -p '_git_wt()'
  assert_output -p 'complete -F _git_wt git-wt'
  assert_output -p '--delete-branch'
} #}}}

@test "git wt completion zsh" { #{{{
  run -0 git wt completion zsh
  assert_output -p '_git-wt()'
  assert_output -p 'compdef _git-wt git-wt'
  assert_output -p '--delete-branch'
} #}}}

@test "git wt completion (unknown shell)" { #{{{
  run -1 git wt completion fish
  assert_line -e "^ERROR: Unknown shell: 'fish'.*$"
} #}}}

@test "git wt completion (missing shell)" { #{{{
  run -1 git wt completion
  assert_line -e "^ERROR: Unknown shell: ''.*$"
} #}}}

@test "git wt completion works outside a git repository" { #{{{
  run -0 bash -c 'cd /tmp && git wt completion zsh'
  assert_output -p '_git-wt()'
} #}}}

# ── Init ──────────────────────────────────────────────────────────────────────

@test "git wt init bash" { #{{{
  run -0 git wt init bash
  assert_output -p 'wt()'
  assert_output -p 'GIT_WT_CALLER=wt git wt cd'
  assert_output -p 'GIT_WT_CALLER=wt git wt "$@"'
} #}}}

@test "git wt init zsh" { #{{{
  run -0 git wt init zsh
  assert_output -p 'wt()'
  assert_output -p 'GIT_WT_CALLER=wt git wt cd'
} #}}}

@test "git wt init (unknown shell)" { #{{{
  run -1 git wt init fish
  assert_line -e "^ERROR: Unknown shell: 'fish'.*$"
} #}}}

@test "git wt init (missing shell)" { #{{{
  run -1 git wt init
  assert_line -e "^ERROR: Unknown shell: ''.*$"
} #}}}

@test "git wt init works outside a git repository" { #{{{
  run -0 bash -c 'cd /tmp && git wt init bash'
  assert_output -p 'wt()'
} #}}}

@test "wt cd nonexistent aborts without changing directory" { #{{{
  run -1 bash --norc -c "
    eval \"\$(git wt init bash)\"
    wt cd nonexistent_worktree_bats || exit 1
    echo \"__dir__:\$(pwd -P)\"
  "
  refute_output -p "__dir__:"
} #}}}

# ── Prune ─────────────────────────────────────────────────────────────────────

@test "git wt prune (all aliases)" { #{{{
  run -0 git wt p
  assert_success
  assert_output -p "Prune complete"
  run -0 git wt pr
  assert_success
  run -0 git wt prune
  assert_success
} #}}}

@test "git wt prune always passes -v to git" { #{{{
  run -0 git wt --debug prune
  # shellcheck disable=SC2016
  assert_output -p '+ git worktree prune -v'
  assert_output -p "Prune complete"
} #}}}

# vim: set tw=100 expandtab tabstop=2 shiftwidth=2 fdm=marker commentstring=#%s:
