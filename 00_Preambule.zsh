#!/bin/zsh
## No more core dumps :)
ulimit -c 0
umask 002

##
##  sanity
##
[[ -t 0 ]] && /bin/stty erase  "^H" intr  "^C" susp "^Z" dsusp "^Y" stop "^S" start "^Q" kill "^U"  >& /dev/null

