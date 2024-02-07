xsetroot -cursor_name left_ptr
xrdb -merge ~/.Xresources
xset r rate 170 60

# For matlab support in BSPWM
wmname LG3D

# Keymaps
setxkbmap -layout se -variant nodeadkeys

# Desktop environment(s)
sxhkd &
exec bspwm
#exec gnome-session
#exec i3

# Daemons
exec urxvtd
