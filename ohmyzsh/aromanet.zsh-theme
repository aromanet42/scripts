#!/usr/bin/env bash

# inspired by https://github.com/jeremyFreeAgent/oh-my-zsh-powerline-theme
# and https://github.com/awreece/oh-my-zsh/blob/master/themes/awreece.zsh-theme

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

# Last command time
ZSH_THEME_COMMAND_TIME_THRESHOLD=0.0
last_run_time=0
last_start_time='invalid'
last_command=''
last_status=0

# Executed right before a command is exectued.
function preexec() {
  last_start_time=$(date +%s%3N)
  last_command=$1
}

# Executed right after a command completes.
function precmd() {
  exit_status=$?
  # We do these invalid shenanigans because zsh executes precmd but not preexec
  # if an empty line is entered.
  if [[ $last_start_time != 'invalid' ]]; then
    last_status=$exit_status
    end=$(date +%s%3N)
    last_run_time=$(( end - last_start_time))

    last_start_time='invalid'
    last_command=''
  fi
}


# The (human readable) run time of the last command executed.
function command_time() {
  if (( last_run_time > ZSH_THEME_COMMAND_TIME_THRESHOLD ))
  then
    time_to_human $last_run_time
  fi
}

# Converts a floating point time in seconds to a human readable string.
function time_to_human() {
  millis=$1
  seconds=$(( millis / 1000 ))
  millis=$(( millis % 1000 ))

  if (( seconds < 60 )); then
    printf "%d.%ds" $seconds $millis
  else
    min=$(( seconds / 60 ))
    seconds=$(( seconds % 60 ))
    
    if (( seconds < (60*60) )); then
      printf "%dm%ds" $min $seconds
    else
      hour=$(( min / 60 ))
      min=$(( min % 60 ))

      if (( seconds < (60*60*24) )); then
	printf "%dh%dm%ds" $hour $min $seconds
      else
	day=$(( hour / 24 ))
	hour=$(( hour % 24 ))
	printf "%dd%dh%dm%ds" $day $hour $min $seconds
      fi
    fi
  fi
}


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
  rightSlice white black "$(command_time)"
}

PROMPT='$(prompt)'
RPROMPT='$(rprompt)'
