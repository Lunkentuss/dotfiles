xsetroot -cursor_name left_ptr
xrdb -merge ~/.Xresources
xset r rate 250 40

#xrandr --output HDMI1 --pos -1920x-1080
xrandr --output eDP1 --primary
xrandr --output HDMI1 --pos 3200x0

# For matlab support in BSPWM
wmname LG3D


#---------- DE'S ---------------

#exec gnome-session

sxhkd &
exec bspwm

#exec i3


#---------- DEAMONS ------------

exec urxvtd

#---------- Key-maps -----------

setxkbmap -layout se -variant nodeadkeys

#---------- ETC ----------------
# For matlab support in BSPWM
wmname LG3D
export _JAVA_AWT_WM_NONREPARENTING=1
