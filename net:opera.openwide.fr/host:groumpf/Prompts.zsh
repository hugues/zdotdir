##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

preexec ()
{
    term_title "$(echo $1 | tr '	\n' ' ;' | sed 's/%/%%/g;s/\\/\\\\/g;s/;$//')"
	print -Pn "$C_$prompt_colors[exec]$_C"

	__START_CMD_DATE=$(date)
	__START_CMD_ZSH_=$(date "+%s")
}

precmd()
{
	__START_CMD_ZSH_=${__START_CMD_ZSH_:-$(date "+%s")}
	[ "$[ `date "+%s"` - $__START_CMD_ZSH_ ]" -gt 1 ] && echo "[1;30m$__START_CMD_DATE[0m"

	update_prompt
	redisplay_prompt
}

