SCRIPT=$SCRIPT:":~/.profile"

# https://serverfault.com/a/500071

# https://askubuntu.com/a/590902
# this file is not executed when login shell
# check if login shell with echo $0

# FIXME this should be taken care at /etc/profile.d/01-locale-fix.sh
locale-gen en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# FIXME append only when not included already? like .cargo/env does?
export PATH=$PATH:~/bin # for my programs
export PATH=$PATH:~/.local/bin # for stack 

# for rustup / cargo
if [ -e $HOME/.cargo/env ]; then
  . "$HOME/.cargo/env"
fi

# tldr output coloring
export TLDR_HEADER='magenta bold underline'
export TLDR_QUOTE='italic'
export TLDR_DESCRIPTION='green'
export TLDR_CODE='red'
export TLDR_PARAM='blue'

# auto tmux
# https://unix.stackexchange.com/a/113768
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [ -z "$TMUX" ]; then
  case "$TERM" in
    *screen*) ;;
    *tmux*) ;;
    *) exec tmux
  esac
fi
