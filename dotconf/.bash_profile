export XDG_CONFIG_HOME="$HOME/.config"
export WEB_BROWSER="chromium"
xset r rate 250 30

if [ -z "$DISPLAY" ] && [ "$(fgconsole)" -eq 1 ]; then
  exec startx
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc
