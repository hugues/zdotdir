##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
##
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
##

_prompt_colors[generic]=${PS1_USER:-}

if __privileged_user
then
	_prompt_colors[generic]=${PS1_ROOT:-$color[bold];$color[red]}
fi
if [ "$_yeahconsole" = "true" ]
then
	_prompt_colors[generic]=${PS1_YEAH}
fi

set_prompt_colors

## Prompts
#
#  man zshmisc(1)
#

## Automagic funcs
#
# chpwd		: changement de répertoire
# preexec	: avant d'exécuter une commande
# precmd	: avant d'afficher le prompt
#

chpwd()
{

	__cmd_exists todo && todo

	if ( __cmd_exists git && test -d .git )
	then
		# Shows tracked branches and modified files
		git status | awk '
		BEGIN { YOURBRANCH=0 }
		{
			if (NR==2 && $0 ~ "^# Your branch ") { YOURBRANCH=1 }
			if ((NR>=2 && YOURBRANCH==0) || $0 ~ "^#$") { exit }
			if (YOURBRANCH==1) { print $0 }
		}
		' | sed 's/^# /   /'
	fi


	hash -d trash=$TRASH$(readlink -f $PWD)
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
		_COLUMNS_OLD=$COLUMNS
		unset HBAR
		HBAR=$C_$_prompt_colors[bar]$_C$T_
		for h in {1..$COLUMNS}
		do
			HBAR=${HBAR}$_tq_
		done
		HBAR=$HBAR$_T
	fi
}

preexec ()
{
	__term_title "$2"

	_prompt_colors[date]=$_date_colors[exec]
	__set_prompt_date x
	_prompt_colors[date]=$_date_colors[normal]
	__hbar
	__redefine_prompt

	local lines
	lines=$( (__expand_text "$PS1 $1" ) | sed "s/\\(.\{,$COLUMNS\}\\)/\\1\n/g" )
	lines=$( echo "$lines" | sed -n '/^$/n;p' | wc -l )
	# Got number of empty lines at end of command, because they are screwed up above...
	lines=$(( $lines + $( echo -n "$1" | tr ';\n' '.;' | sed 's/^\(.*[^;]\)\(;*\)$/\2/' | wc -c ) ))

	tput sc
	for i in {1..$lines} ; tput cuu1
	# Only redraws the date, not the full prompt, since we got glitches with BANG_HIST and AUTOCORRECT...
	print -Pn $(tput cub $COLUMNS ; tput cuf $(($COLUMNS - $DATESIZE)))$C_$_prompt_colors[bar]$_C$DATE
	tput rc
	print -Pn "$C_$_prompt_colors[exec]$_C"
 }

