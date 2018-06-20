# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Get current git branch
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Bash prompt
export PS1="\u@\h \[\033[32m\]\w\[\033[34m\]\$(parse_git_branch)\[\033[00m\] $ "

# Up/down arrow searches through history
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\eOA": history-search-backward'
bind '"\eOB": history-search-forward'

# Set the default editors
export EDITOR="/usr/bin/vim"
export VISUAL="/usr/bin/vim"

# Resize text with resized window
shopt -s checkwinsize

# Colour output of man pages
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[30;43m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

# List contents of directory as you enter
cd() { builtin cd "$@"; ls; }

# Set ssh-agent socket
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"


## PYTHON

# Add my packages to python path
export PYTHONPATH=$PYTHONPATH:${HOME}/Code/Python:${HOME}/Code/PROJECTS

# Set virtualenv path
export WORKON_HOME=${HOME}/Code/VirtualEnvs
source /usr/bin/virtualenvwrapper.sh


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

# Sync history between bash sessions
export PROMPT_COMMAND="history -a; history -n"


## ALIASES

# Colour output of ls and make human-readable 
alias ls='ls -h --color=auto'

# Make human-readable the default
alias df='df -h'
alias du='du -h'

# Highlight grepped terms 
export GREP_COLOR="1;34"
alias grep='grep --color=auto'

# Colour output of ip
alias ip='ip -c'

# Find public IP address
alias getip='wget -qO- http://ipecho.net/plain ; echo' 

# Find IP address location
alias wanip='curl ipinfo.io/$(getip) && echo'

# Simple HTTP server
alias ezhttps='python -m http.server'
