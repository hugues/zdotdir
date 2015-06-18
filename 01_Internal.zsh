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
			print -Pn "\e]0;%n@%m (%l) %~${@//%/%%}\a"			# Sets term title
			;;
		  screen*)
			local _sep=""
			[ $# -gt 0 ] && _sep=$1 && shift # gets and discards the separator, if any.
			# Tmux
			#print -Pn "\e]0;%n@%m (%l) %~${_sep:+$_sep #[fg=yellow,bold]}$@\a"			# Sets term title
			case $(_process_tree) in
				*":: tmux ::"*)
					print -Pn "\e]0;#[fg=red]%n#[fg=default,bold]@#[fg=red]%m#[default] (#[fg=cyan]%l#[fg=default]) #[fg=red]%~${_sep:+#[default,fg=default]$_sep #[fg=yellow,bold]}$(echo $@|sed 's/%/%%/g')\a"
					;;
				*":: SCREEN ::"*)
					# Classic screen
					# hardstatus
					#print -Pn "\e]2;{+b W}SCREEN #n {-b W}| {R}?u(u) ?{W}{r}%n@%m{W} ({c}%l{W}) {R}%~{W}${_sep:+$_sep \{+b Y\}}$@{-b W}\a" # Sets hardstatus line (term title)
					#print -Pn "\e]2;{R}?u(u) ?{W}{r}%n{R}@{r}%m{-b W} ({+b c}%l{-b W}) {R}%~{W}${_sep:+$_sep \{+b Y\}}$@{-b W}\a" # Sets hardstatus line (term title)
					# caption
					#print -Pn "\ek"
					#[ "$SUDO_USER" != "" ] && print -Pn "($USER) "
					#print -Pn "${@:-%~}"
					#print -Pn "\e\\"
					;;
			esac
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

	local _width=74
	local _space=5

	hbar=$T_${${(l:$(( $_width - ${#1} - $_space ))::q:)}//q/$_tq_}$_T

	if [ "$1" != "" ]
	then
		print -P$newline "${C_}$my_color;1${_C}${hbar}$T_$_tj_$_T${C_}0;$my_color${_C} $1 ${C_}0;$my_color;1${_C}$T_$_tm_$_tq_$_T\r${C_}0${_C}"
	else
		print -P$newline "${C_}$my_color;1${_C}${hbar}$T_${${(l:${_space}::q:)}//q/$_tq_}$_T${C_}0${_C}"
	fi
}

__get_gcl_branch ()
{
	case $1 in
		git)
            __debug -n "	GIT status..."
			__get_git_infos
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

__cleanup_git_branch_name() { sed '
		s,^tags/\(.*\),%{\\033['$color[standout]'m%}\1,
		/^remotes/ {
			s,^remotes/,,
			s,^devel/,~,
			s,^origin/,¬/,
			s,^,%{\\033['$color[standout]'m%},
		}
		s,\^0$,,
	' }

__get_git_fullstatus ()
{
	[ -n "$1" ] && pushd $1 >/dev/null

	local _branch _status _tracking _stashes

	_branch=$(__get_git_branch)

	if [ -n "$_branch" ]
	then
		_status=$(__get_git_branch_status)
		_branch=$C_$_prompt_colors[soft_generic]$_C${${_branch/→/$C_$_status$_C}/←/$C_$_prompt_colors[soft_generic]$_C}$C_$color[none]$_C
		_tracking=$(__get_git_tracking_status)
		_stashes=$(__get_git_stashes)
	fi

	[ -n "$1" ] && popd >/dev/null

	echo $_branch${_tracking:+ $_tracking}${_stashes:+ $_stashes}

}

__get_git_branch ()
{
	local my_git_branch checkouted_branch commit_ish

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
	GIT_DIR=$(git rev-parse --git-dir 2>&-)
	# Get git branch only from git managed folders (not ignored subfolders..)
	[ "$( ( git ls-files ; git ls-tree HEAD . ) 2>&- | head -n1)" = "" -a \
	  \( ! -d .git -o -z "$GIT_DIR" \) -a \
	  "$(git rev-parse --is-inside-git-dir 2>&-)" != "true" ] && return

	# commit-ish, for future uses
	commit_ish=$(git rev-parse --verify HEAD 2>/dev/null)

	# Get current working GIT branch
	my_git_branch="$(git symbolic-ref --short -q HEAD)"
	#my_git_branch="$(git name-rev --name-only HEAD)"
	# for future use
	checkouted_branch=$my_git_branch

	if [ ! "$my_git_branch" ]
	then
		# Not on a working GIT branch. Get the named current commit-ish inside parenthesis
		[ ! "$my_git_branch" ] &&\
			checkouted_branch="" && \
			my_git_branch="$(git name-rev --name-only --always --no-undefined HEAD 2>&- | __cleanup_git_branch_name)"

	#else
	#	# Initial commit
	#	if [ -L $GIT_DIR/HEAD -a ! -f $GIT_DIR/HEAD ]
	#	then
	#		my_git_branch="$(basename $(readlink -f $GIT_DIR/HEAD))"
	#	else
	#		my_git_branch="$(basename $GIT_DIR/$(cat $GIT_DIR/HEAD | sed 's/^\([0-9a-f]\{2\}\)\([0-9a-f]\{38\}\)$/objects\/\1\/\2/;s/^ref: //'))"
	#	fi
	fi
	__debug

    my_git_branch="→"$my_git_branch"←"

	__debug -n "		bisect..."
	# Bisect in progress ?
	if [ -e $GIT_DIR/BISECT_LOG ]
	then
		local bisect bisect_good bisect_bad bisect_start
		# ▶ ▷ ▸ ▹ ► ▻ ◀ ◁ ◂ ◃ ◄ ◅

		eval $(awk '
			BEGIN {
				good=""
				bad=""
			}
			/^git bisect good/ { good=$4 }
			/^git bisect bad/ { bad=$4 }
			END {
				print "bisect_good="good 
				print "bisect_bad="bad
			}' $GIT_DIR/BISECT_LOG)

		bisect=""

		if [ "$bisect_good" ]
		then
			bisect_good=$(( $(git log --oneline $bisect_good..$commit_ish | wc -l) - 1))
			bisect+="$C_$_gcl_colors[bisect-good]$_C"
			[ $bisect_good -ge 1 ] && bisect+="₊"$(echo $bisect_good | _subscript_number)
			bisect+="▸"
		fi

		#bisect+="→"$commit_ish"←"
		bisect+=$my_git_branch

		if [ "$bisect_bad" ]
		then
			bisect_bad=$(git log --oneline $commit_ish..$bisect_bad | wc -l)
			bisect+="$C_$_gcl_colors[bisect-bad]$_C"
			bisect+="◂"
			[ $bisect_bad -ge 1 ] && bisect+="₊"$(echo $bisect_bad | _subscript_number)
		fi

		bisect+="$C_$_prompt_colors[soft_generic]$_C ("
		bisect+=$C_$color[magenta]$_C$(cat $GIT_DIR/BISECT_START)
		bisect+=$C_$_prompt_colors[soft_generic]$_C")"

		echo $bisect
		return
	fi
	__debug

	__debug -n "		rebase..."
	# Rebase in progress ?
	if [ -d $GIT_DIR/rebase-merge -o -d $GIT_DIR/rebase-apply ]
	then
		local rebase onto amend current last
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
		else
			current=$(cat $REBASE_DIR/next)
			last=$(cat $REBASE_DIR/last)
		fi

		rebase="["$C_$_prompt_colors[bold_generic]$_C
		#while [ $current -gt 0 ] ; do rebase+=$T_"a"$_T ; current=$(( $current - 1 )) ; done
		#while [ $last -gt 0 ]    ; do rebase+=$T_"|"$_T ; last=$(( $last - 1 )) ; done
		rebase+=$current"/"$last

		# ▶ ▷ ▸ ▹ ► ▻ ◀ ◁ ◂ ◃ ◄ ◅

		# base
		onto=$(git name-rev --name-only --always --no-undefined $(cat $REBASE_DIR/onto) 2>&- | __cleanup_git_branch_name)

		# amended commit
		if [ -e $REBASE_DIR/amend ]
		then
			amend=$(cat $REBASE_DIR/amend)
		elif [ -e $REBASE_DIR/original-commit ]
		then
			amend=$(cat $REBASE_DIR/original-commit)
		elif [ -e $REBASE_DIR/stopped-sha ]
		then
			amend=$(cat $REBASE_DIR/stopped-sha)
		fi
		#
		if [ "$amend" != "$commit_ish" ]
		then
			#amend=$(git name-rev --name-only --always --no-undefined "$amend" 2>/dev/null | __cleanup_git_branch_name)
			#[ "$amend" = "undefined" ] &&
			amend=$(git name-rev --name-only --always --no-undefined $amend 2>&- | __cleanup_git_branch_name)
			amend=" ◃ "$C_$color[magenta]$_C$amend$C_$_prompt_colors[soft_generic]$_C
		else
			amend=""
		fi

		rebase+=$C_$_prompt_colors[soft_generic]$_C": $onto..$my_git_branch$amend]"
		[ -r $REBASE_DIR/head-name ] && rebase+=" ("$(< $REBASE_DIR/head-name sed 's/^refs\///;s/^heads\///')")"
		my_git_branch=$rebase
	else
		# No rebase in progress, put '(' ')' if needed
		[ ! "$checkouted_branch" ] && my_git_branch="($my_git_branch)"
	fi
	__debug

	echo $my_git_branch
}

__get_git_stashes() {
	__debug -n "		stashes..."
    # Show number of stashed commits by appending '+' signs for each
    if [ "$(git rev-parse --is-inside-git-dir)" != "true" -a "$(git config --get core.bare)" != "true" ]
    then
        local _stashed=$(git stash list | wc -l )
        if [ "$_stashed" -gt 0 ]
        then
			# ↙ ↯ ↲ ↵
			echo -n $C_$_gcl_colors[white]$_C"↙"
			[ $_stashed -gt 1 ] && echo -n "$(echo $_stashed | _subscript_number)"
        fi
    fi
	__debug
}

__get_git_tracking_status() {
	local git_tracking_status=""

	my_git_branch="$(git symbolic-ref --short -q HEAD)"

	if [ "$my_git_branch" ]
	then

		GIT_DIR=$(git rev-parse --git-dir 2>&-)
		if [ -d $GIT_DIR/svn ]
		then
			__debug -n "		git-svn tracking..."
			svn_current=$(git svn find-rev HEAD 2>/dev/null)

			# Finds any reference upwards current HEAD, and get the latest possible git-svn-id
			#svn_track=$(git log --grep git-svn-id -1 --pretty=%h $(git branch -a --contains=HEAD | cut -c3-) -- )
			svn_track=$(git log --grep git-svn-id -1 --pretty=%h HEAD)
			svn_rev=$(git svn find-rev $svn_track)
			# eval $( git svn info | awk '/^URL: /              { print "svn_url="$2 }
			#                             /^Repository UUID: /  { print "svn_repo="$3 }
			#                             /^Last Changed Rev: / { print "svn_rev="$2 }
			# ')
			# svn_track=$(git log --grep="git-svn-id: $svn_url@$svn_rev $svn_repo" --pretty=%h -1)

			if [ "$svn_current" != "" -a "$svn_current" != "$svn_rev" ]
			then
				git_tracking_status+=$C_$_gcl_colors[svncurrent]$_C"(r$svn_current) "
			fi

			if [ "$svn_track" != "" ]
			then

				local _ahead=0 ;
				local _behind=0 ;
				_ahead=$( git rev-list --count ${svn_track}..${my_git_branch})
				_behind=$(git rev-list --count ${my_git_branch}..${svn_track})

				# ᛨ ᛪ ⇅ ↟↟ ⇶ ⇶ ⇵ ⌥ ⬆ ⬇ ⬌  ⬍ ⤱ ⤲ ✖ ➠ ➟ ⤴ ⎇⬋⬉⬉⬈⬌⬍⬅⬄
				# ▶ ▷ ▸ ▹ ► ▻ ◀ ◁ ◂ ◃ ◄ ◅

				if [ $_behind -gt 0 ]
				then
					git_tracking_status+=$C_$_gcl_colors[ffwd_svn]$_C
					[ $_behind -gt 1 ] && git_tracking_status+="$(echo $_behind | _subscript_number)"
					git_tracking_status+="⬇"
				fi

				if [ $_ahead -gt 0 -a $_behind -gt 0 ]
				then
					svncolor="diverged_svn"
				elif [ $_ahead -gt 0 ]
				then
					svncolor="cached_svn"
				elif [ $_behind -gt 0 ]
				then
					svncolor="ffwd_svn"
				else
					svncolor="svnrev"
				fi

				git_tracking_status+=$C_$_gcl_colors[$svncolor]$_C"r$svn_rev"

				if [ $_ahead -gt 0 ]
				then
					if [ $_behind -gt 0 ]
					then
						git_tracking_status+=$C_$_gcl_colors[svnrev]$_C
					else
						git_tracking_status+=$C_$_gcl_colors[cached_svn]$_C
					fi
					git_tracking_status+="⬆"
					[ $_ahead -gt 1 ] && git_tracking_status+="$(echo $_ahead | _subscript_number)"
				fi

			fi
			__debug
			git_tracking_status+=" "
		fi

		__debug -n "		tracking..."
		local _upstream="$(git rev-parse --revs-only HEAD@\{upstream\} 2>/dev/null)"
		if [ ! "$_upstream" ]
		then
			git_tracking_status+=$C_$_gcl_colors[untracked]$_C"✖"
		else
			__debug
			__debug -n "		behind/ahead..."
			# Show number of stashed commits by appending '+' signs for each
			if [ "$(git rev-parse --is-inside-git-dir)" != "true" -a "$(git config --get core.bare)" != "true" ]
			then
				local _ahead=0 ;
				local _behind=0 ;
				_ahead=$( git rev-list --count ${_upstream}..${my_git_branch})
				_behind=$(git rev-list --count ${my_git_branch}..${_upstream})

				# ᛨ ᛪ ⇅ ↟↟ ⇶ ⇶ ⇵ ⌥ ⬆ ⬇ ⬌  ⬍ ⤱ ⤲ ✖ ➠ ➟ ⤴ ⎇⬋⬉⬉⬈⬌⬍⬅⬄

				if [ $_behind -gt 0 ]
				then
					git_tracking_status+=$C_$_gcl_colors[ffwd]$_C
					[ $_behind -gt 1 ] && git_tracking_status+="$(echo $_behind | _subscript_number)"
					git_tracking_status+="⬇"
				fi
				if [ $_ahead -gt 0 ]
				then
					if [ $_behind -gt 0 ]
					then
						git_tracking_status+=$C_$_prompt_colors[generic]$_C
					else
						git_tracking_status+=$C_$_gcl_colors[cached]$_C
					fi
					git_tracking_status+="⬆"
					[ $_ahead -gt 1 ] && git_tracking_status+="$(echo $_ahead | _subscript_number)"
				fi
			fi
		fi
		__debug
	fi

	echo $git_tracking_status
}

_subscript_number() {
	sed 's/0/₀/g;s/1/₁/g;s/2/₂/g;s/3/₃/g;s/4/₄/g;s/5/₅/g;s/6/₆/g;s/7/₇/g;s/8/₈/g;s/9/₉/g'
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
__get_git_branch_status ()
{
	local my_git_branch_status cached changed managment_folder

	GIT_DIR=$(git rev-parse --git-dir 2>/dev/null)
	[ -z "$GIT_DIR" ] && return

	if [ "$(git config --get zsh.check-status)" = "false" ]
	then
		return
	fi

	my_git_branch_status=$_gcl_colors[uptodate];

	__debug -n "		where to..."

	if [ -f ".repo/manifests.git/config" ]
	then
		echo $my_git_branch_status
		return
	fi

	if [ "$(git rev-parse --is-inside-git-dir 2>/dev/null)" = "true" -o "$(git config --get core.bare)" = "true" ] ; then
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

	if [ "$cached" != "" -a "$changed" != "" ]
	then
		my_git_branch_status="$_gcl_colors[mixed]"
	elif [ "$cached" != "" ]
	then
		my_git_branch_status="$_gcl_colors[cached]"
	elif [ "$changed" != "" ]
	then
		my_git_branch_status="$_gcl_colors[changed]"
	elif [ "$(git cat-file -t HEAD 2>/dev/null)" != "commit" ]
	then
		if [ ! -z "$(git ls-files)" ] ; then
			my_git_branch_status="$_gcl_colors[cached]"
		else
			my_git_branch_status="$_gcl_colors[init]"
		fi
	fi

	__debug

	__debug -n "		merges..."
	if [ $(git ls-files --unmerged | wc -l) -gt 0 ]
	then
		my_git_branch_status="${_gcl_colors[merging]:+$_gcl_colors[merging];}$my_git_branch_status"
	fi

	echo $my_git_branch_status
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
		HBAR=$T_${${(l:${COLUMNS}::q:)}//q/$_tq_}$_T
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
	FULLCMD=0
	if [ "$1" = "-f" ]
	then
		FULLCMD=1
		shift
	fi

	for leaf in ${@:-$$}
	do
		ps -wweo pid,ppid,command | awk -v fullcmd=$FULLCMD -v leaf="$leaf" \
			'{
				parent[$1]=$2 ;
				command[$1]=$3 ;
				if (fullcmd && NF>=4) {
					for (i=4; i<=NF; i++) {
					command[$1]=command[$1]" "$i ;
					}
				}
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

# Asks confirmation before executing parameters
confirm() {
	read -q "?Are you sure? " && $@
}