__set_prompt_date()
{
	begin=${${1:+$_tj_}:-$_tk_}
	end=${${1:+$_tm_}:-$_tl_}

	# Date
	[ "$DEBUG" = "yes" ] && echo -n "	Date..."
	DATE=$C_$_prompt_colors[braces]$_C$T_"${begin}"$_T" "$C_$_prompt_colors[date]$_C"%D{%a-%d-%b-%Y %H:%M:%S}"$C_$_prompt_colors[braces]$_C" "$C_$_prompt_colors[bar]$_C$T_"${end}$_tq_"$_T
	DATEEXPAND=$(__expand_text "$DATE")
	DATESIZE=${#DATEEXPAND}
	[ "$DEBUG" = "yes" ] && echo
}

__update_prompt_elements()
{
	# Error
	[ "$DEBUG" = "yes" ] && echo -n "	Error code..."
	ERRORSIZE=${#ERROR}
	ERROR=${ERROR:+$C_$_prompt_colors[error]$_C$ERROR}
	[ "$DEBUG" = "yes" ] && echo

	[ "$DEBUG" = "yes" ] && echo -n "	Term title..."
	# Flush the term title
	__term_title
	[ "$DEBUG" = "yes" ] && echo

	__set_prompt_date

	[ "$DEBUG" = "yes" ] && echo -n "	Horizontal bar..."
	__hbar
	[ "$DEBUG" = "yes" ] && echo



	[ "$DEBUG" = "yes" ] && echo -n "	Agents..."
	# GPG/SSH agents
	AGENTS=""

	[ "$DEBUG" = "yes" ] && echo && echo -n "	......SSH"
	# Check ssh-agent only if the env socket has been set and is accessible
	if [ -S "$SSH_AUTH_SOCK" ]
	then
		# Get keylist
		SSH_AGENT_KEYLIST="$( ssh-add -l | grep "^[[:digit:]]\+ \([[:digit:]a-f]\{2\}:\)\{15\}[[:digit:]a-f]\{2\} .* (.*)$" )"
		# Check if it is a forwarded agent
		if [ "$SSH_AGENT_PID" -gt 0 -a -e /proc/$SSH_AGENT_PID/cmdline ]
		then
			# That's a local agent
			if [ "$SSH_AGENT_KEYLIST" != "" ]
			then
				AgentChar=${AGENT_WITH_KEYS:-✔}
				AGENTS=""
				for i in $(echo $SSH_AGENT_KEYLIST | cut -d' ' -f3 )
				do
					AGENTS=$AGENTS$C_${_agent_colors[$i:t]:-$_agent_colors[has_keys]}$_C$AgentChar
				done
			else
				AGENTCOLOR="empty"
				AgentChar=${AGENT_EMPTY:-✘}
				AGENTS=$C_$_agent_colors[$AGENTCOLOR]$_C"$AgentChar"
			fi
		else
			# That's a forwarded agent
			if [ "$SSH_AGENT_KEYLIST" != "" ]
			then
				AGENTCOLOR="has_remote_keys"
				AgentChar=${AGENT_SOCK_WITH_KEYS:-✓}
			else
				AGENTCOLOR="remote_empty"
				AgentChar=${AGENT_SOCK_EMPTY:-✗}
			fi
			AGENTS=$C_$_agent_colors[$AGENTCOLOR]$_C"$AgentChar"
		fi
	fi

	[ "$DEBUG" = "yes" ] && echo && echo -n "	......GPG"
	GPG_AGENT_PID="$(echo $GPG_AGENT_INFO | cut -d: -f2)"
	if [ "$GPG_AGENT_PID" != "" -a -e /proc/$GPG_AGENT_PID/cmdline ]
	then
		if [ "`strings /proc/$GPG_AGENT_PID/cmdline | head -n1`" = "gpg-agent" ]
		then
			AGENTCOLOR="has_keys"
			AGENTS=$AGENTS$C_$_agent_colors[$AGENTCOLOR]$_C${GPG_AGENT_RUNNING:-⚡}
		fi
	fi
	AGENTSSIZE=$(__expand_text $AGENTS)
	AGENTSSIZE=$#AGENTSSIZE
	[ "$DEBUG" = "yes" ] && echo


	##
	## Second line of prompt : don't let the path garbage the entire line
	##

	unset COMPILATION
	__compilation 2>&-

	# get cvs tag
	#
	CVSTAG=""
	[ "$DEBUG" = "yes" ] && echo -n "	CVS status..."
	if [ -d CVS ]
	then
		CVSTAG=$(test -e CVS/Tag && cat CVS/Tag || basename $(cat CVS/Root 2>&- || echo "HEAD") )
		CVSTAG=${CVSTAG:+ $C_$_gcl_colors[uptodate]$_C$CVSTAG}
	fi

	if [ -d .svn ]
	then
		# get svn status
		#
		[ "$DEBUG" = "yes" ] && echo -n "	SVN status..."
		SVNREV=$(LC_ALL=C svn info 2>&- $PWD | awk '/^Revision: / {print $2}')
		SVNREVSIZE=${#${SVNREV:+ r$SVNREV}}
		if [ "$SVNREV" != "" ]
		then
			if [ ! -z "$CHECK_SVN_STATUS" ]
			then
				SVNSTATUS="$(svn diff 2>&-)"
				SVNSTATUS=${${SVNSTATUS:+$_gcl_colors[changed]}:-$_gcl_colors[uptodate]}
			fi
		fi
		SVNREV=${SVNREV:+$C_$_prompt_colors[doubledot]$_C $C_$SVNSTATUS$_C"r"$SVNREV}
		[ "$DEBUG" = "yes" ] && echo
	fi

	# get hg status
	[ "$DEBUG" = "yes" ] && echo -n "	HG status..."
	HGBRANCH=$(__get_gcl_branch hg)
	[ ! -z "$HGBRANCH" ] && HGBRANCH=" "$HGBRANCH
	[ "$DEBUG" = "yes" ] && echo

	# get git status
	#
	[ "$DEBUG" = "yes" ] && echo -n "	GIT status..."
	GITBRANCH=$(__get_gcl_branch git)
	GITBRANCHSIZE=${#GITBRANCH}
	[ $GITBRANCHSIZE -gt 0 ] && GITBRANCHSIZE=$(($GITBRANCHSIZE))
	[ "$DEBUG" = "yes" ] && echo

	[ "$DEBUG" = "yes" ] && echo -n "	Path..."
	MY_PATH="%(!.%d.%~)"
	PATHSIZE=$(print -Pn $MY_PATH)
	PATHSIZE=${#PATHSIZE}
	[ "$DEBUG" = "yes" ] && echo
	[ "$DEBUG" = "yes" ] && echo -n "	Resize path / gitbranch..."
	spaceleft=`__expand_text "%n@%m${DISPLAY:+($DISPLAY)}$COMPILATION $ ls -laCdtrux $DATE"`
	spaceleft=$(($COLUMNS - ${#spaceleft}))
	#minimalpathsize=`print -Pn "../%1~"`
	#minimalpathsize=${#minimalpathsize}
	minimalpathsize=10
	minimalgitsize=10 # git-abbrev-commit-ish...
	if [ $GITBRANCHSIZE -gt 0 ]
	then
		if [ $spaceleft -lt $(( $PATHSIZE + $GITBRANCHSIZE )) ]
		then
			CHUNKABLE=${${GITBRANCH/*→/}/←*/}

			#  reduce the git-branch until it is shrinked to $minimalgitsize characters max.
			if [ $GITBRANCHSIZE -gt $minimalgitsize ]
			then
				GITBRANCHCHUNK=$(( $GITBRANCHSIZE - ($spaceleft - $PATHSIZE) ))
				[ $((${#CHUNKABLE} - $GITBRANCHCHUNK)) -lt $minimalgitsize ] && GITBRANCHCHUNK=$((${#CHUNKABLE} - $minimalgitsize))
			fi
			CHUNKABLE=`print -Pn "%"$(( ${#CHUNKABLE} - $GITBRANCHCHUNK ))">¬>"${CHUNKABLE%\~*}`

			GITBRANCH=${GITBRANCH/→*←/→$CHUNKABLE←}
		fi
	fi
	#  then we reduce the path until it reaches the last path element,
	spaceleft=$(($spaceleft - $GITBRANCHSIZE))
	[ $spaceleft -lt $minimalpathsize ] && spaceleft=$minimalpathsize
	if [ -n "$GITBRANCH" ]
	then
		GITBRANCH=$C_$_prompt_colors[soft_generic]$_C${${GITBRANCH/→/$C_"$(__get_git_status)"$_C}/←/$C_$_prompt_colors[soft_generic]$_C}"$(__get_guilt_series)$C_$color[none]$_C"
	fi
	CURDIR="$C_$_prompt_colors[path]$_C%`echo $spaceleft`<..<"$MY_PATH"%<<$C_$color[none]$_C"
	[ "$DEBUG" = "yes" ] && echo

	VCSBRANCH=$CVSTAG$SVNREV$GITBRANCH$HGBRANCH

}

__redefine_prompt ()
{
	case "$_yeahconsole" in
		"true")
			__yeah_prompt
			;;
		*)
			__two_lines_prompt
			;;
	esac
}

__yeah_prompt ()
{
	PS1=$C_$prompt_color[default]$_C$C_$_prompt_colors[user]$_C"%n"$C_$_prompt_colors[arob]$_C"@"$C_$_prompt_colors[host]$_C"%m "$CURDIR" "$C_$_prompt_colors[dies]$_C">"$C_$_prompt_colors[cmd]$_C" "
}

__two_lines_prompt ()
{
	## Le prompt le plus magnifique du monde, et c'est le mien !
	# Affiche l'user, l'host, le tty et le pwd. Rien que ça...
	#
	PS1=$HBAR$(print -Pn "\r" ; tput cuf 1)${AGENTS}$C_$_prompt_colors[bar]$_C$(tput cuf 1)${ERROR}$C_$_prompt_colors[bar]$_C$(tput cub $COLUMNS ; tput cuf $(($COLUMNS - $DATESIZE)))$C_$_prompt_colors[bar]$_C$DATE"
"$C_$prompt_color[default]$_C$C_$_prompt_colors[user]$_C"%n"$C_$_prompt_colors[arob]$_C"@"$C_$_prompt_colors[host]$_C"%M"$C_$_prompt_colors[display]$_C"${DISPLAY:+($DISPLAY)} "$CURDIR$VCSBRANCH" "$C_$_prompt_colors[soft_generic]$_C${COMPILATION}$C_$_prompt_colors[dies]$_C"%#"$C_$_prompt_colors[cmd]$_C" "

}

ZSH_STATUS=$(__zsh_status)
if ( echo $ZSH_STATUS | grep -q -- "-D1rTY-" )
then
	set_prompt_colors "38;5;54"
	echo
	echo -n $c_$_prompt_colors[warning]$_c
	#toilet -f bigmono9 "D1rTY Zsh.."

	HBAR=$(for i in {1..13} ; echo -n - "$_tq_")
	VBAR=$T_$_tx_$_T

	echo -n "	"
	echo -n $T_$_tl_
	echo -n $HBAR
	echo -n $_tk_$_T
	echo
	echo "	$VBAR WARNING !!  $VBAR"
	echo "	$VBAR D1rTY Zsh.. $VBAR"

	echo -n "	"
	echo -n $T_$_tm_
	echo -n $HBAR
	echo -n $_tj_$_T
	echo
	echo $c_$_prompt_colors[none]$_c
fi

precmd()
{
	# this MUST BE the real first operation else we lose the error code...
	ERROR=$(print -Pn "%(?;;%?)")

	__update_prompt_elements
	__redefine_prompt
}


# Prompt level 2
PS2="$C_$color[yellow];$color[bold]$_C%_$C_$color[none];$color[cyan];$color[bold]$_C>$C_$color[none]$_C "

# Prompt level 3
PS3="?# "

# Prompt level 4
PS4="+%N:%i> "

# Prompt de droite, pour l'heure et le code d'erreur de la dernière commande
#RPS1="%(?;;"$C_$_prompt_colors[error]$_C"%?"$C_$color[none]$_C")"

# Ultime : prompt de correction :-)
SPROMPT="zsh: $C_$_correct_colors[error]$_C'%r'$C_$color[none]$_C ? Vous ne vouliez pas plutôt $C_$_correct_colors[suggest]$_C'%r'$C_$color[none]$_C ? [%BN%byae] "

