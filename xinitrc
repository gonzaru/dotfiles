#  X Windows startup file

# settings
bell=0
dmps=0
xrdb=0
wmname=1
pulseaudio=1
xautolock=1
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
  xset +dpms &
  xset s on &
else
  xset -dpms &
  xset s off &
fi

# xrdb
if [ $xrdb -eq 1 ]; then
  if [ -f "${HOME}/.Xdefaults" ]; then
    xrdb -merge "${HOME}/.Xdefaults" &
  fi
fi

# wmname fixes some java bugs on (dwm, wmii)
if [ $wmname -eq 1 ]; then
  wmname LG3D &
fi

# pulseaudio
if [ $pulseaudio -eq 1 ]; then
  if ! pulseaudio --check >/dev/null 2>&1; then
    start-pulseaudio-x11 2>&1 &
  fi
fi

# xautolock
if [ $xautolock -eq 1 ]; then
  xautolock -detectsleep -time 5 -locker slock &
fi

# autocutsel
if [ $autocutsel -eq 1 ]; then
  autocutsel -selection PRIMARY -fork &
  autocutsel -selection CLIPBOARD -fork &
fi

# dwm
if [ "$wm" = "dwm" ]; then
  # background color
  xsetroot -solid '#333333' &

  while :; do
    if command -v updatewmbar >/dev/null 2>&1; then
        updatewmbar
    fi
    if command -v wmclocksleep >/dev/null 2>&1; then
      sleep "$(wmclocksleep)"
    else
      sleep $((60 - $(/bin/date +%S | sed 's/^0\([0-9]\)/\1/')))
    fi
    # make sure that loop does not exists when X is killed
    if ! pgrep xinit >/dev/null 2>&1; then
      break
    fi
  done &

  # $! pid of last bg process
  pidbarloop=$!

  while :; do
    if [ $wm = "dwm" ]; then
      "${HOME}/opt/dwm/dwm"
    fi
    if [ "$(printf 'no\nyes' | dmenu -p "Do you really want to quit ${wm}?")" = "yes" ]; then
      # double check
      if [ "$(printf 'no\nyes' | dmenu -p "Again, Do you really want to quit ${wm}?")" = "yes" ]; then
        break
      fi
    fi
  done

  # kill previous loop if exists (no zombie)
  if [ -n "$pidbarloop" ]; then
    kill $pidbarloop
  fi
fi