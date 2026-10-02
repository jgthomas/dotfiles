## DOCKER

# stop all running containers
alias docstop='docker stop $(docker ps -a -q)'
# delete all containers
alias docdel='docker rm $(docker ps -a -q)'


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
