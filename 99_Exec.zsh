##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

if __cmd_exists fortune
then
	preprint "Pensée du jour" && echo
	fortune fr | fmt -s -w 74
	preprint "" && echo
	echo
fi | sed 's/^/   /'

chpwd

