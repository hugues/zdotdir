##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

##
## 	User-defined functions
##
#
# For preexec, precmd, chpwd and other built-in functions,
# go see the file Prompts.zsh
#


cmd_exists ()
{
	which $1 2>/dev/null >&2
}

term_title()
{

	# Jobs
	typeset -A command
	for word in ${=2} ; command[$#comand]=$word
	if [ "$command[0]" = "fg" ]
	then
		lastjob=$(ps ft `tty` | grep "[0-9]\+[[:blank:]]\+`tty | sed 's/\/dev\///'`[[:blank:]]\+T.\? \+.:..  \\\_ " | tail -n1 | cut -c32-)
		set $1 $lastjob
	fi

	[[ -t 1 ]] &&
		case $TERM in
		  sun-cmd)
			print -Pn "\e]l%n@%m %~$@\e\\"				# Never tested..
			;;
		  *term*|rxvt*|putty)
			print -Pn "\e]0;%n@%m (%l) %~$@\a"			# Sets term title
			;;
		  screen*)
			# hardstatus
			print -Pn "\e]2;[SCREEN #n] ?u(u) ?%n@%m (%l) %~$@\a" # Sets hardstatus line (term title)
			# caption
			[ $# -gt 0 ] && shift # discards the first arg, which is the separator, if any
			print -Pn "\ek${@:-%~}\e\\"
			;;
		  *)
			;;
		esac
}

preprint()
{
	local my_color i

	my_color=${2-"$color[black];$color[bold]"}

	hbar=
	for i in {1..$(($COLUMNS - ${#1} - 5))}
	do
		hbar=$hbar-
	done
	print -Pn "${C_}$my_color${_C}${hbar}[ $1 ]-\r${C_}0${_C}"
}

get_git_branch ()
{
	local my_git_branch REBASE

	if [ ! -z "$DO_NOT_CHECK_GIT_BRANCH" ]
	then return
	fi

	[ "$( ( git-ls-tree HEAD . 2>&- ; git-ls-files . 2>&- ) | head -n 1)" == "" ] && return 

	# Rebase in progress ?
	REBASE="";
	[ -e $(git-rev-parse --git-dir)/../.dotest/rebasing ] && REBASE="rebase:"
	[ -d $(git-rev-parse --git-dir)/rebase-merge ] && REBASE="rebase:"

	# Get current working GIT branch
	my_git_branch="$REBASE$(git-branch 2>&- | grep -E '^\* ' | cut -c3-)"

	if [ "$my_git_branch" != "$REBASE" ]
	then
		# If not on a working GIT branch, get the named current commit-ish inside parenthesis
		[ "$my_git_branch" == "$REBASE(no branch)" ] &&\
			my_git_branch="($REBASE$(git-name-rev HEAD 2>&- | awk '{ print $2 }' | sed 's,^tags/,,;s,^remotes/,,'))"

		# If neither on a named commit-ish, show commit-id
		if [ "$my_git_branch" == "(${REBASE}undefined)" ]
		then
			my_git_branch="($REBASE$(git-rev-parse HEAD 2>&-))"
		fi
	fi

	echo $my_git_branch
}

# We *must* have previously checked that
# we obtained a correct GIT branch with
# a call to `get_git_branch`
get_git_status ()
{
	local my_git_status cached not_up_to_date managment_folder

	if [ ! -z "$DO_NOT_CHECK_GIT_STATUS" ]
	then return
	fi

	if [ "$(git-rev-parse --is-inside-git-dir)" == "true" ] ; then
		echo "$git_colors[managment_folder]"
		return
	fi

	if   [ "$(git-diff --cached 2>&- | grep '^diff ' | head -n1 )" != "" ] ; then 
		cached="yes"
	fi
	if [ "$(git-ls-files -m 2>&-)" != "" ] ; then 
		not_up_to_date="yes"
	fi

	if [ "$cached" != "" -a "$not_up_to_date" != "" ] ; then
		my_git_status="$git_colors[cached_and_not_up_to_date]"
	elif [ "$cached" != "" ] ; then
		my_git_status="$git_colors[cached]"
	elif [ "$not_up_to_date" != "" ] ; then
		my_git_status="$git_colors[not_up_to_date]"
	else
		my_git_status="$git_colors[up_to_date]"
	fi

	echo $my_git_status
}

normal_user ()
{
	if [ -e /etc/login.defs ]
	then
		eval `grep -v '^[$#]' /etc/login.defs | grep "^UID_" | tr -d '[:blank:]' | sed 's/^[A-Z_]\+/&=/'`
		[ \( $UID -ge $UID_MIN \) ]
	else
		[ "`whoami`" != "root" ]
	fi
}

privileged_user ()
{
	! normal_user
}


# This func is intended to give a quick way to set the colors for the 
# prompt inside a running zsh-session
#
set_prompt_colors ()
{
	local my_generic
	my_generic=${1:-$prompt_colors[generic]}
	prompt_colors[bold_generic]="$my_generic;$color[bold]" ## Always bold generic color
	prompt_colors[soft_generic]=$(echo "$my_generic" | tr ';' '\n' | grep -v "^1$" | tr '\n' ';' | sed 's/\;$//') ## Always soft generic color

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

	date_colors[normal]=$prompt_colors[soft_generic]
	date_colors[exec]=$prompt_colors[bold_generic]
	prompt_colors[date]=$date_colors[normal]							# full date

	prompt_colors[cmd]="$color[none]"									# command prompt
	prompt_colors[exec]="$color[none]"									# command output

	battery_colors[full]="$prompt_colors[soft_generic]"
	battery_colors[charging]="$prompt_colors[bold_generic]"
	battery_colors[uncharging]="$prompt_colors[soft_generic]"
	battery_colors[critical]="$color[bg-red];$prompt_colors[bold_generic]"

	mail_colors[unread]="$color[yellow];$color[bold]"		# mail received
	mail_colors[listes]="$my_generic;$color[bold]"		# less important mail received

	agent_colors[empty]="$prompt_colors[soft_generic]"
	agent_colors[has_keys]="$color[bold];$color[yellow]"

	prompt_colors[up_to_date]="$my_generic"						# up-to-date
	prompt_colors[not_up_to_date]="$color[green];$color[bold]" 	# not up to date
	prompt_colors[to_be_commited]="$color[yellow];$color[bold]"	# changes in cache

	git_colors[managment_folder]="$color[red];$color[bold]"   # .git/... folder browsing
	git_colors[cached]="$prompt_colors[to_be_commited]"                     # git changes in cache
	git_colors[cached_and_not_up_to_date]="$prompt_colors[not_up_to_date];$color[bold]"
	git_colors[not_up_to_date]="$prompt_colors[not_up_to_date];$color[normal]"     # git changes in working tree
	git_colors[up_to_date]="$prompt_colors[up_to_date]"                                     # git up-to-date
}


