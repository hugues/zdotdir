##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 


cmd_exists ()
{
	which $1 2>/dev/null >&2
}

term_title()
{
  [[ -t 1 ]] &&
    case $TERM in
      sun-cmd)
        print -Pn "\e]l%n@%m %~$1\e\\" ;;
      *term*|rxvt*)
	    print -Pn "\e]0;%n@%m (%l) %~$1\a" ;;
	  *)
	  	;;
    esac
}

preprint()
{
	hbar=
	for i in {1..$(($COLUMNS - ${#1} - 5))}
	do
		hbar=$hbar-
	done
	print -Pn "${C_}0;30;1${_C}${hbar}[ $1 ]-\r${C_}0${_C}"
}

get_git_branch ()
{
	# Get current working GIT branch
	my_git_branch="$(git-branch 2>&- | grep -E '^\* ' | cut -c3-)"

	# If not on a working GIT branch, get the named current commit-ish inside parenthesis
	[ "$my_git_branch" == "(no branch)" ] &&\
		my_git_branch="$(git-show --pretty=format:%H 2>&- | head -n1 | git-name-rev --stdin 2>&- | awk '{ print $2 }')"

	# If neither on a named commit-ish, show abbreviated commit-id
	[ "$my_git_branch" == "" ] &&\
		my_git_branch="($(git-show --pretty=format:%h 2>&- | head -n1)...)"

	echo $my_git_branch
}

check_git_status ()
{
	## GIT TRACKING ##
	if [ "$GITCHECK" != "no" -a "$(git-ls-files 2>&-)" != "" ]
	then
		GITBRANCH=$(get_git_branch);
		if [ "$GITBRANCH" != "" ]
		then
			#preprint "Check git status..."
			#_git_status=$(git-status 2>&- | grep -E '^# ([[:alpha:]]+ )+(but not|to be)( [[:alpha:]]+)+:$')
			if   [ "$(git-diff --cached 2>&- | grep '^diff ')" != "" ] ; then 
				COLOR_GIT=$COLOR_TO_BE_COMMITED
			elif [ "$(git-ls-files -m 2>&-)" != "" ] ; then 
				COLOR_GIT=$COLOR_NOT_UP_TO_DATE
			else
				COLOR_GIT=$COLOR_BRANCH_OR_REV
			fi

			# Here we are on a .git folder..
			if ( echo ${(s:/:)PWD} | grep "\.\<git\>" >/dev/null )
			then
				COLOR_GIT="$BOLD;$RED"
			fi

		fi
	else
		GITBRANCH=""
	fi
	GitBranch=${GITBRANCH:+:$GITBRANCH}
	GITBRANCH=${GITBRANCH:+$C_$COLOR_DOUBLEDOT$_C:$C_$COLOR_GIT$_C$GITBRANCH}
}

normal_user ()
{
	if [ -e /etc/login.defs ]
	then
		eval `grep -v '^[$#]' /etc/login.defs | grep "^UID_" | tr -d '[:blank:]' | sed 's/^[A-Z_]\+/&=/'`
		[ \( $UID -ge $UID_MIN \) -a \( $UID -le $UID_MAX \) ]
	else
		[ "`whoami`" != "root" ]
	fi
}

privileged_user ()
{
	! normal_user
}

