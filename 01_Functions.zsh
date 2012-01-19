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
	\which -p $1 >/dev/null 2>&1
}

git () {
	GIT=$(\which -p git)
	case $1 in
		init|clone|config)
			;;
		*)
			if [ "$( ( $GIT ls-files ; $GIT ls-tree HEAD . ) 2>&- | head -n1)" = ""\
				-a \( ! -d .git -o "$($GIT rev-parse --git-dir 2>&-)" != ".git" \)\
				-a "$($GIT rev-parse --is-inside-git-dir 2>&-)" != "true" ]
			then
				echo >&2 "git $1: the current folder is not managed by git"
				return
			fi
			;;
	esac

	$(\which -p git) $@
}

term_title()
{
	# Jobs
	typeset -A command
	for word in ${=@} ; command[$#command]=$word
	if [ "$command[0]" = "fg" ]
	then
		lastjob=$(ps t `tty` | grep "[0-9]\+[[:blank:]]\+`tty | sed 's/\/dev\///'`[[:blank:]]\+T.\? \+.:..  \\\_ " | tail -n1 | cut -c32-)
		set "$lastjob"
	fi
	if [ "$command[0]" = "screen" -o "$command[0]" = "tmux" ]
	then
		# discards screen args
		set $command[0]
	fi

	[ ! "$@" = "" ] && set " |" $@

	if [[ -t 1 ]]
	then
		case $TERM in
		  sun-cmd)
			print -Pn "\e]l%n@%m %~$@\e\\"				# Never tested..
			;;
		  *term*|rxvt*|putty)
			print -Pn "\e]0;%n@%m (%l) %~$@\a"			# Sets term title
			;;
		  screen*)
			local _sep=""
			[ $# -gt 0 ] && _sep=$1 && shift # gets and discards the separator, if any.
			#if [ ! -z "$TMUX" ]
			#then
				# Tmux
				#print -Pn "\e]0;%n@%m (%l) %~${_sep:+$_sep #[fg=yellow,bold]}$@\a"			# Sets term title
				print -Pn "\e]0;#[fg=red]%n#[fg=default,bold]@#[fg=red]%m#[default] (#[fg=cyan]%l#[fg=default]) #[fg=red]%~${_sep:+#[default,fg=default]$_sep #[fg=yellow,bold]$@}#[default,fg=default]\a"
			#else
				# Classic screen
				# hardstatus
				#print -Pn "\e]2;{+b W}SCREEN #n {-b W}| {R}?u(u) ?{W}{r}%n@%m{W} ({c}%l{W}) {R}%~{W}${_sep:+$_sep \{+b Y\}}$@{-b W}\a" # Sets hardstatus line (term title)
			#	print -Pn "\e]2;{R}?u(u) ?{W}{r}%n{R}@{r}%m{-b W} ({+b c}%l{-b W}) {R}%~{W}${_sep:+$_sep \{+b Y\}}$@{-b W}\a" # Sets hardstatus line (term title)
				# caption
			#	print -Pn "\ek"
			#	[ "$SUDO_USER" != "" ] && print -Pn "($USER) "
			#	print -Pn "${@:-%~}"
			#	print -Pn "\e\\"
			#fi
			;;
		  *)
			;;
		esac
	fi
}

