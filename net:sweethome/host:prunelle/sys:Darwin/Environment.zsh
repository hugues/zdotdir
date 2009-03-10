#!/bin/zsh
##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

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
