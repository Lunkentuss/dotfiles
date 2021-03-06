[[ $- != *i* ]] && return

#PS1='[\u@\h \W]\$ '
#PS1='[\u:\W]\$ '
#PS1='[\u:\[\e[1;31m\]\W\[\e[1;0m\]]\$ '
PS1='[\u:\[\e[1;36m\]\W\[\e[1;0m\]]\$ '

#Variable export

VISUAL="vim"
PATH="$HOME/local/ampl_linux_intel64/:$PATH"
PATH="$HOME/bin:$PATH"
CDPATH="$CDPATH:$HOME"

HISTCONTROL=erasedups #ignoredups

#Egna aliases:

alias matlab='wmname LG3D ; matlab $1'
alias matlab-vim='wmname LG3D ; python2 $HOME/.config/nvim/plugged/vim-matlab/scripts/vim-matlab-server.py'
alias cp='cp -i'
alias mv='mv -i'
alias vimp='/usr/bin/vim'
#alias vim='/usr/bin/vim --noplugin'
alias vim='nvim'
alias grep='grep --color'
alias ls='ls --color=auto --group-directories-first'
alias www='echo $1 | xargs setsid google-chrome'
alias chalmers='ssh -Y petehans@remote11.chalmers.se'
alias studio='./src/android-studio/bin/studio.sh'
alias c='clear'
alias why='echo Cause everyday Im hustlin'
#alias f='setsid firefox; exit'
#alias 2f='setsid firefox; setsid firefox; exit'
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

#CD ALIASES

alias vice="cd /home/snoopy/Dropbox/Cafe\ Bulten/Vice\ ordförande/"

#Games

alias minecraft='cd ~/games/minecraft/ ; java -jar Minecraft ~/games/minecraft/ ; java -jar Minecraft.jar'


function pdf(){
    setsid evince $1

}

function chalmersscp(){
    scp $1 petehans@remote11.chalmers.se:~/scp/

}

function chalmersget(){
    scp petehans@remote11.chalmers.se:$1 ~/scp/
}

#Program:


function yolokill(){
ps -e | grep "$1" | cut -c 2-5 | xargs kill
}

function xfind(){
    find ./ -iname "*$1*"
}

#---------------------------------Functions for android----------------
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

#--------------------------------^^^^^^^^^^^^^^^^^^^^^⁻----------------
#Good for reference :D

function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
 else
    if [ -f $1 ] ; then
        # NAME=${1%.*}
        # mkdir $NAME && cd $NAME
        case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.tar.xz)    tar xvJf $1    ;;
          *.lzma)      unlzma $1      ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       unrar x -ad $1 ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *.xz)        unxz $1        ;;
          *.exe)       cabextract $1  ;;
          *)           echo "extract: '$1' - unknown archive method" ;;
        esac
    else
        echo "$1 - file does not exist"
    fi
fi
}