preprint()
{
	local my_color i
	my_color=${2-"$prompt_colors[generic]"}

	hbar=$T_
	for i in {1..$((74 - ${#1} - 5))}
	do
		hbar=${hbar}$_tq_
	done
	hbar=${hbar}$_T

	if [ "$1" != "" ]
	then
		print -Pn "${C_}$my_color;1${_C}${hbar}$T_$_tj_$_T${C_}0;$my_color${_C} $1 ${C_}0;$my_color;1${_C}$T_$_tm_$_tq_$_T\r${C_}0${_C}"
	else
		print -Pn "${C_}$my_color;1${_C}${hbar}$T_$_tq_$_tq_$_tq_$_tq_$_tq_$_T${C_}0${_C}"
	fi
}

get_gcl_branch ()
{
	case $1 in
		git)
			get_git_branch
			;;
		hg)
			get_hg_branch
			;;
		*)
			;;
	esac
}

get_hg_branch ()
{
	HGROOT=$(hg root 2>/dev/null)
	if [ ! -z "$HGROOT" ]
	then
		hg branch
	fi
}

get_git_branch ()
{
	local my_git_branch checkouted_branch="yes"

	if [ -f ".repo/manifests.git/config" ]
	then
		my_git_branch=$(grep merge .repo/manifests.git/config | awk '{print $3}')
		if [ $my_git_branch != "" ]
		then
			echo "[$my_git_branch]"
			return
		fi
	fi

	# Get git branch only from git managed folders (not ignored subfolders..)
	[ "$( ( git ls-files ; git ls-tree HEAD . ) 2>&- | head -n1)" = "" -a \( ! -d .git -o "$(git rev-parse --git-dir 2>&-)" != ".git" \) -a "$(git rev-parse --is-inside-git-dir 2>&-)" != "true" ] && return

	GIT_DIR=$(git rev-parse --git-dir)

	# Get current working GIT branch
	my_git_branch="$(git branch 2>&- | grep -E '^\* ' | cut -c3-)"

	if [ "$my_git_branch" != "" ]
	then
		# If not on a working GIT branch, get the named current commit-ish inside parenthesis
		[ "$my_git_branch" = "(no branch)" ] &&\
			checkouted_branch="" && \
			my_git_branch="$(git name-rev --name-only HEAD 2>&- | sed 's,^tags/,,;s,^remotes/,,;s,\^0$,,')"

		# If neither on a named commit-ish, show commit-id
		if [ "$my_git_branch" = "undefined" ]
		then
			my_git_branch="$(git rev-parse --verify HEAD 2>&-)"
		fi
	else
		# Initial commit
		if [ -L $GIT_DIR/HEAD -a ! -f $GIT_DIR/HEAD ]
		then
			my_git_branch="$(basename $GIT_DIR/$(LC_ALL=C stat --printf="%N\n" $GIT_DIR/HEAD | tr '`' "'" | cut -d\' -f4))"
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

		if [ "$REBASE_DIR" = "$GIT_DIR/rebase-merge" ]
		then
			current=$(< $REBASE_DIR/done wc -l)
			last=$(( $current + $(< $REBASE_DIR/git-rebase-todo grep -v "^#\|^[[:blank:]]*$" | wc -l) ))
			rebase=$rebase$rebase_in_progress": "
		else
			current=$(cat $REBASE_DIR/next)
			last=$(cat $REBASE_DIR/last)
		fi

		# Then the result
		my_git_branch="[rebase $current/$last: "$(git name-rev --name-only "$(cat $REBASE_DIR/onto 2>/dev/null)" 2>/dev/null)".."$my_git_branch"]"
		[ -r $REBASE_DIR/head-name ] && my_git_branch=$my_git_branch" "$(< $REBASE_DIR/head-name sed 's/^refs\///;s/^heads\///')
	else
		# No rebase in progress, put '(' ')' if needed
		[ ! "$checkouted_branch" ] && my_git_branch="($my_git_branch)"
	fi

	if [ "$(git status 2>&- | grep "new file" | head -n1)" != "" ] ; then
		# ADDED FILES
		my_git_branch=$my_git_branch
	fi

	echo $my_git_branch
}

get_guilt_series ()
{
	# Guilt
	#
	guilt=""

	if ( cmd_exists guilt && guilt status >/dev/null 2>&- )
	then
		applied=$(guilt applied 2>/dev/null | wc -l)
		unapplied=$(guilt unapplied 2>/dev/null | wc -l)
		if [ $(($applied + $unapplied)) -gt 0 ]
		then
			guilt=" "$C_$guilt_colors[applied]$_C
			while [ $applied -gt 0 ]
			do
				guilt=$guilt"·"
				applied=$(($applied - 1))
			done
			guilt=$guilt$C_$guilt_colors[unapplied]$_C
			while [ $unapplied -gt 0 ]
			do
				guilt=$guilt"·"
				unapplied=$(($unapplied - 1))
			done
			guilt=$guilt$C_$colors[none]$_C
		fi
	fi

	echo $guilt
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

	if [ -f ".repo/manifests.git/config" ]
	then
		echo "$git_colors[up_to_date]";
		return
	fi

	if [ "$(git rev-parse --is-inside-git-dir)" = "true" -o "$(git config --get core.bare)" = "true" ] ; then
		echo "$git_colors[managment_folder]"
		return
	fi

	if   [ "$(git diff --cached 2>&- | grep '^diff ' | head -n1 )" != "" ] ; then 
		cached="yes"
	fi
	if [ "$(git ls-files -m 2>&- | head -n1)" != "" ] ; then 
		not_up_to_date="yes"
	fi

	GIT_DIR=$(git rev-parse --git-dir 2>/dev/null)

	if [ "$cached" != "" -a "$not_up_to_date" != "" ] ; then
		my_git_status="$git_colors[cached_and_not_up_to_date]"
	elif [ "$cached" != "" ] ; then
		my_git_status="$git_colors[cached]"
	elif [ "$not_up_to_date" != "" ] ; then
		my_git_status="$git_colors[not_up_to_date]"
	elif [ "$(git cat-file -t HEAD 2>/dev/null)" != "commit" ] ; then
		if [ ! -z "$(git ls-files)" ] ; then
			my_git_status="$git_colors[cached]"
		else
			my_git_status="$git_colors[init_in_progress]"
		fi
	else
		if [ -f $GIT_DIR/MERGE_HEAD ]
		then
			my_git_status="$git_colors[cached]"
		else
			my_git_status="$git_colors[up_to_date]"
		fi
	fi

	echo $my_git_status
}

zsh_status ()
{
	if [ $ZDOTDIR != "" ]
	then
		cd $ZDOTDIR >/dev/null
		_status="$(git describe --always)"
		if [ "$( (git diff --cached ; git diff) | head -n1)" != "" ]
		then
			_status=$_status"-$( (git diff --cached ; git diff) | md5sum | sed 's/^\(.......\).*$/-D1rTY-\1/')"
		fi
		echo $_status
	else
		echo
	fi
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
	prompt_colors[display]="$prompt_colors[generic]"							# hostname - generic
	#prompt_colors[hist]="$color[none]"									# history number - unused
	prompt_colors[arob]="$color[bold];$prompt_colors[generic]"	# <login>@<hostname> - bold generic
	prompt_colors[dies]="$prompt_colors[generic]"							# the bottom-end of the prompt - generic
	prompt_colors[doubledot]="$color[none]"							# separates pwd from git-branch - none
	#prompt_colors[paren]="$color[cyan]"					# parenthesis (around tty) - unused, see term title
	prompt_colors[bar]="$prompt_colors[generic];$color[bold]"				# horizontal bar - bold generic
	prompt_colors[braces]="$prompt_colors[bar]"							# braces (around date) - bar color
	prompt_colors[error]="$color[bold];$color[yellow]"					# error code - bold yellow

	prompt_colors[warning]="$color[bold];$color[yellow]"

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
	agent_colors[remote_empty]="$color[bold];$color[black]"
	agent_colors[has_keys]="$color[bold];$color[yellow]"
	agent_colors[has_remote_keys]="$prompt_colors[bold_generic]"

	prompt_colors[up_to_date]="$prompt_colors[generic]"						# up-to-date
	prompt_colors[not_up_to_date]="$color[green];$color[bold]" 	# not up to date
	prompt_colors[to_be_commited]="$color[yellow];$color[bold]"	# changes in cache

	git_colors[managment_folder]="$color[red];$color[bold]"   # .git/... folder browsing
	git_colors[cached]="$prompt_colors[to_be_commited]"                     # git changes in cache
	git_colors[cached_and_not_up_to_date]="$prompt_colors[not_up_to_date];$color[bold]"
	git_colors[not_up_to_date]="$prompt_colors[not_up_to_date];$color[normal]"     # git changes in working tree
	git_colors[init_in_progress]="$color[black];$color[bold]"                        # initialization
	git_colors[up_to_date]="$prompt_colors[up_to_date];$color[normal]"                                     # git up-to-date

	guilt_colors[applied]=$git_colors[cached]
	guilt_colors[unapplied]=$color[black]
}

birthdays()
{
	WHEN_FILE=~/.when/birthdays
	TODAY_FILE=~/.when/.today

	if cmd_exists when && [ -e $WHEN_FILE ]
	then
		when --calendar=$WHEN_FILE $@ | tail -n+3 | \
		sed 's/^\(aujourd.hui *[0-9][0-9][0-9][0-9] [A-Z][a-z]\+ [0-9][0-9][    ]*\)\(.*\)/'$c_'1;33'$_c'\1\2'$c_'0'$_c'/;
                  s/^\(demain *[0-9][0-9][0-9][0-9] [A-Z][a-z]\+ [0-9][0-9][    ]*\)\(.*\)/'$c_'1'$_c'\1\2'$c_'0'$_c'/;
                    s/^\(hier *[0-9][0-9][0-9][0-9] [A-Z][a-z]\+ [0-9][0-9][        ]*\)\(.*\)/'$c_'3'$_c'\1\2'$c_'0'$_c'/' \
		> $TODAY_FILE

		if [ -s $TODAY_FILE ]
		then
			preprint "À ne pas manquer" $color[red] ; echo
			cat $TODAY_FILE
			preprint "" $color[red] ; echo
			echo
		fi | sed 's/^/   /'
	fi
}

todo()
{
	if cmd_exists todo
	then
		TODO=${=$(whereis -b todo | cut -d: -f2)}
		if [ $($TODO $@ | wc -l) -gt 0 ]
		then
			preprint "À faire" $color[yellow] && echo
			$TODO $@ --force-colour
			preprint "" $color[yellow] && echo
			echo
		fi | sed 's/^/   /'
	fi
}

chpwd()
{

	todo

	if ( cmd_exists git && test -d .git )
	then
		# Shows tracked branches and modified files
		git checkout HEAD 2>&1 | sed 's/^/   /'
	fi
}

