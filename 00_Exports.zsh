export EDITOR="vim"
export HISTFILE=".zsh/.history.zsh"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/libs
eval $(dircolors ~/.dir_colors 2>&-)
export PATH=$PATH:~/sbin:~/bin
export PKG_CONFIG_PATH=/usr/X11R6/lib/pkgconfig
#export PRINTER=Gertrude
export PRINTER=Berthe
export TIME_STYLE="+%Y-%b-%d %H:%M"
export TZ="Europe/Paris"
export PATH=$PATH:~/.pr0n
source $ZDOTDIR/.keychain
# Set locales only if they are undefined
export LC_ALL=${LC_ALL:-fr_FR.UTF-8}
export LC_MESSAGES=${LC_MESSAGES:-fr_FR}
export MANPATH=$MANPATH:~/man
unset LANG # Unuseful
