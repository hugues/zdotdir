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

_cuu1_=$(tput cuu1)
_cud1_=$(tput cud1)
_cub1_=$(tput cub 1)
_cuf1_=$(tput cuf 1)

__cmd_exists ()
{
	which -p $1 >/dev/null 2>&1
}

__term_title()
{
    __debug -n "	Term title..."
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
				print -Pn "\e]0;#[fg=red]%n#[fg=default,bold]@#[fg=red]%m#[default] (#[fg=cyan]%l#[fg=default]) #[fg=red]%~${_sep:+#[default,fg=default]$_sep #[fg=yellow,bold]$@}\a"
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
    __debug
}

__preprint()
{
	local my_color i newline
    if [ "$1" = "-n" ]
    then
        newline='n'
        shift
    fi

	my_color=${2-"$_prompt_colors[generic]"}

	hbar=$T_
	for i in {1..$((74 - ${#1} - 5))}
	do
		hbar=${hbar}$_tq_
	done
	hbar=${hbar}$_T

	if [ "$1" != "" ]
	then
		print -P$newline "${C_}$my_color;1${_C}${hbar}$T_$_tj_$_T${C_}0;$my_color${_C} $1 ${C_}0;$my_color;1${_C}$T_$_tm_$_tq_$_T\r${C_}0${_C}"
	else
		print -P$newline "${C_}$my_color;1${_C}${hbar}$T_$_tq_$_tq_$_tq_$_tq_$_tq_$_T${C_}0${_C}"
	fi
}

__get_gcl_branch ()
{
	case $1 in
		git)
            __debug -n "	GIT status..."
			__get_git_branch
            __debug
			;;
		hg)
            __debug -n "	HG status..."
			__get_hg_branch
            __debug
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

	__debug
	__debug -n "		repo..."
	if [ -f ".repo/manifests.git/config" ]
	then
		my_git_branch=$(grep merge .repo/manifests.git/config | awk '{print $3}')
		if [ $my_git_branch != "" ]
		then
			echo " [$my_git_branch]"
			return
		fi
	fi
	__debug

	__debug -n "		branch..."
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
	__debug

    my_git_branch="→"$my_git_branch"←"

	__debug -n "		rebase..."
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

		my_git_branch="[$current/$last: "$(git name-rev --name-only "$(cat $REBASE_DIR/onto 2>/dev/null)" 2>/dev/null | __cleanup_git_branch_name)".."$(echo $my_git_branch)"]"
		[ -r $REBASE_DIR/head-name ] && my_git_branch=$my_git_branch" "$(< $REBASE_DIR/head-name sed 's/^refs\///;s/^heads\///')
	else
		# No rebase in progress, put '(' ')' if needed
		[ ! "$checkouted_branch" ] && my_git_branch="($my_git_branch)"
	fi
	__debug

	__debug -n "		stashes..."
    # Show number of stashed commits by appending '+' signs for each
    if [ "$(git rev-parse --is-inside-git-dir)" != "true" -a "$(git config --get core.bare)" != "true" ]
    then
        local _stashed=$(git stash list | wc -l )
        if [ "$_stashed" -gt 0 ]
        then
            my_git_branch+=$C_$_prompt_colors[soft_generic]$_C
            while [ $_stashed -gt 1 ]
            do
                my_git_branch+="·"
                _stashed=$(( $_stashed - 1 ))
            done
            my_git_branch+="$C_$color[blink];$_prompt_colors[soft_generic]$_C·"
        fi
    fi
	__debug

	__debug -n "		behind/ahead..."
    # Show number of stashed commits by appending '+' signs for each
    if [ "$(git rev-parse --is-inside-git-dir)" != "true" -a "$(git config --get core.bare)" != "true" ]
    then
        local _ahead=0 ;
        local _behind=0 ;
        eval $(git status . | sed -n '
        /^#$/ { q }
        s/^# and have \([0-9]\+\) and \([0-9]\+\) different.*/_ahead=\1;\n_behind=\2;\n/p ;
        s/^# Your branch is \(behind\|ahead\) .* \([0-9]\+\) commit.*/_\1=\2;\n/p ;
        ')

        [ $(($_ahead + $_behind)) -gt 0 ] && my_git_branch+=" "
        if [ $_ahead -gt 0 ]
        then
            my_git_branch+=$C_$_gcl_colors[cached]$_C"↑"
            [ $_ahead -gt 1 ] && my_git_branch+="₊$(echo $_ahead | \
            sed 's/0/₀/g;s/1/₁/g;s/2/₂/g;s/3/₃/g;s/4/₄/g;s/5/₅/g;s/6/₆/g;s/7/₇/g;s/8/₈/g;s/9/₉/g')"
        fi
        if [ $_behind -gt 0 ]
        then
            my_git_branch+=$C_$_prompt_colors[bold_generic]$_C"↓"
            [ $_behind -gt 1 ] && my_git_branch+="₊$(echo $_behind | \
            sed 's/0/₀/g;s/1/₁/g;s/2/₂/g;s/3/₃/g;s/4/₄/g;s/5/₅/g;s/6/₆/g;s/7/₇/g;s/8/₈/g;s/9/₉/g')"
        fi
    fi

	echo $my_git_branch
}

__get_guilt_series ()
{
	# Guilt
	#
	guilt=""

	__debug -n "       Guilt"

	if ( __cmd_exists guilt && test -d $GIT_DIR/patches && guilt status >/dev/null 2>&- )
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
	__debug

	echo $guilt
}

# We *must* have previously checked that
# we obtained a correct GIT branch with
# a call to `__get_git_branch`
__get_git_status ()
{
	local my_git_status cached changed managment_folder

	if [ "$(git config --get zsh.check-status)" = "false" ]
	then
		return
	fi

	my_git_status=$_gcl_colors[uptodate];

	__debug -n "		where to..."

	if [ -f ".repo/manifests.git/config" ]
	then
		echo $my_git_status
		return
	fi

	if [ "$(git rev-parse --is-inside-git-dir)" = "true" -o "$(git config --get core.bare)" = "true" ] ; then
		echo "$_gcl_colors[gitdir]"
		return
	fi

	if   [ "$(git status --porcelain | cut -c1 | tr -d ' ?\n')" != "" ] ; then 
		# Got any character but « » or «?» in first column : staged changes
		cached="yes"
	fi
	if [ "$(git status --porcelain . | cut -c2 | tr -d ' ?\n')" != "" ] ; then 
		# Got any character but « » or «?» in second column : working tree changes
		changed="yes"
	fi

	__debug

	__debug -n "		cached/changed..."
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

	__debug

	__debug -n "		merges..."
    if [ $(git status . | sed -n '2{/can be fast-forwarded/p;/have diverged/p;q}' | wc -l) -gt 0 ]
    then
        my_git_status+=";$_gcl_colors[ffwd]"
    fi

	if [ $(git ls-files --unmerged | wc -l) -gt 0 ]
	then
		my_git_status="${_gcl_colors[merging]:+$_gcl_colors[merging];}$my_git_status"
	fi

	echo $my_git_status
	__debug
}

__zsh_status ()
{
	if [ $ZDOTDIR != "" ]
	then
		cd $ZDOTDIR >/dev/null
		_status="$(git describe --always)"
		if [ "$(git status --porcelain | cut -c1-2 | tr -d ' ?\n')" != "" ]
		then
			# Dirty
			return 1
		fi
	fi
	# Clean
	return 0
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

__expand_text()
{
	# Strips unprintable characters
	print -Pn -- "$(echo $@ | sed 's/\r.*//g;s/%{[^(%})]*%}//g;s/'$T_'//g;s/'$_T'//g')"
}

export _COLUMNS_OLD=0
__hbar()
{
	if [ $COLUMNS != $_COLUMNS_OLD ]
	then
        __debug -n "	Horizontal bar..."
		_COLUMNS_OLD=$COLUMNS
		HBAR_COLOR=$C_$_prompt_colors[bar]$_C$T_
		HBAR=$T_
		for h in {1..$COLUMNS}
		do
			HBAR=${HBAR}$_tq_
		done
		HBAR=$HBAR$_T
        __debug
	fi
}

__get_prompt_lines()
{
	local lines
	lines=$( (__expand_text "$PS1 $@" ) | sed "s/\\(.\{,$COLUMNS\}\\)/\\1\n/g" )
	lines=$( echo "$lines" | sed -n '/^$/n;p' | wc -l )
	# Got number of empty lines at end of command, because they are screwed up above...
	lines=$(( $lines + $( echo -n "$@" | tr ';\n' '.;' | sed 's/^\(.*[^;]\)\(;*\)$/\2/' | wc -c ) ))

	echo $lines
}

# Rewrites current prompt.
__redisplay_ps1 ()
{
    #__redefine_prompt

    tput sc
    up_up - 1
    print -Pn "$PS1"
    tput rc
}
zle -D reset-prompt
zle -N reset-prompt __redisplay_ps1

__clear ()
{
    tput clear
    [ -n "$1" ] && tput cup $1
}

up_up ()
{
    local _up=""
    for i in {1..$(($(__get_prompt_lines) $@ ))}
        _up+=$_cuu1_
    print -Pn $_up'\r'
}

_rehash ()
{
    builtin rehash
    __redisplay_ps1
}
zle -N _rehash


# Process helper
_process_tree()
{
	for leaf in ${@:-$$}
	do
		ps -eo pid,ppid,command | awk -v leaf="$leaf" \
			'{
				parent[$1]=$2 ;
				command[$1]=$3 ;
			}
			function print_ancestry(pid)
			{
				if (pid != 1) { print_ancestry(parent[pid]) ; printf " :: " }
				printf command[pid];
			};
			END {
				print_ancestry(leaf)
				print ""
			}'
	done
}

