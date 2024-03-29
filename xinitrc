#  X Windows startup file

# os system
os=$(uname -s)

# start in home
if [ "$PWD" != "$HOME" ]; then
  cd "${HOME}" || exit 1
fi

# home path
if [ "$os" = "Darwin" ]; then
  if [ -d "${HOME}/opt/bin" ]; then
    if ! echo "$PATH" | grep -qF "${HOME}/opt/bin"; then
      export PATH=${HOME}/opt/bin:${PATH}
    fi
  fi
  if [ -d "${HOME}/bin" ]; then
    if ! echo "$PATH" | grep -qF "${HOME}/bin"; then
      export PATH=${HOME}/bin:${PATH}
    fi
  fi
fi

# settings
bell=0
dmps=0
xrdb=1
xmodmap=0
wmname=1
pulseaudio=$([ "$os" = "Darwin" ] && echo 0 || echo 1)
xautolock=$([ "$os" = "Darwin" ] && echo 0 || echo 1)
autocutsel=0

# default window manager
wm="dwm"

# bell
if [ $bell -eq 1 ]; then
  xset b on &
else
  xset b off &
fi

# dmps
if [ $dmps -eq 1 ]; then
  if [ "$os" != "Darwin" ]; then
    xset +dpms &
  fi
  xset s on &
else
  if [ "$os" != "Darwin" ]; then
    xset -dpms &
  fi
  xset s off &
fi

# xrdb
if [ $xrdb -eq 1 ]; then
  if [ -f "${HOME}/.Xresources" ]; then
    xrdb -merge "${HOME}/.Xresources" &
  fi
fi

# xmodmap
if [ "$xmodmap" -eq 1 ]; then
  if [ -f "${HOME}/.Xmodmap" ]; then
    xmodmap "${HOME}/.Xmodmap" &
  fi
fi

# wmname fixes some java bugs on (dwm, wmii)
if [ $wmname -eq 1 ]; then
  wmname LG3D &
fi

# pulseaudio
if [ "$pulseaudio" -eq 1 ]; then
  if ! pulseaudio --check >/dev/null 2>&1; then
    start-pulseaudio-x11 2>&1 &
  fi
fi

# xautolock
if [ "$xautolock" -eq 1 ]; then
  if command -v slock >/dev/null 2>&1; then
    xautolock -detectsleep -time 5 -locker slock &
  fi
fi

# autocutsel
if [ $autocutsel -eq 1 ]; then
  autocutsel -selection PRIMARY -fork &
  autocutsel -selection CLIPBOARD -fork &
fi

# dwm
if [ "$wm" = "dwm" ]; then
  # background color
  if [ "$os" = "Darwin" ]; then
    # solid space gray pro
    xsetroot -solid '#7A7B80' &
  else
    xsetroot -solid '#333333' &
  fi

  while :; do
    if command -v wmbarupdate >/dev/null 2>&1; then
      wmbarupdate &
    else
      xsetroot -name "$(date +"%a %b %e %H:%M")" &
    fi
    if command -v wmclocksleep >/dev/null 2>&1; then
      sleep "$(wmclocksleep)"
    else
      sleep $((60 - $(/bin/date +%S | sed 's/^0\([0-9]\)/\1/')))
    fi
    # make sure that loop does not exist when X is killed
    if ! ps uxw | grep -qE ' /?[x]init '; then
      break
    fi
  done &
  # $! pid of last bg process
  pidbarloop=$!

  while :; do
    if [ $wm = "dwm" ]; then
      # uxterm &
      dwm
    fi
    if [ "$(printf 'no\nyes' | dmenu -p "Do you want to quit ${wm}?")" = "yes" ]; then
      # double check
      if [ "$(printf 'no\nyes' | dmenu -p "Again, Do you want to quit ${wm}?")" = "yes" ]; then
        break
      fi
    fi
  done

  # kill previous loop if exists (no zombie)
  if [ -n "$pidbarloop" ]; then
    kill $pidbarloop
    if ps -p "$pidbarloop" >/dev/null 2>&1; then
        kill -KILL "$pidbarloop"
    fi
  fi
fi
