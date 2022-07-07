xsetroot -cursor_name left_ptr
xrdb -merge ~/.Xresources
xset r rate 170 60

xrandr \
	--output eDP1 \
	--output DP1-3 --right-of eDP1 \
	--output DP1-1 --right-of DP1-3

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

# Etc
wmname LG3D
export _JAVA_AWT_WM_NONREPARENTING=1
