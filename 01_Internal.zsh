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


