#!/usr/bin/env bash

# inspired by https://github.com/jeremyFreeAgent/oh-my-zsh-powerline-theme
# and https://github.com/awreece/oh-my-zsh/blob/master/themes/awreece.zsh-theme

#  ZSH_THEME_GIT_PROMPT_* used by $(git_prompt_info)
ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✭%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED=" ✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="✹"
ZSH_THEME_GIT_PROMPT_DELETED=" ✖"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" ✭"
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
    printf " ("
    time_to_human $last_run_time
    printf ")"
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
#   text <front> <text>
#
# if color = '-' => reinit color
# if color = ''  => do not change color
#
# Example:
#   text white %~
#
# available colors :
#   - by name : red, blue, green, black, white
#   - by code : list codes with 
#                 for code in {000..255}; do print -P -- "$code: %F{$code}Test%f"; done
function text() {
  front=$1
  shift argv

  if [ "$front" = "-" ]; then
    front="%{$reset_color%}"
  elif [ "$front" != "" ]; then
    front="%{$fg[$front]%}"
  fi

  echo -n "$front$argv"
}

function prompt() {
  echo ""                           # new line before prompt
  text cyan "%~➤"                   # current path
  text "-" " "                      # reinit color and add space
}

function rprompt() {
  text yellow '$(git_prompt_info)$(git_prompt_ahead)$(git_prompt_behind) '
  text "-" "%D{%H:%M:%S}"
  text "-" "%(?."".%{$fg[red]%} ✘%?)"
  text "-" "$(command_time)"
}

PROMPT='$(prompt)'
RPROMPT="$(rprompt)"
