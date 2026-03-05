#!/usr/bin/env bats

bats_require_minimum_version 1.5.0

setup_file() { #{{{
  echo "Setting up environment"
} #}}}

teardown_file() { #{{{
  echo "Cleaning up environment"
  run git worktree remove --force "$(pwd -P)+bats_dirty"
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_dirty
  run git branch -D bats_xyz
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

} #}}}

# ── Usage / Help ─────────────────────────────────────────────────────────────

@test "git wt (no args) shows usage" { #{{{
  run -0 git-wt
  assert_line -n 0 'Usage: git-wt [options] <command> [<worktree>]'
  run -0 git wt
  assert_line -n 0 'Usage: git-wt [options] <command> [<worktree>]'
} #}}}

@test "git wt -h shows usage and all options" { #{{{
  run -0 git wt -h
  assert_line -n 0 'Usage: git-wt [options] <command> [<worktree>]'
  assert_output -p '-h'
  assert_output -p '-d | --debug'
  assert_output -p '-f | --force'
  assert_output -p '-v | --verbose'
  assert_output -p 'a | add'
  assert_output -p 'l | ls | list'
  assert_output -p 'r | rm | remove'
  assert_output -p 'p | pr | prune'
  assert_output -p 's | sw | switch'
  assert_output -p 'v | version'
} #}}}

# ── Version ──────────────────────────────────────────────────────────────────

@test "git wt version" { #{{{
  run -0 git wt v
  assert_line -e '^git-wt version [0-9]+\.[0-9]+\.[0-9]+$'
  run -0 git wt version
  assert_output -p 'git-wt version'
} #}}}

# ── Unknown argument ──────────────────────────────────────────────────────────

@test "git wt abcxyz (unknown argument)" { #{{{
  run -1 git wt abcxyz
  assert_line -e '^ERROR: Unknown argument: abcxyz$'
} #}}}

# ── Debug flag ────────────────────────────────────────────────────────────────

@test "git wt -d (no command) shows trace then usage" { #{{{
  run -0 git wt -d
  assert_output -p '+ shift
+ continue
+ [[ 0 -ge 1 ]]'
} #}}}

@test "git wt -d abcxyz (unknown argument, with debug)" { #{{{
  run -1 git wt -d abcxyz
  # shellcheck disable=SC2016
  assert_output -p '+ shift
+ continue
+ [[ 1 -ge 1 ]]
+ case "${1}" in
+ error'
  assert_line -e '^ERROR: Unknown argument: abcxyz$'
} #}}}

# ── Add ───────────────────────────────────────────────────────────────────────

@test "git wt add (missing name)" { #{{{
  run -1 git wt a
  assert_output -p "ERROR: 'add' requires a worktree name"
  run -1 git wt add
  assert_output -p "ERROR: 'add' requires a worktree name"
} #}}}

@test "git wt add HEAD (commit reference rejected)" { #{{{
  run -1 git wt add HEAD
  assert_output -p "ERROR: Please provide a branch name, not a commit reference"
  run -1 git wt add HEAD~1
  assert_output -p "ERROR: Please provide a branch name, not a commit reference"
} #}}}

@test "git wt -d add (missing name, with debug)" { #{{{
  run -1 git wt -d add
  # shellcheck disable=SC2016
  assert_output -p '+ shift
+ continue
+ [[ 1 -ge 1 ]]
+ case "${1}" in
+ shift
+ [[ 0 -ge 1 ]]
+ missing_worktree_name add
+ error'
  assert_output -p "ERROR: 'add' requires a worktree name"
} #}}}

@test "git wt -d add bats_xyz (create, then duplicate)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz

  run -0 git wt -d add bats_xyz
  # shellcheck disable=SC2016
  assert_output -p '+ add_worktree bats_xyz'
  assert_line -e '^HEAD is now at .*$'

  run -1 git wt -d add bats_xyz
  assert_line -e '^ERROR: Worktree .* already exists$'
} #}}}

@test "git wt add bats_xyz (create, then duplicate)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz

  run -0 git wt add bats_xyz
  assert_line -e '^HEAD is now at .*$'
  assert_output -p "Worktree created at:"
  assert_output -p "cd '"

  run -1 git wt add bats_xyz
  assert_line -e '^ERROR: Worktree .* already exists$'
} #}}}

# ── List ──────────────────────────────────────────────────────────────────────

