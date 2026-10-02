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
