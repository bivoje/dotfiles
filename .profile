SCRIPT=$SCRIPT:":~/.profile"

# https://serverfault.com/a/500071
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.
# https://askubuntu.com/a/590902
# check if login shell with echo $0

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
umask 022 # newly created file gets permission ~022

## FIXME this should be taken care at /etc/profile.d/01-locale-fix.sh
if locale -a | grep -q '^C.utf8$'; then
    loc=C.UTF-8
elif locale -a | grep -q '^en_US.utf8$'; then
    loc=en_US.UTF-8
else
    loc=
    case "${LANGUAGE:-$LANG}" in
        *UTF-8*) ;;
        *) echo "WARNING: current locale('${LANGUAGE:-$LANG}') is not UTF-8" ;;
    esac
fi
if [ -n "$loc" ]; then
    export LANG=$loc
    export LANGUAGE=$loc
    export LC_ALL=$loc
fi
unset loc

# FIXME append only when not included already? like .cargo/env does?
export PATH=$HOME/.local/bin:$PATH # binaries in ./local/bin has higher precedence than global binaries

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/$HOME/.local/lib

# for rustup / cargo
if [ -e $HOME/.cargo/env ]; then
  . "$HOME/.cargo/env"
fi

# used in fc, crontab
export EDITOR=vim


# ls -l gives date in formal '2022-06-24 12:10'
export TIME_STYLE=long-iso

# tldr output coloring
# Possible settings are: black, red, green, yellow, blue, magenta, cyan,
# white, onblue, ongrey, reset, bold, underline, italic, eitalic, default
# (some variables may not work in some shells).
export TLDR_HEADER='magenta bold underline'
export TLDR_QUOTE='cyan'
export TLDR_DESCRIPTION='green'
export TLDR_CODE='red'
export TLDR_PARAM='blue'


export GPUTOP_RSA_ID=~/.ssh/shepherd_id_rsa

# make clf use color always.
# alternatively we can set 'alias clf "clf --color"' in bashrc
export CLF_COLOR=1

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# disable other users to 'write' to my terminal
mesg n 2> /dev/null || true

if [ -f ~/.profile_sensitive]; then
	# contains api keys, machine specific settings
	source ~/.profile_sensitive
fi

# auto tmux
# https://unix.stackexchange.com/a/113768
if which tmux 2>&1 > /dev/null && [ -n "$PS1" ] && [ -z "$TMUX" ]; then
  case "$TERM" in
    *screen*) ;;
    *tmux*) ;;
    #*) exec tmux
    *) tmux list-sessions && tmux -2 attach || tmux -2
  esac
fi
