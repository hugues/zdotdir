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
	echo $(git branch 2>&- | grep -E '^\* ' | cut -c3-)
}

get_git_status ()
{
	git-status
	GITCHECK="yes"
	check_git_status
}

check_git_status ()
{
	## GIT TRACKING ##
	if [ "$GITCHECK" != "" ]
	then
		GITBRANCH=$(get_git_branch);
		if [ "$GITBRANCH" != "" ]
		then
			preprint "Check git status..."
			_git_status=$(git-runstatus 2>&- | grep -E '^# ([[:alpha:]]+ )+(but not|to be)( [[:alpha:]]+)+:$')
			if   [ "$(grep "but not" <<< $_git_status)" != "" ] ; then 
				COLOR_GIT=$COLOR_NOT_UP_TODATE
			elif [ "$(grep "to be committed" <<< $_git_status)" != "" ] ; then 
				COLOR_GIT=$COLOR_TOBE_COMMITED
			else
				COLOR_GIT=$COLOR_BRANCH_OR_REV
			fi

		fi
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

