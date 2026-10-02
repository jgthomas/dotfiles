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

# Get current git branch
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

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
    if (( $# < 1 || $# > 2 )); then
        printf 'Usage: pkglog <pattern> [context-lines]\n' >&2
        return 2
    fi

    local pattern=$1
    local context_lines=${2:-}
    local logfile=/var/log/pacman.log
    local -a grep_options=(--color=always)

    if [[ -n $context_lines ]]; then
        if [[ ! $context_lines =~ ^[0-9]+$ ]]; then
            printf 'pkglog: context must be a non-negative integer\n' >&2
            return 2
        fi

        grep_options+=(-C "$context_lines")
    fi

    grep "${grep_options[@]}" -- "$pattern" "$logfile" | less -R
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

# Extract archive files
extract() {
    if (( $# == 0 )); then
        printf 'Usage: extract <archive> [archive ...]\n' >&2
        return 2
    fi

    local archive
    local overall_status=0
    local -a extract_command

    for archive in "$@"; do
        if [[ ! -r $archive ]]; then
            printf 'extract: cannot read: %s\n' "$archive" >&2
            overall_status=1
            continue
        fi

        case "${archive,,}" in
            *.tar|*.tar.gz|*.tgz|*.tar.bz2|*.tbz|*.tbz2|\
            *.tar.xz|*.txz|*.tar.lz|*.tlz|*.tar.lzma|\
            *.tar.zst|*.tzst|*.tar.z|*.taz)
                extract_command=(bsdtar --extract --verbose --file)
                ;;
            *.7z)
                extract_command=(7z x)
                ;;
            *.zip|*.jar|*.war|*.apk)
                extract_command=(unzip)
                ;;
            *.rar)
                extract_command=(unrar x)
                ;;
            *.gz)
                extract_command=(gunzip)
                ;;
            *.bz2)
                extract_command=(bunzip2)
                ;;
            *.xz)
                extract_command=(unxz)
                ;;
            *.zst)
                extract_command=(unzstd)
                ;;
            *.z)
                extract_command=(uncompress)
                ;;
            *.cpio)
                extract_command=(bsdtar --extract --verbose --file)
                ;;
            *)
                printf 'extract: unsupported archive type: %s\n' "$archive" >&2
                overall_status=1
                continue
                ;;
        esac

        if ! command "${extract_command[@]}" "$archive"; then
            printf 'extract: failed to extract: %s\n' "$archive" >&2
            overall_status=1
        fi
    done

    return "$overall_status"
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

# Write an ISO image to a USB device selected by xorriso-dd-target.
iso2usb() {
    if (( $# != 1 )); then
        printf 'Usage: iso2usb <image.iso>\n' >&2
        return 2
    fi

    if [[ ! -f $1 || ! -r $1 ]]; then
        printf 'iso2usb: file not found or not readable: %s\n' "$1" >&2
        return 1
    fi

    if ! command -v xorriso-dd-target >/dev/null 2>&1; then
        printf 'iso2usb: xorriso-dd-target is not installed (Arch package: libisoburn)\n' >&2
        return 127
    fi

    command xorriso-dd-target \
        -with_sudo \
        -plug_test \
        -DO_WRITE \
        -image_file "$1"
}
