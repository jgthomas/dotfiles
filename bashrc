## GENERAL

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Shared shell functions
if [[ -f ~/.bash_functions ]]; then
    . ~/.bash_functions
elif [[ -f ~/dotfiles/bash_functions ]]; then
    . ~/dotfiles/bash_functions
fi

# Set the default editors
export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"
export SUDO_EDITOR="/usr/bin/nvim"

shopt -s checkwinsize # Resize text with resized window
shopt -s extglob      # Allow more advanced pattern matching

# Set ssh-agent socket
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"


# fzf
FZF_IGNORE='"!{node_modules/*,.git/*,.stack-work/*,.idea/*,target/*,build/*}"'
export FZF_DEFAULT_COMMAND='rg --files --follow --no-ignore-vcs --hidden -g '${FZF_IGNORE}


## PROMPT

# Different colours for local and remote hosts
if [[ "$SSH_TTY" ]]; then
        host="@\[\033[1;31m\]\h\[\033[00m\]"
else
        host="@\[\033[1;90m\]\h\[\033[00m\]"
fi

# Set prompt
export PS1="\u${host} \[\033[32m\]\w\[\033[36m\]\$(parse_git_branch)\[\033[00m\] $ "

## HISTORY

# Show time command in history used
export HISTTIMEFORMAT="%d/%m/%y %T "

# Ignores duplicates and omits commands prefixed by a space
export HISTCONTROL=ignoredups:ignorespace

# Increase command history size
HISTSIZE=10000
HISTFILESIZE=20000

# Enable history appending instead of overwriting
shopt -s histappend

# Commands NOT to add to history
export HISTIGNORE="cd:ls:bg:fg:history:su:exit"


# Shared shell aliases
if [[ -f ~/.bash_aliases ]]; then
    . ~/.bash_aliases
elif [[ -f ~/dotfiles/bash_aliases ]]; then
    . ~/dotfiles/bash_aliases
fi

# Add additional locations to PATH
if command -v fnm &> /dev/null; then
    eval "$(fnm env --use-on-cd --shell bash)"
fi

REQUIRED_PATHS=(
    "$HOME/.local/bin"
    "$HOME/go/bin"
)

for p in "${REQUIRED_PATHS[@]}"; do
    if [[ -d "$p" && ":$PATH:" != *":$p:"* ]]; then
        export PATH="$p:$PATH"
    fi
done

export PATH=$(echo -n "$PATH" | awk -v RS=: -v ORS=: '!arr[$0]++' | sed 's/:$//')

# Show fastfetch if not ssh login
if [[ -z "$SSH_TTY" ]]; then
    fastfetch
fi
