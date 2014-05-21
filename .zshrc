# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="kluck"

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

bindkey '^q' push-line-or-edit


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

source $HOME/.rvm/scripts/rvm

# Customize to your needs...
alias -s properties="vim"
alias -s xml="vim"
alias -s log="tail -n500 -f"
alias resource="source ~/.zshrc"


export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
