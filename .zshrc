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
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/etc/profile.d/conda.sh" ]; then
        . "/usr/etc/profile.d/conda.sh"
    else
        export PATH="/usr/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Command completion notification for long-running commands in Zsh

# Function to record command start time
function record_command_start() {
  # Reset the timer
  COMMAND_START_TIME=$SECONDS
}

# Function to show notification for long-running commands
function notify_command_complete() {
  local EXIT_CODE=$?
  local DURATION=$((SECONDS - COMMAND_START_TIME))
  local CMD=$(fc -ln -1)
  
  # Only notify if command ran longer than threshold (e.g., 10 seconds)
  if [ $DURATION -gt 10 ]; then
    local ICON="dialog-information"
    local STATUS="succeeded"
    
    if [ $EXIT_CODE -ne 0 ]; then
      ICON="dialog-error"
      STATUS="failed"
    fi
    
    dunstify -i $ICON "Command $STATUS" "Command: $CMD\nDuration: ${DURATION}s\nExit code: $EXIT_CODE" 
  fi
}

# Hook into Zsh's preexec and precmd hooks
autoload -Uz add-zsh-hook
add-zsh-hook preexec record_command_start
add-zsh-hook precmd notify_command_complete

