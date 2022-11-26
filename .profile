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
#locale-gen en_US.UTF-8
#export LANG=en_US.UTF-8
#export LANGUAGE=en_US.UTF-8
#export LC_ALL=en_US.UTF-8
# FIXME for some reason, `locale-gen en_US.UTF-8` gives "sed: couldn't open temporary file /etc/sed0lKzhj: Permission denied" error...


# FIXME append only when not included already? like .cargo/env does?
export PATH=$PATH:$HOME/.local/bin # for stack

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

if which tmux; then
    # auto tmux
    # https://unix.stackexchange.com/a/113768
    if command -v tmux &> /dev/null && [ -n "$PS1" ] && [ -z "$TMUX" ]; then
      case "$TERM" in
        *screen*) ;;
        *tmux*) ;;
        #*) exec tmux
        *) tmux list-sessions && tmux -2 attach || tmux -2
      esac
    fi
fi
