# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh


# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="aromanet"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Annoyed of the auto-correct functionality?
unsetopt correct_all

setopt INTERACTIVE_COMMENTS # allow inline comments

autoload -U zmv

#using vim bindings (dw, b, w...)
bindkey -v

bindkey '^q' push-line-or-edit

bindkey '^w' backward-kill-word
#ctrl-left
bindkey '^[[1;5D' vi-backward-word
#crtl-right
bindkey '^[[1;5C' vi-forward-word


if [ -n "$DESKTOP_SESSION" ];then 
  # No point to start gnome-keyring-daemon if ssh-agent is not up 
  if [ -n "$SSH_AGENT_PID" ];then 
    eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,gpg,ssh)
    export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK
  fi
fi

if [ -f ~/.env ];then
  source ~/.env
  alias srcenv="source ~/.env"
fi

# Customize to your needs...
alias -s properties="vim"
alias -s xml="vim"
alias -s log="tail -n500 -f"
alias resource="source ~/.zshrc"

alias nautilus="nautilus --no-desktop"

alias gw="./gradlew --daemon"

alias git="LANGUAGE=en_US.UTF-8 git" # Toujours utiliser l'anglais pour Git
alias command="LANGUAGE=en_US command"

export PATH="$PATH:$HOME/bin:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export HISTTIMEFORMAT='%F %T ' # show history with datetime
setopt histexpiredupsfirst
setopt histignorealldups
setopt histignoredups
setopt histignorespace
setopt HIST_IGNORE_SPACE       # do not add commands beginning with space in history
setopt histreduceblanks
setopt histsavenodups

export TERM="xterm-256color"

eval "$(fasd --init posix-alias zsh-hook)"
alias v='f -e vim' # quick opening files with vim
alias o='xdg-open' # quick opening files with xdg-open


#PECO
function peco-select-history() {
  local tac
  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi
  BUFFER=$(\history -n 1 | \
    eval $tac | \
    peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}

if hash peco 2>/dev/null; then
  zle -N peco-select-history
  bindkey '^r' peco-select-history
else
  echo "You should install peco! https://github.com/peco/peco"
fi


