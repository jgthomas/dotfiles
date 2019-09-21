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
if [[ "$SSH_TTY" ]]; then
        host="@\[\033[1;31m\]\h\[\033[00m\]"
else
        host="@\[\033[1;90m\]\h\[\033[00m\]"
fi

# Set prompt
export PS1="\u${host} \[\033[32m\]\w\[\033[36m\]\$(parse_git_branch)\[\033[00m\] $ "


## PYTHON

# Add my packages to python path
export PYTHONPATH=$PYTHONPATH:${HOME}/Code/Python:${HOME}/Code/PROJECTS:${HOME}/Code/msc_courses

# Set virtualenv path
export WORKON_HOME=${HOME}/Code/VirtualEnvs
source /usr/bin/virtualenvwrapper.sh


## RUBY
export GEM_HOME=${HOME}/.gem
PATH="$PATH:$(ruby -e 'print Gem.user_dir')/bin"


## Java

# Quickly output javadoc to own directory
alias jdt='javadoc -d docs -html5'


## Scheme

# launch with SICP support
alias rkt='racket -i -p neil/sicp -l xrepl'


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

# Check current battery state
alias batt="upower -i $(upower -e | grep 'BAT')"

# Run commands on remote backup
if [[ -f ${HOME}/.credentials ]]; then
        . ${HOME}/.credentials
        alias rsdncmd='ssh $RSYNC_DOT_NET_USER@$RSYNC_DOT_NET_DOMAIN'
fi

# Update AUR packages
alias aur_update="aur sync -d aur_packages -u"

# Copy CV to dropbox
alias pubcv="rclone copy CV.pdf my_dropbox:"

# Check wifi strength
alias wifipow="watch -n 1 cat /proc/net/wireless"


## FUNCTIONS

# Control VPN connection
wgvpn() {
        country="switzerland"

        if (($# == 2)); then
                country="$2"
        fi

        case "$1" in
                "start")
                        sudo wg-quick up $country
                        ;;
                "stop")
                        sudo wg-quick down $country
                        ;;
                "status")
                        sudo wg show
                        ;;
        esac
}


# Search package install history
fndpkg() {
        if (($# == 2)); then
                grep -a --color=always -C "$2" "$1" /var/log/pacman.log | less -R
        else
                grep -a --color=always "$1" /var/log/pacman.log | less -R
        fi
}

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

# List all dotfiles
lsdot() {
        ls -a | grep '^\.'
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

# Read markdown files in the terminal
mdread() {
        pandoc "$1" | w3m -T text/html
}

# Read PDF files in terminal
pdfread() {
        lesspipe.sh "$1" | less
}

# Google search direct from command line
google() {
        w3m google.com/search?q="$1"
}

# Report all explicity installed packages, ignoring dependencies
# and excluding those in the base, base-devel and xorg groups
listpkgs() {
        comm -23 <(pacman -Qteq | sort) <(pacman -Qqg base base-devel xorg | sort)
}

# Report all packages installed from a particular repository
repopkgs() {
        pacman -Sl "$1" | grep installed | awk '{print $2}'
}

# Report all packages installed from a named repo that are not
# in the base, base-devel or xorg groups
repo_nongroup() {
        comm -23 <(repopkgs "$1" | sort) <(pacman -Qqg base base-devel xorg | sort)
}


## SOURCE

# Machine-specific commands
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases
