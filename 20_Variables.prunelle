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

if ( [ "`uname -s`" = "Darwin" ] )
then
	export DISPLAY=:0

	## Fink / DarwinPorts

	MANPATH=/usr/share/man
	INFOPATH=/usr/share/info

	for i in usr/X11R6 dp sw ; do
		export PATH=$PATH:/$i/bin:/$i/sbin
		export MANPATH=$MANPATH:/$i/share/man
		export INFOPATH=$INFOPATH:/$i/share/info
	done

	typeset -gU PATH MANPATH INFOPATH
fi

PS1_USER="1"
PS1_USER_SSH="$PS1_USER"
PS1_ROOT="31;1"