@test "git wt list (all aliases)" { #{{{
  run -0 git wt l
  assert_line -n 0 -e '^.* \[(master|main)\]$'
  run -0 git wt ls
  assert_line -n 0 -e '^.* \[(master|main)\]$'
  run -0 git wt list
  assert_line -n 0 -e '^.* \[(master|main)\]$'
} #}}}

@test "git wt list highlights current worktree" { #{{{
  escaped_pwd=$(printf '%s' "$(pwd -P)" | sed 's/[][\.*^$+(){}|]/\\&/g')
  run -0 git wt list
  assert_line -e "^${escaped_pwd}.*$"
} #}}}

@test "git wt -d list (with debug)" { #{{{
  run -0 git wt -d list
  assert_output -p '+ git worktree list'
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

@test "git wt remove (worktree not found)" { #{{{
  run -1 git wt remove nonexistent_worktree
  assert_line -e '^ERROR: Worktree .* not found$'
} #}}}

@test "git wt -d remove (missing name, with debug)" { #{{{
  run -1 git wt -d remove
  # shellcheck disable=SC2016
  assert_output -p '+ missing_worktree_name remove
+ error'
  assert_output -p "ERROR: 'remove' requires a worktree name"
} #}}}

@test "git wt -d remove bats_xyz (remove, then remove again)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  run git wt add bats_xyz

  run -0 git wt -d remove bats_xyz
  # shellcheck disable=SC2016
  assert_output -p '+ git worktree list --porcelain
+ grep -Fq'

  run -1 git wt -d remove bats_xyz
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

@test "git wt -f remove bats_dirty (dirty worktree, with force)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_dirty"
  run git branch -D bats_dirty
  run git wt add bats_dirty
  assert_success

  echo "make dirty" >>"$(pwd -P)+bats_dirty/src/git-wt"

  run -0 git wt -f remove bats_dirty
  assert_line -e "^SUCCESS: Worktree '.*' removed successfully$"

  run -1 git wt -f remove bats_dirty
  assert_line -e '^ERROR: Worktree .* not found$'
} #}}}

@test "git wt -f -d remove bats_dirty (dirty worktree, force + debug)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_dirty"
  run git branch -D bats_dirty
  run git wt add bats_dirty
  assert_success

  echo "make dirty" >>"$(pwd -P)+bats_dirty/src/git-wt"

  # Without --force on a dirty worktree: should fail
  run ! git wt -d remove bats_dirty
  # shellcheck disable=SC2016
  assert_output -p '+ git worktree list --porcelain
+ grep -Fq'

  # With --force: should succeed
  run -0 git wt -f -d remove bats_dirty
  assert_line -e "^SUCCESS: Worktree '.*' removed successfully$"

  # Already removed: should fail
  run -1 git wt -f -d remove bats_dirty
  assert_line -e '^ERROR: Worktree .* not found$'
} #}}}

# ── Switch ────────────────────────────────────────────────────────────────────

@test "git wt switch (missing name)" { #{{{
  run -1 git wt s
  assert_output -p "ERROR: 'switch' requires a worktree name"
  run -1 git wt sw
  assert_output -p "ERROR: 'switch' requires a worktree name"
  run -1 git wt switch
  assert_output -p "ERROR: 'switch' requires a worktree name"
} #}}}

@test "git wt switch (worktree not found)" { #{{{
  run -1 git wt switch nonexistent_worktree
  assert_line -e "^ERROR: Worktree '.*' not found$"
} #}}}

@test "git wt switch bats_xyz (prints path)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  run git wt add bats_xyz

  run -0 git wt s bats_xyz
  assert_output "$(pwd -P)+bats_xyz"
  run -0 git wt sw bats_xyz
  assert_output "$(pwd -P)+bats_xyz"
  run -0 git wt switch bats_xyz
  assert_output "$(pwd -P)+bats_xyz"
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

@test "git wt -v prune (verbose flag passed to git)" { #{{{
  run -0 git wt -v prune
  assert_success
  assert_output -p "Prune complete"
} #}}}

@test "git wt -d prune (with debug)" { #{{{
  run -0 git wt -d prune
  # shellcheck disable=SC2016
  assert_output -p '+ git worktree prune'
} #}}}

# vim: set tw=100 expandtab tabstop=2 shiftwidth=2 fdm=marker commentstring=#%s:
