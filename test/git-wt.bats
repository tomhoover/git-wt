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
  assert_output -p 'r | rm | remove'
  assert_output -p '-v | --verbose'
  assert_output -p 'a | add         ) add a worktree'
  assert_output -p 'l | ls | list'
  assert_output -p 'r | rm | remove'
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
  script_version=$(grep '^VERSION=' "$DIR/../src/git-wt" | cut -d'"' -f2)
  run -0 git wt version
  assert_output "git-wt version ${script_version}"
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

@test "git wt add (no args shows error)" { #{{{
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

@test "git wt -d add (no args shows error, with debug)" { #{{{
  run -1 git wt -d add
  # shellcheck disable=SC2016
  assert_output -p '+ shift
+ [[ 0 -ge 1 ]]
+ missing_worktree_name add'
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
  assert_output -p "(new branch)"
  assert_output -p "cd '"

  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run -0 git wt add bats_xyz
  assert_output -p "Worktree created at:"
  assert_output -p "(existing branch)"

  run -1 git wt add bats_xyz
  assert_line -e '^ERROR: Worktree .* already exists$'
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

# ── List ──────────────────────────────────────────────────────────────────────

@test "git wt list (all aliases)" { #{{{
  run -0 git wt l
  assert_line -n 0 -e '^.* \[.+\]$'
  run -0 git wt ls
  assert_line -n 0 -e '^.* \[.+\]$'
  run -0 git wt list
  assert_line -n 0 -e '^.* \[.+\]$'
} #}}}

@test "git wt list highlights current worktree" { #{{{
  escaped_pwd=$(printf '%s' "$(pwd -P)" | sed 's/[][\.*^$+(){}|]/\\&/g')
  run -0 git wt list
  assert_line -e "^\* ${escaped_pwd}.*$"
} #}}}

@test "git wt -d list (with debug)" { #{{{
  run -0 git wt -d list
  assert_output -p '+ git worktree list'
} #}}}

@test "git wt -v list (verbose flag does not error)" { #{{{
  run -0 git wt -v list
  assert_line -n 0 -e '^.* \[.+\]$'
} #}}}

@test "git wt list shows linked worktrees" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_xyz"
  run git branch -D bats_xyz
  run -0 git wt add bats_xyz

  run -0 git wt list
  assert_output -p "$(pwd -P)+bats_xyz"
  assert_output -p "[bats_xyz]"
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
+ grep -Fxq'

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

@test "git wt -d remove -f bats_dirty (dirty worktree, force + debug)" { #{{{
  run git worktree remove --force "$(pwd -P)+bats_dirty"
  run git branch -D bats_dirty
  run git wt add bats_dirty
  assert_success

  echo "make dirty" >>"$(pwd -P)+bats_dirty/src/git-wt"

  # Without --force on a dirty worktree: should fail
  run ! git wt -d remove bats_dirty
  # shellcheck disable=SC2016
  assert_output -p '+ git worktree list --porcelain
+ grep -Fxq'

  # With --force: should succeed
  run -0 git wt -d remove -f bats_dirty
  assert_line -e "^SUCCESS: Worktree '.*' removed successfully$"

  # Already removed: should fail
  run -1 git wt -d remove -f bats_dirty
  assert_line -e '^ERROR: Worktree .* not found$'
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

@test "git wt -v cd (verbose flag does not error)" { #{{{
  main_worktree=$(git worktree list --porcelain | awk 'NR==1{print $2}')
  run -0 git wt -v cd
  assert_output "${main_worktree}"
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

# ── Completion ────────────────────────────────────────────────────────────────

@test "git wt completion bash" { #{{{
  run -0 git wt completion bash
  assert_output -p '_git_wt()'
  assert_output -p 'complete -F _git_wt git-wt'
} #}}}

@test "git wt completion zsh" { #{{{
  run -0 git wt completion zsh
  assert_output -p '_git-wt()'
  assert_output -p 'compdef _git-wt git-wt'
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
  run -0 git wt -v -d prune
  # shellcheck disable=SC2016
  assert_output -p '+ git worktree prune -v'
  assert_output -p "Prune complete"
} #}}}

@test "git wt -d prune (with debug)" { #{{{
  run -0 git wt -d prune
  # shellcheck disable=SC2016
  assert_output -p '+ git worktree prune'
  refute_output -p '+ git worktree prune -v'
} #}}}

# vim: set tw=100 expandtab tabstop=2 shiftwidth=2 fdm=marker commentstring=#%s:
