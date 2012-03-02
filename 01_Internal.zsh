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


__cmd_exists ()
{
	which -p $1 >/dev/null 2>&1
}

__term_title()
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

__preprint()
{
	local my_color i
	my_color=${2-"$_prompt_colors[generic]"}

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

__get_gcl_branch ()
{
	case $1 in
		git)
			__get_git_branch
			;;
		hg)
			__get_hg_branch
			;;
		*)
			;;
	esac
}

__get_hg_branch ()
{
	HGROOT=$(hg root 2>/dev/null)
	if [ ! -z "$HGROOT" ]
	then
		hg branch
	fi
}

__cleanup_git_branch_name() { sed 's,^tags/,,;s,^remotes/,,;s,\^0$,,' }

__get_git_branch ()
{
	local my_git_branch checkouted_branch="yes"

	if [ -f ".repo/manifests.git/config" ]
	then
		my_git_branch=$(grep merge .repo/manifests.git/config | awk '{print $3}')
		if [ $my_git_branch != "" ]
		then
			echo " [$my_git_branch]"
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
			my_git_branch="$(git name-rev --name-only HEAD 2>&- | __cleanup_git_branch_name)"

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
		my_git_branch="[$current/$last: "$(git name-rev --name-only "$(cat $REBASE_DIR/onto 2>/dev/null)" 2>/dev/null | __cleanup_git_branch_name)".."$(echo $my_git_branch)"]"
		[ -r $REBASE_DIR/head-name ] && my_git_branch=$my_git_branch" "$(< $REBASE_DIR/head-name sed 's/^refs\///;s/^heads\///')
	else
		# No rebase in progress, put '(' ')' if needed
		[ ! "$checkouted_branch" ] && my_git_branch="($my_git_branch)"
	fi

	if [ "$(git status 2>&- | grep "new file" | head -n1)" != "" ] ; then
		# ADDED FILES
		my_git_branch=$my_git_branch
	fi

	echo " "$my_git_branch
}

__get_guilt_series ()
{
	# Guilt
	#
	guilt=""

	if ( __cmd_exists guilt && guilt status >/dev/null 2>&- )
	then
		applied=$(guilt applied 2>/dev/null | wc -l)
		unapplied=$(guilt unapplied 2>/dev/null | wc -l)
		if [ $(($applied + $unapplied)) -gt 0 ]
		then
			guilt=" "$c_$_guilt_colors[applied]$_C
			while [ $applied -gt 0 ]
			do
				guilt=$guilt"·"
				applied=$(($applied - 1))
			done
			guilt=$guilt$c_$_guilt_colors[unapplied]$_C
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
# a call to `__get_git_branch`
__get_git_status ()
{
	local my_git_status cached changed managment_folder

	if [ ! -z "$DO_NOT_CHECK_GIT_STATUS" ]
	then
		return
	fi

	my_git_status=$_gcl_colors[uptodate];

	if [ -f ".repo/manifests.git/config" ]
	then
		echo $my_git_status
		return
	fi

	if [ "$(git rev-parse --is-inside-git-dir)" = "true" -o "$(git config --get core.bare)" = "true" ] ; then
		echo "$_gcl_colors[gitdir]"
		return
	fi

	if   [ "$(git diff --cached 2>&- | grep '^diff ' | head -n1 )" != "" ] ; then 
		cached="yes"
	fi
	if [ "$(git ls-files -m 2>&- | head -n1)" != "" ] ; then 
		changed="yes"
	fi

	GIT_DIR=$(git rev-parse --git-dir 2>/dev/null)

	if [ "$cached" != "" -a "$changed" != "" ]
	then
		my_git_status="$_gcl_colors[mixed]"
	elif [ "$cached" != "" ]
	then
		my_git_status="$_gcl_colors[cached]"
	elif [ "$changed" != "" ]
	then
		my_git_status="$_gcl_colors[changed]"
	elif [ "$(git cat-file -t HEAD 2>/dev/null)" != "commit" ]
	then
		if [ ! -z "$(git ls-files)" ] ; then
			my_git_status="$_gcl_colors[cached]"
		else
			my_git_status="$_gcl_colors[init]"
		fi
	fi

	if [ $(git ls-files --unmerged | wc -l) -gt 0 ]
	then
		my_git_status="${_gcl_colors[merging]:+$_gcl_colors[merging];}$my_git_status"
	fi

	echo $my_git_status
}

__zsh_status ()
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

__normal_user ()
{
	if [ -e /etc/login.defs ]
	then
		eval `grep -v '^[$#]' /etc/login.defs | grep "^UID_" | tr -d '[:blank:]' | sed 's/^[A-Z_]\+/&=/'`
		[ \( $UID -ge $UID_MIN \) ]
	else
		[ "`whoami`" != "root" ]
	fi
}

__privileged_user ()
{
	! __normal_user
}


