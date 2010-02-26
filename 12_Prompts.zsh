##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

prompt_colors[generic]=${PS1_USER:-}
if privileged_user
then
	prompt_colors[generic]=${PS1_ROOT:-$color[bold];$color[red]}
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

expand_text()
{
	# strips the %{...%}
	print -Pn -- "$(echo $@ | sed 's/%{[^(%})]*%}//g')"
}

preexec ()
{
    term_title "$(echo $1 | tr '	\n' ' ;' | sed 's/%/%%/g;s/\\/\\\\/g;s/;$//')"

	local lines="$(expand_text "$PROMPT$1" | sed "s/\\(.\{$COLUMNS\}\\)/\\1\\n/g" | wc -l)"
	prompt_colors[date]=$date_colors[exec]
	set_prompt_date
	prompt_colors[date]=$date_colors[normal]

	spaceleft=$(($COLUMNS - $AGENTSSIZE - $MAILSTATSIZE - $DATESIZE - $BATTERYSIZE))
	unset HBAR
	for h in {1..$spaceleft}
	do
		HBAR=$HBAR-
	done
	redisplay_prompt

	local string="$(expand_text "$PROMPT$1")"
	local lines=$(( (${#string} - 1) / $COLUMNS + $(echo ${string} | wc -l) - 2 ))
	for i in {0..$lines} ; print -Pn "\e[1A\e[2K"
	print -Pn "\r$PROMPT"
	print -Pn "$C_$color[cyan]$_C"
	print "${1}"

	print -Pn "$C_$prompt_colors[exec]$_C"
}

new_precmd()
{
	#
	# Arrays 
	# [0] prompt-style string
	# [1] total size
	# [2] color
	# [3] pre-string
	# [4] post-string
	#
	typeset -A ERROR DATE MAILS LOGIN HOST CWD GITINFO SVNINFO PRECMD
	ERROR[color] = $prompt_colors[error]
	ERROR[string] = "%(?;;%?)"
	ERROR[pre] = "-"
	ERROR[post] = 
	ERROR[size] = ${#$(print -Pn $ERROR[pre]$ERROR[string]$ERROR[post])}
}

set_prompt_date()
{
	# Date
	[ "$DEBUG" = "yes" ] && echo -n "	Date..."
	DATE=$C_$prompt_colors[braces]$_C"[ "$C_$prompt_colors[date]$_C"%D{%a-%d-%b-%Y %H:%M:%S}"$C_$prompt_colors[braces]$_C" ]"$C_$prompt_colors[bar]$_C"-"
	DATEEXPAND=$(expand_text "$DATE")
	DATESIZE=${#DATEEXPAND}
	[ "$DEBUG" = "yes" ] && echo
}

update_prompt()
{
	# Error
	error=$(print -Pn "%(?;;-%?)") ## MUST BE the first operation else we lose the error code...
	[ "$DEBUG" = "yes" ] && echo -n "	Error code..."
	ERRORSIZE=${#error}
	ERROR="%(?;;"$C_$prompt_colors[bar]$_C"-"$C_$prompt_colors[error]$_C"%?)"
	[ "$DEBUG" = "yes" ] && echo

	[ "$DEBUG" = "yes" ] && echo -n "	Term title..."
	# Flush the term title
    term_title
	[ "$DEBUG" = "yes" ] && echo

	set_prompt_date

	[ "$DEBUG" = "yes" ] && echo -n "	Agents..."
	# GPG/SSH agents
	AGENTS=""
	[ -r "${KEYCHAIN}"     ] && source ${KEYCHAIN}
	[ -r "${KEYCHAIN}-gpg" ] && source ${KEYCHAIN}-gpg


	local _is_multibyte_compliant
	if ( echo ${(k)options} | grep "multibyte" >/dev/null ) && [ "$options[multibyte]" = "on" ]
	then
		_is_multibyte_compliant="yes it is !"
	else
		_is_multibyte_compliant=""
	fi

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
				AGENTCOLOR="has_keys"
				AGENTCHAR=${AGENT_WITH_KEYS:-$( [ $_is_multibyte_compliant ] && echo "★" || echo "S" )}
			else
				AGENTCOLOR="empty"
				AGENTCHAR=${AGENT_EMPTY:-$( [ $_is_multibyte_compliant ] && echo "☆" || echo "S" )}
			fi
		else
			# That's a forwarded agent
			if [ "$SSH_AGENT_KEYLIST" != "" ]
			then
				AGENTCOLOR="has_remote_keys"
				AGENTCHAR=${AGENT_SOCK_WITH_KEYS:-$( [ $_is_multibyte_compliant ] && echo "★" || echo "@" )}
			else
				AGENTCOLOR="remote_empty"
				AGENTCHAR=${AGENT_SOCK_EMPTY:-$( [ $_is_multibyte_compliant ] && echo "☆" || echo "@" )}
			fi
		fi

		AGENTS=$C_$agent_colors[$AGENTCOLOR]$_C"$AGENTCHAR"
	fi

	GPG_AGENT_PID="$(echo $GPG_AGENT_INFO | cut -d: -f2)"
	if [ "$GPG_AGENT_PID" != "" -a -e /proc/$GPG_AGENT_PID/cmdline ]
	then
		if [ "`strings /proc/$GPG_AGENT_PID/cmdline | head -n1`" = "gpg-agent" ]
		then
			AGENTCOLOR="has_keys"
			AGENTS=$AGENTS$C_$agent_colors[$AGENTCOLOR]$_C${GPG_AGENT_RUNNING:-$( [ $_is_multibyte_compliant ] && echo "☆" || echo "G" )}
		fi
	fi
	AGENTS=${AGENTS:+$C_$prompt_colors[bar]$_C"-"$AGENTS}
	AGENTSSIZE=$(expand_text $AGENTS)
	AGENTSSIZE=$#AGENTSSIZE
	[ "$DEBUG" = "yes" ] && echo
	
	# Mailcheck
	[ "$DEBUG" = "yes" ] && echo -n "	Mails..."
	MAILSTAT=$(eval echo "`[ -s ~/.procmail/procmail.log ] && < ~/.procmail/procmail.log awk 'BEGIN {RS="From" ; HAM=-1 ; LISTES=0 } !/JUNK|dev.null/ { HAM++ } /Listes|Newsletters|Notifications/ { LISTES++ } END { if ((HAM - LISTES) > 0) { print "$C_$prompt_colors[bar]$_C""-""$C_$mail_colors[unread]$_C""@" } else if (LISTES > 0) { print "$C_$prompt_colors[bar]$_C""-""$C_$mail_colors[listes]$_C""@" } }'`")
	MAILSTATEXPAND=$(expand_text "$MAILSTAT")
	MAILSTATSIZE=${#MAILSTATEXPAND}
	[ "$DEBUG" = "yes" ] && echo

	
	if [ -e /proc/pmu/battery_0 ]
	then
		[ "$DEBUG" = "yes" ] && echo -n "	Battery..."

		POWERADAPTER=$(grep "^AC Power" /proc/pmu/info | cut -c26)

		typeset -A battery
		battery[remaining]=$(grep "^time rem" /proc/pmu/battery_0 | cut -c14- )
		battery[remain_hrs]=$(( $battery[remaining] / 3600 ))
		battery[remain_min]=$(( ($battery[remaining] - ( $battery[remain_hrs] * 3600 )) / 60 ))
		[ "$battery[remain_min]" -lt 10 ] && battery[remain_min]="0"$battery[remain_min]
		battery[remains]=$battery[remain_hrs]"h"$battery[remain_min]

		BATTERYSIZE=$(( ${#battery[remains]} + 1 ))

		battery[load]=$(grep "^current" /proc/pmu/battery_0 | cut -c14- )

		if [ $POWERADAPTER -ne 0 ]
		then
			battery[color]="charging"
			if [ $battery[load] -eq 0 ]
			then
				## Battery full
				BATTERYSIZE=2
				battery[remains]="⚡"
			fi
		else
			if [ $battery[remaining] -lt 659 ]
			then
				battery[color]="critical"
			else
				battery[color]="uncharging"
			fi
		fi
		BATTERY=$C_$prompt_colors[bar]$_C"-"$C_$battery_colors[$battery[color]]$_C"$battery[remains]"
		unset battery

		[ "$DEBUG" = "yes" ] && echo
	else
		BATTERY=
		BATTERYSIZE=0
	fi

	[ "$DEBUG" = "yes" ] && echo -n "	Horizontal bar..."
	# First line of prompt, calculation of the remaining place
	spaceleft=$(($COLUMNS - $ERRORSIZE - $AGENTSSIZE - $MAILSTATSIZE - $DATESIZE - $BATTERYSIZE))
	unset HBAR
	for h in {1..$spaceleft}
	do
		HBAR=$HBAR-
	done
	[ "$DEBUG" = "yes" ] && echo

	##
	## Second line of prompt : don't let the path garbage the entire line
	##

	# get cvs tag
	#
	CVSTAG=""
	[ "$DEBUG" = "yes" ] && echo -n "	CVS status..."
	if [ -d CVS ]
	then
		CVSTAG=$(test -e CVS/Tag && cat CVS/Tag || basename $(cat CVS/Root 2>&- || echo "HEAD") )
		CVSTAG=${CVSTAG:+ $C_$prompt_colors[up_to_date]$_C$CVSTAG}
	fi

	# get svn status
	#
	[ "$DEBUG" = "yes" ] && echo -n "	SVN status..."
	SVNREV=$(LC_ALL=C svn info 2>&- $PWD | awk '/^Revision: / {print $2}')
	SVNREVSIZE=${#${SVNREV:+ r$SVNREV}}	
	if [ "$SVNREV" != "" ]
	then
		if [ -z "$DO_NOT_CHECK_SVN_STATUS" ]
		then
			SVNSTATUS="$(svn diff 2>&-)"
			SVNSTATUS=${${SVNSTATUS:+$prompt_colors[not_up_to_date]}:-$prompt_colors[up_to_date]}
		fi
	fi
	SVNREV=${SVNREV:+$C_$prompt_colors[doubledot]$_C $C_$SVNSTATUS$_C"r"$SVNREV}
	[ "$DEBUG" = "yes" ] && echo

	# get git status
	#
	[ "$DEBUG" = "yes" ] && echo -n "	GIT status..."
	GITBRANCH=$(get_git_branch)
	GITBRANCHSIZE=${#GITBRANCH}
	[ $GITBRANCHSIZE -gt 0 ] && GITBRANCHSIZE=$(($GITBRANCHSIZE))
	[ "$DEBUG" = "yes" ] && echo

	[ "$DEBUG" = "yes" ] && echo -n "	Path..."
	MY_PATH="%(!.%d.%~)"
	PATHSIZE=$(print -Pn $MY_PATH)
	PATHSIZE=${#PATHSIZE}
	[ "$DEBUG" = "yes" ] && echo
	[ "$DEBUG" = "yes" ] && echo -n "	Resize path / gitbranch..."
	spaceleft=`print -Pn "$SHLVL - %n@%m  $ ls -laCdtrux $(expand_text "$DATE")"`
	spaceleft=$(($COLUMNS - ${#spaceleft}))
	#minimalpathsize=`print -Pn "../%1~"`
	#minimalpathsize=${#minimalpathsize}
	minimalpathsize=10
	minimalgitsize=10 # git-abbrev-commit-ish...
	if [ $GITBRANCHSIZE -gt 0 ]
	then
		if [ $spaceleft -lt $(( $PATHSIZE + $GITBRANCHSIZE )) ]
		then
			local unbreakablegittail
			if [ "$(echo $GITBRANCH | grep "^\[rebase ")" = "" ]
			then
				#  reduce the git-branch until it is shrinked to $minimalgitsize characters max.

				if [ $GITBRANCH[-1] = ")" ]
				then
					unbreakablegittail=${${(M)GITBRANCH%\~*}}
					[ "$unbreakablegittail" = "" -a $GITBRANCHSIZE -gt $minimalgitsize ] && unbreakablegittail=")"
				fi
				if [ $GITBRANCHSIZE -gt $minimalgitsize ]
				then
					GITBRANCHSIZE=$(( $spaceleft - $PATHSIZE ))
					[ $GITBRANCHSIZE -lt $minimalgitsize ] && GITBRANCHSIZE=$minimalgitsize
				fi
				GITBRANCH=`print -Pn "%"$(($GITBRANCHSIZE - ${#unbreakablegittail}))">..>"${GITBRANCH%\~*}${unbreakablegittail:+"%"${#unbreakablegittail}"<<"$GITBRANCH}`
			else

				#
				# TODO : réduire la taille du hash, s'il y en a un.
				#

			fi
		fi
	fi
	#  then we reduce the path until it reaches the last path element,
	spaceleft=$(($spaceleft - $GITBRANCHSIZE))
	[ $spaceleft -lt $minimalpathsize ] && spaceleft=$minimalpathsize
	GITBRANCH=${GITBRANCH:+ $C_"$(get_git_status)"$_C$GITBRANCH}
	CURDIR="$C_$prompt_colors[path]$_C%`echo $spaceleft`<..<"$MY_PATH"%<<$C_$color[none]$_C"
	[ "$DEBUG" = "yes" ] && echo
}

redisplay_prompt ()
{
## Le prompt le plus magnifique du monde, et c'est le mien ! 
# Affiche l'user, l'host, le tty et le pwd. Rien que ça... 
	PS1=$AGENTS$MAILSTAT$ERROR$BATTERY$C_$prompt_colors[bar]$_C$HBAR$DATE"
"$C_"30;1"$_C$SHLVL"-"$C_$prompt_color[default]$_C$C_$prompt_colors[user]$_C"%n"$C_$prompt_colors[arob]$_C"@"$C_$prompt_colors[host]$_C"%m "$CURDIR$CVSTAG$SVNREV$GITBRANCH" "$C_$prompt_colors[dies]$_C"%#"$C_$prompt_colors[cmd]$_C" "

}

precmd()
{
	update_prompt
	redisplay_prompt
}


# Prompt level 2
PS2="$C_$color[yellow];$color[bold]$_C%_$C_$color[none];$color[cyan];$color[bold]$_C>$C_$color[none]$_C "

# Prompt level 3
PS3="?# "

# Prompt level 4
PS4="+%N:%i> "

# Prompt de droite, pour l'heure et le code d'erreur de la dernière commande
#RPS1="%(?;;"$C_$prompt_colors[error]$_C"%?"$C_$color[none]$_C")"

# Ultime : prompt de correction :-)
SPROMPT="zsh: $C_$correct_colors[error]$_C'%R'$C_$color[none]$_C ? Vous ne vouliez pas plutôt $C_$correct_colors[suggest]$_C'%r'$C_$color[none]$_C ? [%BN%byae] "

