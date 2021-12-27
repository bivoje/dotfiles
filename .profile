export PATH=$PATH:~/bin

export TLDR_HEADER='magenta bold underline'
export TLDR_QUOTE='italic'
export TLDR_DESCRIPTION='green'
export TLDR_CODE='red'
export TLDR_PARAM='blue'
if [ -e $HOME/.cargo/env ]; then
  . "$HOME/.cargo/env"
fi
