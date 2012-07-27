##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

typeset -A _prompt_colors _gcl_colors _mail_colors _correct_colors _battery_colors _date_colors _agent_colors _guilt_colors

_correct_colors[error]="$color[red];$color[bold]"
_correct_colors[suggest]="$color[blue];$color[bold]"

# This func is intended to give a quick way to reset the colors
# from a running zsh-session
#
sc ()
{
    C=""
    for c in $( echo $@ | tr ';' ' ' )
    do
        c=${$(echo "$c" | sed 's/^[0-9]$/0\0/;/^[0-9]\{2\}$/!d'):-$color[$c]}
        C+=${C:+;}${c:-00}
    done
    __set_prompt_colors $C
}

__set_prompt_colors ()
{
	# Forces HBAR re-generation with new colors..
	_COLUMNS_OLD=0

	local my_generic
	# Get the generic color from cmdline, else from envvar...
	my_generic=${1:-$_prompt_colors[generic]}
	# ...then stores it to envvar. :)
	_prompt_colors[generic]=$my_generic

	# Get soft and bold values of generic color, whichever it is bold or not
	_prompt_colors[bold_generic]="$(echo "$_prompt_colors[generic]" | tr ';' '\n' | grep -v "^$color[bold]$" | tr '\n' ';' | sed 's/\;$//');$color[bold]"
	_prompt_colors[soft_generic]="$(echo "$_prompt_colors[generic]" | tr ';' '\n' | grep -v "^$color[bold]$" | tr '\n' ';' | sed 's/\;$//')"

	_prompt_colors[path]="$_prompt_colors[generic];$color[bold]"			# pwd - bold generic
	#_prompt_colors[term]="$_prompt_colors[generic]"							# tty - unused, see term title
	_prompt_colors[user]="$_prompt_colors[generic]"							# login - generic
	_prompt_colors[host]="$_prompt_colors[generic]"							# hostname - generic
	_prompt_colors[display]="$_prompt_colors[generic]"							# hostname - generic
	#_prompt_colors[hist]="$color[none]"									# history number - unused
	_prompt_colors[arob]="$color[bold];$_prompt_colors[generic]"	# <login>@<hostname> - bold generic
	_prompt_colors[dies]="$_prompt_colors[generic]"							# the bottom-end of the prompt - generic
	_prompt_colors[doubledot]="$color[none]"							# separates pwd from git-branch - none
	#_prompt_colors[paren]="$color[cyan]"					# parenthesis (around tty) - unused, see term title
	_prompt_colors[bar]="$_prompt_colors[generic];$color[bold]"				# horizontal bar - bold generic
	_prompt_colors[braces]="$_prompt_colors[bar]"							# braces (around date) - bar color
	_prompt_colors[error]="$color[bold];$color[yellow]"					# error code - bold yellow

	_prompt_colors[warning]="$color[bold];$color[yellow]"

	_date_colors[normal]=$_prompt_colors[soft_generic]
	_date_colors[exec]=$_prompt_colors[bold_generic]

	_prompt_colors[cmd]="$color[none]"									# command prompt
	_prompt_colors[exec]="$color[none]"									# command output

	_battery_colors[full]="$_prompt_colors[soft_generic]"
	_battery_colors[charging]="$_prompt_colors[bold_generic]"
	_battery_colors[uncharging]="$_prompt_colors[soft_generic]"
	_battery_colors[critical]="$color[bg-red];$_prompt_colors[bold_generic]"

	_mail_colors[unread]="$color[yellow];$color[bold]"		# mail received
	_mail_colors[listes]="$_prompt_colors[generic];$color[bold]"		# less important mail received

	_agent_colors[empty]="$_prompt_colors[soft_generic]"
	_agent_colors[remote_empty]="$color[bold];$color[black]"
	_agent_colors[has_keys]="$_prompt_colors[bold_generic]"
	_agent_colors[has_remote_keys]="$_prompt_colors[bold_generic]"
	_agent_colors[id_dsa]="$color[bold];$color[yellow]"

	_gcl_colors[init]="$color[black];$color[bold]"
	_gcl_colors[gitdir]="$color[red];$color[bold]"
	_gcl_colors[uptodate]="$_prompt_colors[generic]"
	_gcl_colors[cached]="$color[yellow];$color[bold]"
	_gcl_colors[mixed]="$color[green];$color[bold]"
	_gcl_colors[changed]="$color[green]"
	_gcl_colors[merging]="$color[bg-black]"
	_gcl_colors[ffwd]="$color[standout]"

	_guilt_colors[applied]=$_gcl_colors[cached]
	_guilt_colors[unapplied]=$color[black]
}

