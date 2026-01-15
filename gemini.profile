# Firejail profile for gemini CLI

# --- HOME DIRECTORY ---
noblacklist ${HOME}/.gemini
noblacklist ${HOME}/.npm
noblacklist ${HOME}/.config
noblacklist ${HOME}/.nvm
whitelist ${HOME}/.gemini
whitelist ${HOME}/.npm
whitelist ${HOME}/.config/npm
whitelist ${HOME}/.nvm
whitelist ${HOME}/Code
whitelist ${HOME}/dotfiles
include whitelist-common.inc # Enforces home whitelist only

# --- SYSTEM ACCESS ---
include whitelist-run-common.inc
include whitelist-var-common.inc

# --- NETWORK & DNS ---
whitelist /etc/ssl
whitelist /etc/ca-certificates
whitelist /etc/resolv.conf
whitelist /etc/hosts
whitelist /etc/passwd
whitelist /etc/group

# --- SECURITY HARDENING ---
apparmor
caps.drop all
netfilter
nodvd
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp

# --- PRIVATE DIRECTORIES ---
private-cache
private-dev
private-tmp

# --- DISABLE UNNECESSARY FEATURES ---
disable-mnt
