#!/bin/zsh
##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@nullpart.net>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

export PATH=${PATH:+$PATH:}~/souche_linux_pl/tools/bin:/usr/local/urd2/bin:/usr/local/urd2/openrg2_6/mips-linux-uclibc/bin/
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}~/souche_linux_pl/tools/lib
export MANPATH=${MANPATH:+$MANPATH:}/usr/local/urd2/man:~/souche_linux_pl/tools/man:~/souche_linux_pl/tools/share/man
typeset -gU PATH MANPATH

__PREFIX=/filer1/dev_users/hiegel/souche_linux_pl/tools/
