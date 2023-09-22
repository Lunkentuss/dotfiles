[[ $- != *i* ]] && return

export LANG="C"
export LC_ALL="C"

PS1='[\u:\[\e[1;36m\]\W\[\e[1;0m\]]\$ '

__user_packages_share="$HOME/.nix-profile/share"

# Use bash completion if availabe.
__bash_completion="$__user_packages_share"/bash-completion/bash_completion
[[ $PS1 && -f "$__bash_completion" ]] && \
  . "$__bash_completion"

VISUAL="vim"
PATH="$HOME/.krew/bin:$PATH"
PATH="$HOME/local/ampl_linux_intel64/:$PATH"
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/bin:$PATH"
PATH="$HOME/go/bin:$PATH"
PATH="$HOME/.local/share/gem/ruby/3.0.0/bin:$PATH"
PATH="$HOME/.local/share/gem/ruby/3.0.0/bin:$PATH"
PATH="$HOME/.nix-profile/bin:$PATH"
export LD_LIBRARY_PATH=/home/user/.nix-profile/lib

export EDITOR="nvim"

# options
# set -o vi

HISTCONTROL=erasedups
export HISTSIZE=100000

. "$__user_packages_share"/fzf/completion.bash
. "$__user_packages_share"/fzf/key-bindings.bash
alias fvim='vim -p $(fzf -m)'

__fetch_cmd() {
  cat $HOME/.config/cmds/* | fzf | sed -E 's/^[^:]*:[ ]*(.*)/\1/'
}

# alt + e
bind '"\ee":"cmd=\"$(__fetch_cmd)\" && history -s \"$cmd\" && eval \"$cmd\"\n"'

alias t="alacritty &"
alias clipboard="xclip -sel clip"
alias matlab='wmname LG3D ; matlab $1'
alias matlab-vim='wmname LG3D ; python2 $HOME/.config/nvim/plugged/vim-matlab/scripts/vim-matlab-server.py'
alias cp='cp -i'
alias mv='mv -i'
alias vimp='/usr/bin/vim'
alias vim='nvim'
alias grep='grep --color'
alias ls='ls --color=auto --group-directories-first'
alias www='echo $1 | xargs setsid google-chrome'
alias chalmers='ssh -Y petehans@remote11.chalmers.se'
alias studio='./src/android-studio/bin/studio.sh'
alias c='clear'
alias why='echo Cause everyday Im hustlin'
alias mountdl='cd /dev/; sudo mount sdb1 /media/Win7shit/; cd /media/Win7shit/Downloads/'
alias umountdl='cd /dev/; sudo umount sdb1; cd ~'
alias rememberunix='vim ~/Dropbox/linux/dotfiles/UnixCommands.txt'
alias bashrc='vim ~/.bashrc'
alias bspwmrc='vim ~/.config/sxhkd/sxhkdrc'
alias explore='setsid thunar'
alias sl='ls'
alias thunar='setsid thunar'
alias diskspace='du -hs'
alias op='bspc desktop -f ^3 ; setsid google-chrome ; sleep 0.4 ; setsid google-chrome; sleep 0.4; bspc desktop -f ^4; setsid urxvt ; setsid urxvt; sleep 0.4; bspc desktop -f ^6 ; spot'
alias xtime='date | cut -c 17-21'
alias volume='amixer -D pulse sset Master $1'
alias mute='amixer -D pulse sset Master 0%'
alias dark='xbacklight -set 1'
alias beep='(speaker-test -t sine -f 3000 &> /dev/null)& pid_tmp=$! ; sleep 0.2 ; kill -9 $pid_tmp'

alias eduroam='netctl start /etc/netctl/wlp1s0-eduroam'
alias eduroamrestart='netctl restart /etc/netctl/wlp1s0-eduroam'

alias bam='setsid google-chrome-stable https://www.youtube.com/watch?v=dQw4w9WgXcQ'

alias vice="cd /home/snoopy/Dropbox/Cafe\ Bulten/Vice\ ordförande/"

alias minecraft='cd ~/games/minecraft/ ; java -jar Minecraft ~/games/minecraft/ ; java -jar Minecraft.jar'

function pdf(){
    setsid evince $1

}

function yolokill(){
ps -e | grep "$1" | cut -c 2-5 | xargs kill
}

# Android
function androidcp(){
    adb -d push $1 /storage/6163-3636/
}
function androidcproms(){
    adb -d push $1 /external_sd/roms/
}
alias androidstart='adb start-server'
alias androidexit='adb kill-server'
alias androiddevices='adb devices'
alias androidshell='adb -d shell'

function androidinstall(){
    adb -d install $1 
}
#reinstall is same as install, just saves the programs data.
function androidreinstall(){
    adb -d install -r $1
}
