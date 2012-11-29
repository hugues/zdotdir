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
	__preprint "Pensée du jour"
	fortune | fmt -s -w 74
	__preprint
	echo
fi | sed 's/^/   /'

chpwd

