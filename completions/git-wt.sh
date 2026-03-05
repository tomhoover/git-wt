# shellcheck shell=bash
# Bash completion for git-wt / git wt
#
# Installation:
#   Source this file from your ~/.bashrc:
#     source /path/to/completions/git-wt.sh
#   Or copy to your bash_completion.d directory:
#     cp completions/git-wt.sh /etc/bash_completion.d/git-wt

_git_wt_branches() {
  git branch --format='%(refname:short)' 2>/dev/null
}

_git_wt_worktrees() {
  git worktree list --porcelain 2>/dev/null \
    | awk '/^worktree/{p=$2} /^branch/{if(p~/\+/){sub("refs/heads/",""); print $2}}'
}

_git_wt() {
  local cur="${COMP_WORDS[COMP_CWORD]}"

  # Determine the subcommand index:
  #   'git wt <cmd>' → index 2
  #   'git-wt <cmd>' → index 1
  local subcmd_index=1
  [[ "${COMP_WORDS[0]}" == "git" ]] && subcmd_index=2

  local subcmd="${COMP_WORDS[$subcmd_index]:-}"

  case "$subcmd" in
    add | a)
      mapfile -t COMPREPLY < <(compgen -W "$(_git_wt_branches)" -- "$cur")
      ;;
    remove | rm | r | switch | sw | s)
      mapfile -t COMPREPLY < <(compgen -W "$(_git_wt_worktrees)" -- "$cur")
      ;;
    *)
      local commands="add a list ls l remove rm r prune p pr switch sw s version v"
      mapfile -t COMPREPLY < <(compgen -W "$commands" -- "$cur")
      ;;
  esac
}

complete -F _git_wt git-wt

# Register for 'git wt' if git's __git_complete helper is available
if declare -f __git_complete >/dev/null 2>&1; then
  __git_complete git-wt _git_wt
fi
