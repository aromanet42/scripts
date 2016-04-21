#!/usr/bin/env bash

# inspired by https://github.com/jeremyFreeAgent/oh-my-zsh-powerline-theme

#  ZSH_THEME_GIT_PROMPT_* used by $(git_prompt_info)
ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%F{red}✭%F{black}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED=" %F{green}✚%F{black}"
ZSH_THEME_GIT_PROMPT_MODIFIED=" %F{blue}✹%F{black}"
ZSH_THEME_GIT_PROMPT_DELETED=" %F{red}✖%F{black}"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %F{yellow}✭%F{black}"
ZSH_THEME_GIT_PROMPT_RENAMED=" ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED=" ═"
ZSH_THEME_GIT_PROMPT_AHEAD=" ⬆"
ZSH_THEME_GIT_PROMPT_BEHIND=" ⬇"
ZSH_THEME_GIT_PROMPT_DIVERGED=" ⬍"


# Color the text with the appropriate colors.
# Usage:
#   text <front> <back> <text>
#
# if color = '-' => reinit color
# if color = ''  => do not change color
#
# Example:
#   text white blue %~
function text() {
  front=$1
  back=$2
  shift argv
  shift argv

  if [ "$front" = "-" ]; then
    front="%f"
  elif [ "$front" != "" ]; then
    front="%F{$front}"
  fi

  if [ "$back" = "-" ]; then
    back="%k"
  elif [ "$back" != "" ]; then
    back="%K{$back}"
  fi


  echo -n "$front$back$argv"
}

function leftSlice() {
  left_front=$1
  left_back=$2
  future_left=$3
  shift argv
  shift argv
  shift argv

  if [ "$argv" != "" ]; then
    text $left_front $left_back "$argv "
    text $left_back $future_left ""
  fi
}

function rightSlice() {
  right_front=$1
  right_back=$2
  shift argv
  shift argv

  if [ "$argv" != "" ]; then
    text $right_back "" ""
    text $right_front $right_back " $argv "
  fi
}

function prompt() {
  echo ""                               # new line before prompt
  leftSlice white blue '-' "%~"         # current path
  text "-" "-" " "                      # reinit color and add space
}

function rprompt() {
  rightSlice black white "$(git_prompt_info)"
  rightSlice black white "%D{%H:%M:%S}"
  rightSlice white black "%(?."".%F{red}✘ %?)"
}

PROMPT='$(prompt)'
RPROMPT='$(rprompt)'
