# Bash environment

# exit if shell is non-interactive
if [[ $- != *i* ]]; then
  return
fi

# checks the window size after each command
shopt -s checkwinsize

# os system
os=$(uname -s)

# ls, grep output color
lscolor=0
grepcolor=1

# see CLICCOLOR for FreeBSD
if [[ $lscolor == 1 ]]; then
  alias ls="ls --color=auto -F"
else
  alias ls="ls -F"
fi

# color for (grep, fgrep, egrep)
if [[ $grepcolor == 1 ]]; then
  alias grep="grep --color=auto"
  alias fgrep="fgrep --color=auto"
  alias egrep="egrep --color=auto"
  export GREP_COLOR="31"  # red
fi

# interactive confirm
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# vim
alias vim="vim -u ~/.vimrc"
alias gvim="gvim -u ~/.vimrc"

# emacs
alias emacs="emacs -nw"

# set a reasonable default umask
# -rw-r--r-- for regular files
# drwxr-xr-x for directories
umask 22

# PS1 prompt
if [[ $USER == "root" ]]; then
  export PS1="\w\e[0;31m\]#\[\e[0m "
else
  export PS1="\w\$ "
fi

# default
PATH="/sbin:/bin:/usr/sbin:/usr/bin"

# local
local_path="/usr/local/sbin /usr/local/bin /usr/pkg/sbin /usr/pkg/bin /opt/bin"
for path in $local_path; do
  [[ -d $path ]] && PATH="${PATH}:${path}"
done

# home
[[ -d ${HOME}/bin ]] && PATH="${PATH}:${HOME}/bin"
[[ -d ${HOME}/opt/bin ]] && PATH="${PATH}:${HOME}/opt/bin"

# plan9
PLAN9="${HOME}/opt/plan9" && [[ -d $PLAN9 ]] && export PLAN9
[[ -d ${PLAN9}/bin ]] && PATH="${PATH}:${PLAN9}/bin"

# go
GOROOT="${HOME}/opt/go" && [[ -d $GOROOT ]] && export GOROOT
GOPATH="${HOME}/go" && [[ -d $GOPATH ]] && export GOPATH
[[ -d ${GOROOT}/bin ]] && PATH="${PATH}:${GOROOT}/bin"
[[ -d ${GOPATH}/bin ]] && PATH="${PATH}:${GOPATH}/bin"

# aws
AWS="${HOME}/opt/aws"
[[ -d ${AWS}/bin ]] && PATH="${PATH}:${AWS}/bin"

# set
export PATH

# MANPATH
if [[ "$os" == "Linux" ]]; then
  MANPATH=$(manpath -g)
  [[ -d /opt/man ]] && MANPATH=${MANPATH}:/opt/man
  [[ -d ${HOME}/opt/man ]] && MANPATH=${MANPATH}:${HOME}/opt/man
  export MANPATH
fi

#  prompt command title (dwm, xmonad, wmii, etc..)
case $TERM in
  xterm|xterm-256color|screen|screen-256color|tmux-256color)
    # remote ssh user@hostname
    if [[ -n $REMOTEHOST ]]; then
      PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}:${PWD}\007"'
    else
      PROMPT_COMMAND='echo -ne "\033]0;${PWD/#${HOME}/\~}\007"'
    fi
    export PROMPT_COMMAND
    ;;
esac

# default editor
if hash vim 2>/dev/null; then
  export EDITOR="vim"
  export VISUAL="vim"
else
  export EDITOR="vi"
  export VISUAL="vi"
fi

# default pager
if hash less 2>/dev/null; then
  export PAGER="less"
  export LESSCHARSET="utf-8"
  export LESS="-R -M -X"
else
  export PAGER="more"
fi

# manpages with color support
if [[ $PAGER == "most" ]]; then
  export MANCOLOR
fi

# default non X graphical browser
if [[ -z $DISPLAY ]]; then
  export BROWSER="lynx"
fi

# locales
case $os in
  Linux)
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
    ;;
  FreeBSD)
    export LANG="en_US.UTF-8"
    export MM_CHARSET="en_US.UTF-8"
    ;;
  NetBSD)
    export LANG="en_US.UTF-8"
    export LC_TYPE="en_US.UTF-8"
    export LC_ALL=""
    ;;
esac

# completion aws cli
if [[ -f ${AWS}/bin/aws_completer ]]; then
  complete -C "${AWS}/bin/aws_completer" aws
fi

# enable xterm 256 colors (vim, tmux, tig, etc..)
if [[ -f /usr/share/terminfo/x/xterm-256color || -f /lib/terminfo/x/xterm-256color ]]; then
  if [[ $TERM == "xterm" ]]; then
    export TERM=xterm-256color
  fi
fi
