##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

## Mettez le nom de votre station de travail habituelle ici ##
if { ! -e ~/.workstation ]
then
	echo >&2 "Quelle est votre station de travail attitrée ? (`hostname -s`) " && read $workstation
	echo ${workstation:-$(hostname -s)} > ~/.workstation
fi
WORKSTATION=$(cat ~/.workstation)

export LC_ALL=fr_FR
[ "$TERM" = "rxvt-unicode" ] && export TERM=rxvt

#export PATH=${PATH:+$PATH:}~/souche_linux_pl/tools/bin:/usr/local/urd2/bin:/usr/local/urd2/openrg2_6/mips-linux-uclibc/bin/
#export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}~/souche_linux_pl/tools/lib
#export MANPATH=${MANPATH:+$MANPATH:}/usr/local/urd2/man:~/souche_linux_pl/tools/man:~/souche_linux_pl/tools/share/man

PATH=$PATH:/opt/edtm/bin
PATH=$PATH:/opt/openrg/mips-linux-uclibc/bin
typeset -gU PATH MANPATH

#__PREFIX=/filer1/dev_users/hiegel/souche_linux_pl/tools/

export http_proxy="http://proxy:3128"
export ftp_proxy=$http_proxy
