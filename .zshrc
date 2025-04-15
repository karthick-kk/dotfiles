if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH=~/.oh-my-zsh
DISABLE_AUTO_UPDATE=true
DISABLE_MAGIC_FUNCTIONS=true
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(zsh-syntax-highlighting zsh-autosuggestions)

source ~/.oh-my-zsh/oh-my-zsh.sh
source ~/.p10k.zsh
export PATH=$PATH:$HOME/.arkade/bin/

export USE_CCACHE=1
export CCACHE_DIR=~/.ccache
export CCACHE_EXEC=$(which ccache)
export CCACHE_MAXSIZE=50G

alias gc='git cherry-pick'