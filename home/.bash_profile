export XDG_CONFIG_HOME="$HOME/.config"
export BROWSER="firefox"
xset r rate 250 50

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
