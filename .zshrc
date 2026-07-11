cd $HOME

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=${HOME}/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
# export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="powerlevel10k/powerlevel10k"
# ZSH_THEME="rkj-repos"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(mise aws git docker history colorize colored-man-pages common-aliases golang sublime kubectl history-substring-search python vi-mode terraform helm direnv)
# plugins=(git docker history colorize colored-man-pages common-aliases golang sublime kubectl history-substring-search python vi-mode terraform helm direnv)

ZSH_DISABLE_COMPFIX=true

# source $ZSH/oh-my-zsh.sh
#
# Activate mise
export MISE_ASDF_COMPAT=1
# eval "$(mise activate zsh)"
# eval "$(direnv hook zsh)"
# eval "$(/Users/curt.cunning/.local/bin/mise activate zsh)"
# eval "$(/Users/curt.cunning/.local/bin/mise-x64 activate zsh)"

# Make the search case-insensitive
export HISTORY_SUBSTRING_SEARCH_FUZZY=1

source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
# Dynamically load plugins listed in ~/.zsh_plugins.txt
antidote load

# ---------------------------------------------------------
# Key Bindings & Post-Load Configurations
# ---------------------------------------------------------

# Key bindings for history-substring-search (MUST be after 'antidote load')
bindkey '^[[A' history-substring-search-up
bindkey '^[OA' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OB' history-substring-search-down

# Ensure history search plays nice with your vi-mode plugin
bindkey -M vicmd "k" history-substring-search-up
bindkey -M vicmd "j" history-substring-search-down

# User configuration
# History Settings
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
export HISTFILE="$HOME/.zsh_history"

setopt APPEND_HISTORY # Don't erase history
setopt EXTENDED_HISTORY # Add additional data to history like timestamp
setopt INC_APPEND_HISTORY # Add immediately
setopt HIST_FIND_NO_DUPS # Don't show duplicates in search
setopt HIST_IGNORE_SPACE # Don't preserve spaces. You may want to turn it off
setopt NO_HIST_BEEP # Don't beep
setopt SHARE_HISTORY # Share history between session/terminals

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
export TODOTXT_DEFAULT_ACTION=ls

if which trash > /dev/null 2>&1; then
  alias rm='trash'
fi
if which trash-put > /dev/null 2>&1; then
  alias rm='trash-put'
fi

# Force python3
# alias python="python3"
# alias pip="pip3"

# PIPX config
export PIPX_HOME="${HOME}/.pipx"
export PIPX_BIN_DIR="${HOME}/.bin.local"

# AWS Configuration
export AWS_PAGER=""

# Terraform Configuration
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

# TMUX auto create sessions
tmuxsession=$(tmux list-sessions | grep -v "(attached)" | awk -F':' '{print $1}' | head -1)
if [ ! -z "$tmuxsession" ] ; then
    "tmuxsession" &> /dev/null
else
    if [[ ! $TERM =~ screen ]] && [[ ! $TERM =~ tmux ]] ; then
        tmux
    fi
fi

# Include zshrc.d folder for more configuration
[ -d ~/.zshrc.d ] && for file in ~/.zshrc.d/*; do source $file; done

# include zshrc.local for machine specific configurations
# Some examples might include:
#   eval $(systemctl --user show-environment | grep SSH_AUTH_SOCK)
#   export SSH_AUTH_SOCK
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:${HOME}/.bin:${HOME}/.bin.local:${HOME}/.local/bin:${HOME}/.rvm/bin:${HOME}/.krew/bin"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Activate Starship
# eval "$(starship init zsh)"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/curt.cunning/.docker/completions $fpath)
autoload -Uz compinit
setopt EXTENDED_GLOB
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
unsetopt EXTENDED_GLOB

# proto
export PROTO_HOME="$HOME/.proto";
export PATH="$PROTO_HOME/shims:$PROTO_HOME/bin:$PATH";