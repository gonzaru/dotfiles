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
if [[ $VIMRUNTIME =~ "MacVim" ]]; then
  alias vim="mvim -v -u ~/.vimrc"
  alias gvim="mvim -u ~/.vimrc"
  alias view="mview -v -u ~/.vimrc"
  alias rview="mview -v -Z -u ~/.vimrc"
else
  alias vim="vim -u ~/.vimrc"
  alias gvim="gvim -u ~/.vimrc"
  alias view="view -u ~/.vimrc"
  alias rview="rview -u ~/.vimrc"
fi

# emacs
alias emacs="emacs -nw"

# set a reasonable default umask
# -rw-r--r-- for regular files
# drwxr-xr-x for directories
umask 22

# Disable zsh warning
if [[ $os == "Darwin" && $SHELL == "/bin/bash" ]]; then
  export BASH_SILENCE_DEPRECATION_WARNING=1
fi

# PS1 prompt
if [[ $USER == "root" ]]; then
  export PS1="\w\e[0;31m\]#\[\e[0m "
else
  export PS1="\w\$ "
fi

# default
PATH="/sbin:/bin:/usr/sbin:/usr/bin"

# local
local_path="/usr/local/sbin /usr/local/bin /usr/pkg/sbin /usr/pkg/bin /opt/sbin /opt/bin"
for path in $local_path; do
  [[ -d $path ]] && PATH="${PATH}:${path}"
done

# home
[[ -d ${HOME}/opt/bin ]] && PATH="${HOME}/opt/bin:${PATH}"
[[ -d ${HOME}/bin ]] && PATH="${HOME}/bin:${PATH}"

# pkgsrc
[[ -d ${HOME}/opt/pkg/sbin ]] && PATH="${PATH}:${HOME}/opt/pkg/sbin"
[[ -d ${HOME}/opt/pkg/bin ]] && PATH="${PATH}:${HOME}/opt/pkg/bin"

# mac ports
[[ -d /opt/local/sbin ]] && PATH="${PATH}:/opt/local/sbin"
[[ -d /opt/local/bin ]] && PATH="${PATH}:/opt/local/bin"

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
elif [[ "$os" == "Darwin" ]]; then
  MANPATH=$(manpath)
fi
if [[ -n $MANPATH ]]; then
  [[ -d /opt/local/share/man ]] && MANPATH=/opt/local/share/man:${MANPATH}
  [[ -d ${HOME}/opt/pkg/man ]] && MANPATH=${HOME}/opt/pkg/man:${MANPATH}
  [[ -d ${HOME}/opt/man ]] && MANPATH=${HOME}/opt/man:${MANPATH}
  export MANPATH
fi

#  prompt command title (dwm, xmonad, wmii, etc..)
case $TERM in
  xterm|xterm-256color|screen|screen-256color|tmux|tmux-256color)
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
elif hash vi 2>/dev/null; then
  export EDITOR="vi"
  export VISUAL="vi"
fi

# default pager
if hash less 2>/dev/null; then
  export PAGER="less"
  export LESSCHARSET="utf-8"
  export LESS="-R -M -X"
elif hash more 2>/dev/null; then
  export PAGER="more"
fi

# manpages with color support
if [[ $PAGER == "most" ]]; then
  export MANCOLOR
fi

# default non X graphical browser
if [[ $os != "Darwin" && -z $DISPLAY ]]; then
  if hash lynx 2>/dev/null; then
    export BROWSER="lynx"
  fi
fi

# locales
case $os in
  Linux|Darwin)
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

# bash completion
if [[ $os == "Linux" ]]; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
  fi
elif [[ $os == "Darwin" ]]; then
  bash_version=$(echo "$BASH_VERSION" | cut -d '.' -f1)
  if ((bash_version >= 5)); then
    if [[ -f ${HOME}/opt/pkg/bash-completion/bash_completion ]]; then
      . ${HOME}/opt/pkg/bash-completion/bash_completion
    elif [[ -f /opt/local/etc/profile.d/bash_completion.sh ]]; then
      . /opt/local/etc/profile.d/bash_completion.sh
    fi
  fi
fi

# completion aws cli
if [[ -f ${AWS}/bin/aws_completer ]]; then
  complete -C "${AWS}/bin/aws_completer" aws
elif hash aws_completer 2>/dev/null; then
  complete -C "$(command -v aws_completer)" aws
fi

# enable xterm 256 colors (vim, tmux, tig, etc..)
if [[ -f /usr/share/terminfo/x/xterm-256color || -f /lib/terminfo/x/xterm-256color || $os == "Darwin" ]]; then
  if [[ $TERM == "xterm" ]]; then
    export TERM=xterm-256color
  fi
fi
