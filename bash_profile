#
# ~/.bash_profile
#
# Configuration for a login shell
#

export XKB_DEFAULT_LAYOUT=gb

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export MOZ_ENABLE_WAYLAND=1
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc
