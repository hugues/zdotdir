##
## Part of configuration files for Zsh4
## AUTHOR: Hugues Hiegel <hugues@hiegel.fr>
## 
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##

two_lines_prompt ()
{
	## Le prompt le plus magnifique du monde, et c'est le mien !
	# Affiche l'user, l'host, le tty et le pwd. Rien que ça...
	PS1=$AGENTS$MAILSTAT$ERROR$BATTERY$C_$prompt_colors[bar]$_C$STLINUX$HBAR$DATE"
"$C_$prompt_color[default]$_C$C_$prompt_colors[user]$_C"%n"$C_$prompt_colors[arob]$_C"@"$C_$prompt_colors[host]$_C"%m"$C_$prompt_colors[display]$_C"${DISPLAY:+($DISPLAY)} "$CURDIR$CVSTAG$SVNREV$GITBRANCH$HGBRANCH" "$C_$prompt_colors[soft_generic]$_C${TARGET:+[}$C_$prompt_colors[bold_generic]$_C${TARGET:+$TARGET}$C_$prompt_colors[soft_generic]$_C${TARGET:+] }$C_$prompt_colors[dies]$_C"%#"$C_$prompt_colors[cmd]$_C" "

}
