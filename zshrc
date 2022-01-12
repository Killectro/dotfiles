# Path to your oh-my-zsh installation.
export ZSH=/Users/dj/.oh-my-zsh
export DOTFILES="$(dirname "$(readlink "$HOME/.zshrc")")"

DEFAULT_USER="dj"

ZSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  bundler
  macos
  zsh-autosuggestions
  gh
  thefuck
)

source $ZSH/oh-my-zsh.sh

# User configuration

bindkey "^U" backward-kill-line
bindkey "^X\x7f" backward-kill-line
bindkey "^X^_" redo

eval "$(frum init)"

source /Users/dj/Work/dotfiles/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
