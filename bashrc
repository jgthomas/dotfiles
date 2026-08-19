## GENERAL

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Set the default editors
export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"

shopt -s checkwinsize # Resize text with resized window
shopt -s extglob      # Allow more advanced pattern matching

# Set ssh-agent socket
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"


## MODERN COMMAND LINE TOOL REPLACEMENTS
# Use command <name> to run the original command (for example, command grep)

# Replace grep with ripgrep (rg)
grep() {
    # Run rg, allowing stdout and stderr to pass through normally
    command rg "$@"
    local status=$?

    case $status in
        0|1)
            # 0: Match found
            # 1: No match found
            # In both cases, rg did its job correctly; return the result.
            return "$status"
            ;;
        *)
            # 2: Invalid argument / internal error
            # Fall back to standard grep
            command grep --color=auto "$@"
            return $?
            ;;
    esac
}

# Replace cat with bat
cat() {
    command bat --paging=never "$@"
}

# Replace ls with eza
ls() {
    # --group-directories-first: Keeps folders at the top
    # --icons: Adds visual cues (requires a Nerd Font)
    # --git: Shows git status for files in the listing
    command eza --group-directories-first "$@"
}

# fzf
FZF_IGNORE='"!{node_modules/*,.git/*,.stack-work/*,.idea/*,target/*,build/*}"'
export FZF_DEFAULT_COMMAND='rg --files --follow --no-ignore-vcs --hidden -g '${FZF_IGNORE}


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

## DOCKER

# stop all running containers
alias docstop='docker stop $(docker ps -a -q)'
# delete all containers
alias docdel='docker rm $(docker ps -a -q)'


## Gemini CLI
alias gemini='firejail --quiet --profile=~/.config/firejail/gemini.profile /usr/bin/gemini --no-sandbox'


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

# Make human-readable the default
alias df='df -h'
alias du='du -h'

# Colour output of ip
alias ip='ip -c'

# Find public IP address
alias getip='curl --fail --silent --show-error https://api.ipify.org ; echo'

# Find IP address location
alias wanip='curl --fail --silent --show-error https://ipinfo.io/json && echo'

# Check current battery state
alias batt='upower -i "$(upower -e | command grep BAT)"'

# Run commands on remote backup
if [[ -f ${HOME}/.credentials ]]; then
        . ${HOME}/.credentials
        alias rsdncmd='ssh $RSYNC_DOT_NET_USER@$RSYNC_DOT_NET_DOMAIN'
fi

# List available AUR upgrades
alias aur_check="aur repo -d aur_packages -u"

# Update AUR packages
alias aur_update="aur sync -d aur_packages -u"

# Copy CV to dropbox
alias pubcv="rclone copy CV.pdf my_dropbox:"

# Check wifi strength
alias wifipow="watch -n 1 cat /proc/net/wireless"

# Use neovim
alias vi="nvim"
alias vim="nvim"
alias vimdiff="nvim -d"

## FUNCTIONS

# Control VPN connection
wgvpn() {
        default="switzerland"
        usage="wgvpn start|stop|status [country], defaults to *"$default"*"

        [[ $# -eq 2 ]] && country=$2 || country=$default

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
                *)
                        echo $usage
                        ;;
        esac
}

# Search package install history
pkglog() {
        logfile="/var/log/pacman.log"
        args="-a --color=always "

        if (($# == 2)); then
                args=$args"-C"$2
        fi

        grep --color=always $1 $logfile | less -R
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

# Display PATH as vertical list
path() {
    echo "$PATH" | tr ':' '\n'
}

# cat file to screen and highlight pattern
cathi() {
    grep --passthru --color=always "$1" $2
}

# Search every file in directory for text, displays filename and line no.
ftext ()
{
	grep "$1" . | less -r
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
    eza -D --group-directories-first --git "$@"
}


# List all files
lsfile() {
    eza -f --git "$@"
}

# List all dotfiles
lsdot() {
        eza -a | grep '^\.'
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

# Report all explicity installed packages, ignoring dependencies
# and excluding those in the base, base-devel and xorg groups
listpkgs() {
        comm -23 <(pacman -Qteq | sort) <(pacman -Qqg base base-devel xorg | sort)
}

# Report all packages installed from a particular repository
repopkgs() {
        pacman -Sl "$1" | grep 'installed' | awk '{print $2}'
}

# Report all packages installed from a named repo that are not
# in the base, base-devel or xorg groups
repo_nongroup() {
        comm -23 <(repopkgs "$1" | sort) <(pacman -Qqg base base-devel xorg | sort)
}

# Nicer hoggle search
hoogle() {
        stack exec -- hoogle "$1"
}

doc() {
        stack exec -- hoogle --info "$1"
}

# w3m Shortcuts
# Helper for formatting searches
_format_query() {
    echo "$*" | sed 's/ /+/g'
}

ddg() {
    [[ -z "$1" ]] && { echo "Usage: ddg <search terms>"; return 1; }
    w3m "https://lite.duckduckgo.com/lite/?q=$(_format_query "$@")"
}

archwiki() {
    if [[ -z "$1" ]]; then
        w3m "https://wiki.archlinux.org/"
    else
        w3m "https://wiki.archlinux.org/index.php?search=$(_format_query "$@")"
    fi
}

wikipedia() {
    if [[ -z "$1" ]]; then
        w3m "https://en.wikipedia.org/"
    else
        w3m "https://en.wikipedia.org/wiki/Special:Search?search=$(_format_query "$@")"
    fi
}


## SOURCE

# Machine-specific commands
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

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
