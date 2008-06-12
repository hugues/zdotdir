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
  [[ -t 1 ]] &&
    case $TERM in
      sun-cmd)
        print -Pn "\e]l%n@%m %~$1\e\\"				# Never tested..
		;;
      *term*|rxvt*|putty)
	    print -Pn "\e]0;%n@%m (%l) %~$1\a"			# Sets term title
		;;
	  screen)
	    print -Pn "\e]2;[SCREEN] %n@%m (%l) %~$1\a" # Sets term title
		print -Pn "\ek%n@%m (%l) %~$1\e\\"			# Sets screen title
		;;
	  *)
	  	;;
    esac
}

preprint()
{
	local my_color

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

	[ "$( ( git-ls-tree HEAD . 2>&- ; git-ls-files . 2>&- ) | head -n 1)" == "" ] && return 

	# Get current working GIT branch
	my_git_branch="$(git-branch 2>&- | grep -E '^\* ' | cut -c3-)"

	if [ "$my_git_branch" != "" ]
	then
		# If not on a working GIT branch, get the named current commit-ish inside parenthesis
		[ "$my_git_branch" == "(no branch)" ] &&\
			my_git_branch="($(git-name-rev HEAD 2>&- | awk '{ print $2 }' | sed 's,^tags/,,;s,^remotes/,,'))"

		# If neither on a named commit-ish, show abbreviated commit-id
		[ "$my_git_branch" == "(undefined)" ] &&\
			my_git_branch="($(git-rev-parse HEAD 2>&-))"
	fi

	echo $my_git_branch
}

# We *must* have previously checked that
# we obtained a correct GIT branch with
# a call to `get_git_branch`
get_git_status ()
{
	local my_git_status cached not_up_to_date managment_folder
	local lockfile previous

	lockfile="$(git rev-parse --git-dir)/.zsh.get_git_status.lock"
	previous="$(git rev-parse --git-dir)/.zsh.get_git_status.prev"

	if [ -e $lockfile ] ; then 

		my_git_status=$git_colors[running]

		[ "$DEBUG" == "yes" ] && echo >&2 "lockfile $lockfile already present.."
		if [ -e $previous ] ; then
			[ "$DEBUG" == "yes" ] && eecho >&2 "getting previous status.."
			my_git_status=$(cat $previous)
		fi

		echo $my_git_status
		return
	fi

	[ "$DEBUG" == "yes" ] && echo >&2 "creating $lockfile.."
	touch $lockfile
	
	if [ "$(git-rev-parse --git-dir)" == "." ] ; then
		echo "$git_colors[managment_folder]"
		return
	fi

	if   [ "$(git-diff --cached 2>&- | grep '^diff ')" != "" ] ; then 
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

	[ "$DEBUG" == "yes" ] && echo >&2 "removing $lockfile.."
	echo $my_git_status > $previous
	rm -f $lockfile

	echo $my_git_status
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

