##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

# No more core dumps :)
ulimit -c 0

# No dangerous world-writeable files & folders
umask 0022

#  sanity
[[ -t 0 ]] && /bin/stty erase  "^H" intr  "^C" susp "^Z" dsusp "^Y" stop "^S" start "^Q" kill "^U"  >& /dev/null

# unalias shitty alias
alias which >/dev/null && unalias which

