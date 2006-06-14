#!/bin/zsh
## No more core dumps :)
ulimit -c 0
umask 002

##
##  sanity
##
[[ -t 0 ]] && /bin/stty erase  "^H" intr  "^C" susp "^Z" dsusp "^Y" stop "^S" start "^Q" kill "^U"  >& /dev/null


# Variables utiles

  _color_black=\033[30m
    _color_red=\033[31m
  _color_green=\033[32m
 _color_yellow=\033[33m
   _color_blue=\033[34m
_color_magenta=\033[35m
   _color_cyan=\033[36m

    _unset_color=\033[0m
     _color_bold=\033[1m
_color_underline=\033[4m
