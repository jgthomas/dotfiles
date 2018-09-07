## GENERAL

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Set the default editors
export EDITOR="/usr/bin/vim"
export VISUAL="/usr/bin/vim"

shopt -s checkwinsize # Resize text with resized window
shopt -s extglob      # Allow more advanced pattern matching

# Set ssh-agent socket
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"


## PROMPT

# Get current git branch
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Different colours for local and remote hosts
if [[ -z "$DISPLAY" ]]; then
        host="@\[\033[1;31m\]\h\[\033[00m\]"
else
        host="@\[\033[1;90m\]\h\[\033[00m\]"
fi

# Set prompt
export PS1="\u${host} \[\033[32m\]\w\[\033[34m\]\$(parse_git_branch)\[\033[00m\] $ "


## PYTHON

# Add my packages to python path
export PYTHONPATH=$PYTHONPATH:${HOME}/Code/Python:${HOME}/Code/PROJECTS

# Set virtualenv path
export WORKON_HOME=${HOME}/Code/VirtualEnvs
source /usr/bin/virtualenvwrapper.sh


## HISTORY

# Up/down arrow searches through history
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\eOA": history-search-backward'
bind '"\eOB": history-search-forward'

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

# Commands NOT to add to history
export HISTIGNORE="cd:ls:bg:fg:history:su"


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


## FUNCTIONS

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

# Display PATH as vertical list
path() ( IFS=: ; printf '%s\n' $PATH ; )

# cat file to screen and highlight pattern
cathi() {
    grep -E "$1|$" $2
}

# Search every file in directory for text, displays filename and line no.
ftext ()
{
	# -i case-insensitive
	# -I ignore binary files
	# -H causes filename to be printed
	# -r recursive search
	# -n causes line number to be printed
	grep -iIHrn --color=always --exclude-dir='.git' "$1" . | less -r
}

# Extract range or archive files
extract() {
    local c e i

    (($#)) || return

    for i; do
        c=''
        e=1

        if [[ ! -r $i ]]; then
            echo "$0: file is unreadable: \`$i'" >&2
            continue
        fi

        case $i in
            *.t@(gz|lz|xz|b@(2|z?(2))|a@(z|r?(.@(Z|bz?(2)|gz|lzma|xz)))))
                   c=(bsdtar xvf);;
            *.7z)  c=(7z x);;
            *.Z)   c=(uncompress);;
            *.bz2) c=(bunzip2);;
            *.exe) c=(cabextract);;
            *.gz)  c=(gunzip);;
            *.rar) c=(unrar x);;
            *.xz)  c=(unxz);;
            *.zip) c=(unzip);;
            *)     echo "$0: unrecognized file extension: \`$i'" >&2
                   continue;;
        esac

        command "${c[@]}" "$i"
        ((e = e || $?))
    done
    return "$e"
}

# Move up a specified number of directory levels
up() {
        if [[ $1 -lt 1 ]]; then
                echo "Must be a positive number of levels up" >&2
                return -1;
        fi

        curr=""

        for ((i=1; i<=$1; i++)); do
                curr="${curr}../"
        done

        cd $curr
}

# List all directories
lsdir() {
        ls -l . | grep ^d
}


# List all files
lsfile() {
        ls -l . | grep ^-
}

# Set a base dir to return to easily
anchor() {
        ANCHOR=$(pwd)
        export ANCHOR
}

# Return to the anchor directory
haul() {
        cd $ANCHOR
}


## SOURCE

# Machine-specific commands
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases
