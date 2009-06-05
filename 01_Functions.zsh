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
			print -Pn "\ek"
			[ "$SUDO_USER" != "" ] && print -Pn "($USER) "
			print -Pn "${@:-%~}"
			print -Pn "\e\\"
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
	local my_git_branch

	if [ ! -z "$DO_NOT_CHECK_GIT_BRANCH" ]
	then
		return
	fi

	[ "$( ( git-ls-files ; git-ls-tree HEAD . ) 2>&- | head -n1)" = "" -a \( ! -d .git -o "$(git-rev-parse --git-dir 2>&-)" != ".git" \) -a "$(git-rev-parse --is-inside-git-dir 2>&-)" != "true" ] && return 

	GIT_DIR=$(git-rev-parse --git-dir)

	# Get current working GIT branch
	my_git_branch="$(git-branch 2>&- | grep -E '^\* ' | cut -c3-)"

	if [ "$my_git_branch" != "" ]
	then
		# If not on a working GIT branch, get the named current commit-ish inside parenthesis
		[ "$my_git_branch" = "(no branch)" ] &&\
			my_git_branch="($(git-name-rev HEAD 2>&- | awk '{ print $2 }' | sed 's,^tags/,,;s,^remotes/,,'))"

		# If neither on a named commit-ish, show commit-id
		if [ "$my_git_branch" = "(undefined)" ]
		then
			my_git_branch="($(git-rev-parse --verify HEAD 2>&-))"
		fi
	else
		# Initial commit
		if [ -L $GIT_DIR/HEAD -a ! -f $GIT_DIR/HEAD ]
		then
			my_git_branch="$(basename $GIT_DIR/$(stat --printf="%N\n" $GIT_DIR/HEAD | tr '`' "'" | cut -d\' -f4))"
		else
			my_git_branch="$(basename $GIT_DIR/$(cat $GIT_DIR/HEAD | sed 's/^\([0-9a-f]\{2\}\)\([0-9a-f]\{38\}\)$/objects\/\1\/\2/;s/^ref: //'))"
		fi
	fi

	# Rebase in progress ?
	if [ -d $GIT_DIR/rebase-merge -o -d $GIT_DIR/rebase-apply ]
	then
		local rebase current last
		local REBASE_DIR

		if [ -d $GIT_DIR/rebase-merge ]
		then
			REBASE_DIR=$GIT_DIR/rebase-merge
		else
			REBASE_DIR=$GIT_DIR/rebase-apply
		fi

		if [ -d $GIT_DIR/rebase-merge ]
		then
			current=$(< $REBASE_DIR/done wc -l)
			last=$(( $current + $(< $REBASE_DIR/git-rebase-todo grep -v "^#\|^[[:blank:]]*$" | wc -l) ))
			rebase=$rebase$rebase_in_progress": "
		else
			current=$(cat $REBASE_DIR/next)
			last=$(cat $REBASE_DIR/last)
		fi

		# Then the result
		rebase="[rebase $current/$last: "$(git-name-rev $(cat $REBASE_DIR/onto) | awk '{ print $2 }')".."$(basename $(cat $REBASE_DIR/head-name))"]"

		[ $current -gt 1 ] && my_git_branch=$rebase" "$my_git_branch || my_git_branch=$rebase
	fi

	if [ "$(git-status 2>&- | grep "new file" | head -n1)" != "" ] ; then
		# ADDED FILES
		my_git_branch=$my_git_branch" (+)"
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

	if [ "$(git-rev-parse --is-inside-git-dir)" = "true" ] ; then
		echo "$git_colors[managment_folder]"
		return
	fi

	if   [ "$(git-diff --cached 2>&- | grep '^diff ' | head -n1 )" != "" ] ; then 
		cached="yes"
	fi
	if [ "$(git-ls-files -m 2>&- | head -n1)" != "" ] ; then 
		not_up_to_date="yes"
	fi

	GIT_DIR=$(git-rev-parse --git-dir 2>/dev/null)

	if [ "$cached" != "" -a "$not_up_to_date" != "" ] ; then
		my_git_status="$git_colors[cached_and_not_up_to_date]"
	elif [ "$cached" != "" ] ; then
		my_git_status="$git_colors[cached]"
	elif [ "$not_up_to_date" != "" ] ; then
		my_git_status="$git_colors[not_up_to_date]"
	elif [ "$(git-cat-file -t HEAD 2>/dev/null)" != "commit" ] ; then
		my_git_status="$git_colors[init_in_progress]"
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
	# Get the generic color from cmdline, else from envvar...
	my_generic=${1:-$prompt_colors[generic]}
	# ...then stores it to envvar. :)
	prompt_colors[generic]=$my_generic

	# Get soft and bold values of generic color, whichever it is bold or not
	prompt_colors[bold_generic]="$(echo "$prompt_colors[generic]" | tr ';' '\n' | grep -v "^$color[bold]$" | tr '\n' ';' | sed 's/\;$//');$color[bold]"
	prompt_colors[soft_generic]="$(echo "$prompt_colors[generic]" | tr ';' '\n' | grep -v "^$color[bold]$" | tr '\n' ';' | sed 's/\;$//')"

	prompt_colors[path]="$prompt_colors[generic];$color[bold]"			# pwd - bold generic
	#prompt_colors[term]="$prompt_colors[generic]"							# tty - unused, see term title
	prompt_colors[user]="$prompt_colors[generic]"							# login - generic
	prompt_colors[host]="$prompt_colors[generic]"							# hostname - generic
	#prompt_colors[hist]="$color[none]"									# history number - unused
	prompt_colors[arob]="$color[bold];$prompt_colors[generic]"	# <login>@<hostname> - bold generic
	prompt_colors[dies]="$prompt_colors[generic]"							# the bottom-end of the prompt - generic
	prompt_colors[doubledot]="$color[none]"							# separates pwd from git-branch - none
	#prompt_colors[paren]="$color[cyan]"					# parenthesis (around tty) - unused, see term title
	prompt_colors[bar]="$prompt_colors[generic];$color[bold]"				# horizontal bar - bold generic
	prompt_colors[braces]="$prompt_colors[bar]"							# braces (around date) - bar color
	prompt_colors[error]="$color[bold];$color[yellow]"					# error code - bold yellow

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
	mail_colors[listes]="$prompt_colors[generic];$color[bold]"		# less important mail received

	agent_colors[empty]="$prompt_colors[soft_generic]"
	agent_colors[has_keys]="$color[bold];$color[yellow]"

	prompt_colors[up_to_date]="$prompt_colors[generic]"						# up-to-date
	prompt_colors[not_up_to_date]="$color[green];$color[bold]" 	# not up to date
	prompt_colors[to_be_commited]="$color[yellow];$color[bold]"	# changes in cache

	git_colors[managment_folder]="$color[red];$color[bold]"   # .git/... folder browsing
	git_colors[cached]="$prompt_colors[to_be_commited]"                     # git changes in cache
	git_colors[cached_and_not_up_to_date]="$prompt_colors[not_up_to_date];$color[bold]"
	git_colors[not_up_to_date]="$prompt_colors[not_up_to_date];$color[normal]"     # git changes in working tree
	git_colors[init_in_progress]="$color[black];$color[bold]"                        # initialization
	git_colors[up_to_date]="$prompt_colors[up_to_date]"                                     # git up-to-date
}

chpwd()
{
	if cmd_exists when && [ -e .when/.today ]
	then
		LATEST=`stat 2>&- --printf="%z\n" .when/.today | cut -d' ' -f1`
		TODAY=`date "+%Y-%m-%d"`

		if [ "$TODAY" != "$LATEST" ]
		then
			when w --calendar=~/.when/birthdays | tail -n+3 > ~/.when/.today
		fi

		if [ -s ~/.when/.today ]
		then
			preprint "événements" $color[bold] ; echo
			cat ~/.when/.today
		fi
	fi

	if cmd_exists todo
	then
		if [ $(todo | wc -l) -gt 0 ]
		then
			preprint "todo" $color[bold] ; echo
			todo
		fi
	fi
}

