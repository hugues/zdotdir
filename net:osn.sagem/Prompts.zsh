
redisplay_prompt ()
{
	# Reprise du redisplay_prompt officiel + ajout du mode workset

	local KERNEL_MODE
	[ -e ../../kernel_mode.txt ] && KERNEL_MODE="$C_$color[bg-black];$color[blue]$_C `cat ../../kernel_mode.txt` $C_$prompt_colors[generic]$_C "

	PS1="$AGENTS""$MAILSTAT""$ERROR""$BATTERY"$C_$prompt_colors[bar]$_C"$HBAR""$DATE
"$C_$prompt_colors[user]$_C"%n"$C_$prompt_colors[arob]$_C"@"$C_$prompt_colors[host]$_C"%m $CURDIR$SVNREV$GITBRANCH $KERNEL_MODE"$C_$prompt_colors[dies]$_C"%#"$C_$prompt_colors[cmd]$_C" "
}


