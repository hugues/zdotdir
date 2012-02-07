##
## Part of configuration files for Zsh4
## AUTHOR: Hugues Hiegel <hugues@hiegel.fr>
## 
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##

_prompt_colors[target]="1;31"

__two_lines_prompt ()
{
	## Le prompt le plus magnifique du monde, et c'est le mien !
	# Affiche l'user, l'host, le tty et le pwd. Rien que ça...
	PS1=$AGENTS$MAILSTAT$ERROR$BATTERY$C_$_prompt_colors[bar]$_C$STLINUX$HBAR$DATE"
"$C_$prompt_color[default]$_C$C_$_prompt_colors[user]$_C"%n"$C_$_prompt_colors[arob]$_C"@"$C_$_prompt_colors[host]$_C"%m"$C_$_prompt_colors[display]$_C"${DISPLAY:+($DISPLAY)} "$CURDIR$CVSTAG$SVNREV$GITBRANCH$HGBRANCH" "$C_$_prompt_colors[soft_generic]$_C${TARGET:+[}$C_$_prompt_colors[target]$_C${TARGET:+$TARGET}$C_$_prompt_colors[soft_generic]$_C${TARGET:+] }$C_$_prompt_colors[dies]$_C"%#"$C_$_prompt_colors[cmd]$_C" "

}
