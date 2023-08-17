export SCRIPT+=":~/.bashrc"

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
# https://stackoverflow.com/a/42757277
case $- in
    *i*) ;;
      *) return;;
esac
#~ [ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth #~ =ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# show timestamps using `history`
HISTTIMEFORMAT='%F %T '

# NOTE
# use `history -c` to clear history
# use `HISTSIZE=0` to disable logging at all

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [[ -x "$(command -v starship)" ]]; then
	# load starship if installed
	eval "$(starship init bash)"

elif [ "$color_prompt" = yes ]; then
	if [[ -x "$(command -v grep)" ]] && [[ -x "$(command -v sed)" ]] && [[ -x "$(command -v date)" ]]; then
	. ~/.bashrc_prompt
	else
		PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
	fi
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# QoL options for ed editor
if command -v rlwrap &>/dev/null; then
	alias ed='rlwrap ed -p "* " -v'
else
	alias ed='ed -p "* " -v'
fi

# report average/maximum memory usage https://superuser.com/a/1169636
# make it report more verbosely with -v flag. https://stackoverflow.com/a/46874737
if which time &>/dev/null; then
    alias time="`which time` -f 'real\t%E\nuser\t%U\nsys\t%S\namem\t%K\nmmem\t%M\n'"
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
# notify-send only works on desktop environment
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

alias tmux="tmux -2"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# convert windows path format to linux path format
# '\' is escaped by the shell in ANY CASE,
# so we need to pass the windows path via stdin to avoid substitution
# e.g.
#   $ ls `wp2lp`
#   Z:\users\eunyoung\BIOSNAP\gene\reactome_human_TAS.tsv
#   ^D
#   /home/bivoje/Z/users/eunyoung/BIOSNAP/gene/reactome_human_TAS.tsv
# assuming NAS is mounted to ~/Z on linux, Z:\ on windows
wp2lp () { cat | tr '\\' '/' | sed 's/^\(.\):/\/home\/bivoje\/\1/'; }

# ls ++ less; useful when exploring through unfamiliar directories
# use with `!$` which gets expanded to the last arg of the last command
es () { arg=${1:-.};
  if ! [ -e "$arg" ]; then
    echo file \'$arg\' not exists!
    return 1
  elif [ -d "$arg" ]; then
    ls "$arg";
  elif file "$arg" | grep -q 'text'; then
    less "$arg"
  else
    file "$arg"
  fi
  return 0
}


# backup stty setting for malfunctioning program execution
# do `reset ^J` and `stty sane ^J` to work in normal mode
# do `stty $STTY` to recover terminal setting
# see https://stackoverflow.com/a/36718540
STTY=`stty -g`

# shepherd has time-based logout, remove the time limit
export TMOUT=

# for some reason, bash gets "^[[1;5D" while tmux gets "^[OD" when Ctrl-Left presed
# bindings are not inherited, so put in here rather than .profile
bind '"\eOD":backward-word'
bind '"\eOC":forward-word'

# prevent CTRL-S to suspend terminal
stty -ixon

# audible bell sends \a (ascii bell) to the terminal (e.g. tput bel)
# visible bell supposed to flash the entire screen (e.g. tput flash), but does not work in all terminals
# avoid using audible bell, since I usually use audible bells to generate notifications in terminal ends
# (for tasks finished, e.g. `time-consumming-job; printf \\a` then the terminal sends a message to discord webhook)
bind 'set bell-style visible'


# Handy function definitions from Extreme Ultimate bashrc https://sourceforge.net/projects/ultimate-bashrc/

# Search process names to kill
# https://unix.stackexchange.com/questions/443472/alias-for-killing-all-processes-of-a-grep-hit
function smash() {
	local T_PROC=$1
	local T_PIDS=($(pgrep -i "$T_PROC"))
	if [[ "${#T_PIDS[@]}" -ge 1 ]]; then
		echo "Found the following processes:"
		for pid in "${T_PIDS[@]}"; do
			echo "$pid" "$(\ps -p "$pid" -o comm= | awk -F'/' '{print $NF}')" | column -t
		done
		if ask "Kill them?" N; then
			for pid in "${T_PIDS[@]}"; do
				echo "Killing ${pid}..."
				( kill -15 "$pid" ) && continue
				sleep 2
				( kill -2 "$pid" ) && continue
				sleep 2
				( kill -1 "$pid" ) && continue
				echo "Cannot terminate" >&2 && return 1
			done
		else
			echo "Exiting..."
			return 0
		fi
	else
		echo "No processes found for: $1" >&2 && return 1
	fi
}

# See what command you are using the most (this parses the history command)
function mostused() {
	history \
	| awk ' { a[$4]++ } END { for ( i in a ) print a[i], i | "sort -rn | head -n10"}' \
	| awk '$1 > max{ max=$1} { bar=""; i=s=10*$1/max;while(i-->0)bar=bar"#"; printf "%25s %15d %s %s", $2, $1,bar, "\n"; }'
}

# Make a string safe to be used in regular expressions
function regexformat() {
	echo -n "$(printf '%s' "${1}" | sed 's/[.[\(\)\ *^$+?{|]/\\&/g')"
}

# Commands pushd and popd now output the directory stack after modification
# and also prevents duplicate directories being added to the directory stack
pushd() {
	builtin pushd "${@}" > /dev/null
	echo "Directory Stack:"
	dirs -v
}

popd() {
	builtin popd "${@}" > /dev/null
	echo "Directory Stack:"
	dirs -v
}

grepr() {
	grep -iIHrn --color=always "${@}" . | $PAGER -r
}

# Print a list of colors
function colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

# Print a list of 256 colors
function colors256() {
	for j in {0..15} ; do
		for i in {0..15} ; do
			printf "\x1b[38;5;%dm%03d " $((16*j+i)) $((16*j+i))
		done
		printf "\n"
	done
}

# Test for 24bit true color in the terminal
function colors24bit() {
	echo 'If the gradients are smooth, you are displaying 24bit true color.'
	awk 'BEGIN{
		s='1234567890';
		s=s s s s s s s s s s s s s s s s s s s s s s s;
		for (colnum = 0; colnum<256; colnum++) {
			r = 255-(colnum*255/255);
			g = (colnum*510/255);
			b = (colnum*255/255);
			if (g>255) g = 510-g;
			printf "\033[48;2;%d;%d;%dm", r,g,b;
			printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
			printf "%s\033[0m", substr(s,colnum+1,1);
		}
		printf "\n";
	}'
}
