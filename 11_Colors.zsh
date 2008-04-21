##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 
typeset -A prompt_colors git_colors mail_colors correct_colors

# I hate kik00l0l colorized prompts, so I'm using a way to
# give a dominant color for each part of the prompt, each of
# these remain still configurable one by one.
# Take a look to set_prompt_colors for these colorizations.
#
# To set the dominant color I'm using this :
#
#  - PS1_ROOT when we are root
#  - PS1_USER for normal usage
#  - PS1_USER_SSH when we are connected through SSH
#
# I'm storing the resulting dominant color in $prompt_colors[generic]

PS1_ROOT=${PS1_ROOT:-$color[red]}
PS1_USER=${PS1_USER:-$color[blue]}
PS1_USER_SSH=${PS1_USER_SSH:-$color[magenta]}
prompt_colors[generic]=`print -Pn "%(! $PS1_ROOT $PS1_USER)"`

normal_user && if ( [ "$SSH_TTY" != "" ] )
then
	# This allows us to easily distinguish shells
	# which really are on the local machine or not.
	# That's so good, use it ! :-)
	prompt_colors[generic]=${PS1_USER_SSH:-$prompt_colors[generic]}
fi

# 
# This func is intended to give a quick way to set the colors for the 
# prompt inside a running zsh-session
#
set_prompt_colors ()
{
	local my_generic
	my_generic=${1:-$prompt_colors[generic]}

	prompt_colors[path]="$my_generic;$color[bold]"			# pwd
	#prompt_colors[term]="$my_generic"							# tty
	prompt_colors[user]="$my_generic"							# login
	prompt_colors[host]="$my_generic"							# hostname
	#prompt_colors[hist]="$color[none]"									# history number
	prompt_colors[arob]="$color[bold];$my_generic"	# <login>@<hostname>
	prompt_colors[dies]="$my_generic"							# the bottom-end of the prompt
	prompt_colors[doubledot]="$color[none]"							# separates pwd from git-branch
	#prompt_colors[paren]="$color[cyan]"					# parenthesis (around tty)
	prompt_colors[bar]="$my_generic;$color[bold]"				# horizontal bar
	prompt_colors[braces]="$prompt_colors[bar]"							# braces (around date)
	prompt_colors[error]="$color[bold];$color[yellow]"					# error code
	prompt_colors[date]="$my_generic"							# full date

	prompt_colors[cmd]="$color[none]"									# command prompt
	prompt_colors[exec]="$color[none]"									# command output

	mail_colors[unread]="$color[yellow];$color[bold]"		# mail received
	mail_colors[listes]="$my_generic;$color[bold]"		# less important mail received

	prompt_colors[up_to_date]="$my_generic"						# up-to-date
	prompt_colors[not_up_to_date]="$color[green];$color[bold]" 	# not up to date
	prompt_colors[to_be_commited]="$color[yellow];$color[bold]"	# changes in cache

	git_colors[managment_folder]="$color[red];$color[bold]"   # .git/... folder browsing
	git_colors[cached]="$prompt_colors[to_be_commited]"                     # git changes in cache
	git_colors[not_up_to_date]="$prompt_colors[not_up_to_date]"     # git changes in working tree
	git_colors[up_to_date]="$prompt_colors[up_to_date]"                                     # git up-to-date
}

set_prompt_colors

correct_colors[error]="$color[red];$color[bold]"
correct_colors[suggest]="$color[blue];$color[bold]"

