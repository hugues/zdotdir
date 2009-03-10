##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

PS1_USER="1"
if [ "$OSTYPE" = "linux-gnu" ]
then
	PS1_ROOT="31"
else
	PS1_ROOT="31;1"
fi
