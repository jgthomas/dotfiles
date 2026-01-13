# Save as ~/.config/firejail/gemini.profile
noblacklist ${HOME}/.gemini
whitelist ${HOME}/.gemini

# Ignore Docker artifacts and system admin paths
ignore blacklist /var/lib/docker
ignore blacklist /sbin
ignore blacklist /usr/sbin

# Allow access to your code projects (Change this path!)
whitelist ${HOME}/Code
whitelist ${HOME}/dotfiles

noblacklist /usr/bin/node
noblacklist /usr/local/bin/node
noblacklist /usr/bin/npm

# Restrict everything else
include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

# All these stay the same
caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
