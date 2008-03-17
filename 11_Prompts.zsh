##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

# I hate kik00l0l colorized prompts, so I'm using a way to
# give a dominant color for each part of the prompt, each of
# these remain still configurable one by one.
# Take a look to set_prompt_colors for these colorizations.
#
# To set the dominant color I'm using this :
#
#  - PS1_ROOT when we are root
#  - PS1_USER for normal usage
#  - PS1_USER_SSH when we are connected through SSH
#
# I'm storing the resulting dominant color in $GENERIC

typeset -A prompt_colors git_colors mail_colors

PS1_ROOT=${PS1_ROOT:-$color[red]}
PS1_USER=${PS1_USER:-$color[blue]}
PS1_USER_SSH=${PS1_USER_SSH:-$color[magenta]}
prompt_colors[generic]=`print -Pn "%(! $PS1_ROOT $PS1_USER)"`

normal_user && if ( [ "$SSH_TTY" != "" ] )
then
	# This allows us to easily distinguish shells
	# which really are on the local machine or not.
	# That's so good, use it ! :-)
	prompt_colors[generic]=${PS1_USER_SSH:-$prompt_colors[generic]}
fi

c_=[
_c=m
C_="%{$c_"
_C="$_c%}"

set_prompt_colors ()
{
	prompt_colors[generic]=${1:-$prompt_colors[generic]}

	## Les couleurs !! ##
	prompt_colors[path]="$color[none];$prompt_colors[generic];$color[bold]"			# pwd
	#prompt_colors[term]="$color[none];$prompt_colors[generic]"							# tty
	prompt_colors[user]="$color[none];$prompt_colors[generic]"							# login
	prompt_colors[host]="$color[none];$prompt_colors[generic]"							# hostname
	#prompt_colors[hist]="$color[none]"									# history number
	prompt_colors[arob]="$color[none];$color[bold];$prompt_colors[generic]"	# <login>@<hostname>
	prompt_colors[dies]="$color[none];$prompt_colors[generic]"							# the bottom-end of the prompt
	prompt_colors[doubledot]="$color[none];"							# separates pwd from git-branch
	#prompt_colors[paren]="$color[none];$color[cyan]"					# parenthesis (around tty)
	prompt_colors[bar]="$color[none];$prompt_colors[generic];$color[bold]"				# horizontal bar
	prompt_colors[braces]=$prompt_colors[bar]							# braces (around date)
	prompt_colors[error]="$color[bold];$color[yellow]"					# error code
	prompt_colors[date]="$color[none];$prompt_colors[generic]"							# full date

	prompt_colors[cmd]="$color[none]"									# command prompt
	prompt_colors[exec]="$color[none]"									# command output

	mail_colors[unread]="$color[none];$color[yellow];$color[bold]"		# mail received
	mail_colors[listes]="$color[none];$color[red];$color[bold]"		# less important mail received

	prompt_colors[up_to_date]="$color[none];$prompt_colors[generic]"						# up-to-date
	prompt_colors[not_up_to_date]="$color[none];$color[green];$color[bold]" 	# not up to date
	prompt_colors[to_be_commited]="$color[none];$color[yellow];$color[bold]"	# changes in cache

	git_colors[managment_folder]="$color[none];$color[red];$color[bold]"	# .git/... folder browsing
	git_colors[cached]="$prompt_colors[to_be_commited]"			# git changes in cache
	git_colors[not_up_to_date]="$prompt_colors[not_up_to_date]"	# git changes in working tree
	git_colors[up_to_date]="$prompt_colors[up_to_date]"					# git up-to-date
}

set_prompt_colors $prompt_colors[generic]

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

preexec ()
{
    term_title " ··· $(echo $1 | tr '	\n' ' ;' | sed 's/%/%%/g;s/\\/\\\\/g')"
	print -Pn "$C_$prompt_colors[exec]$_C"
}

expand_text()
{
	# strips the %{...%}
	print -Pn -- "$(echo $@ | sed 's/%{[^(%})]*%}//g')"
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

old_precmd()
{
	# Error
	error=$(print -Pn "%(?;;-%?)")
	ERRORSIZE=${#error}
	ERROR="%(?;;"$C_$prompt_colors[bar]$_C"-"$C_$prompt_colors[error]$_C"%?)"

	# Flush the term title
    term_title

	# Date
	DATE=$C_$prompt_colors[braces]$_C"[ "$C_$prompt_colors[date]$_C"%D{%a-%d-%b-%Y %H:%M:%S}"$C_$prompt_colors[braces]$_C" ]"$C_$prompt_colors[bar]$_C"-"
	DATEEXPAND=$(expand_text "$DATE")
	DATESIZE=${#DATEEXPAND}
	
	# Mailcheck
	MAILSTAT=$(eval echo "`[ -s ~/.procmail/procmail.log ] && < ~/.procmail/procmail.log awk 'BEGIN {RS="From" ; HAM=-1 ; LISTES=0 } !/JUNK/ { HAM++ } /Listes|Newsletters|Notifications/ { LISTES++ } END { if ((HAM - LISTES) > 0) { print "$C_$prompt_colors[bar]$_C""-""$C_$mail_colors[unread]$_C""@" } else if (LISTES > 0) { print "$C_$prompt_colors[bar]$_C""-""$C_$mail_colors[listes]$_C""@" } }'`")
	MAILSTATEXPAND=$(expand_text "$MAILSTAT")
	MAILSTATSIZE=${#MAILSTATEXPAND}

	# First line of prompt, calculation of the remaining place
	spaceleft=$((1 + $COLUMNS - $ERRORSIZE - $MAILSTATSIZE - $DATESIZE))

	unset HBAR
	for h in {1..$(($spaceleft - 1))}
	do
		HBAR=$HBAR-
	done

	##
	## Second line of prompt : don't let the path garbage the entire line
	##

	# get git status
	#
	GITBRANCH=$(get_git_branch)
	GITBRANCHSIZE=${#GITBRANCH}
	[ $GITBRANCHSIZE -gt 0 ] && GITBRANCHSIZE=$(($GITBRANCHSIZE))

	MY_PATH="%(!.%d.%~)"
	PATHSIZE=$(print -Pn $MY_PATH)
	PATHSIZE=${#PATHSIZE}
	spaceleft=`print -Pn "%n@%m  $ ls -laCdtrux $(expand_text "$DATE")"`
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
		fi
	fi
	#  then we reduce the path until it reaches the last path element,
	spaceleft=$(($spaceleft - $GITBRANCHSIZE))
	[ $spaceleft -lt $minimalpathsize ] && spaceleft=$minimalpathsize
	GITBRANCH=${GITBRANCH:+$C_$prompt_colors[doubledot]$_C:$C_"$(get_git_status)"$_C$GITBRANCH}
	CURDIR="$C_$prompt_colors[path]$_C%`echo $spaceleft`<..<"$MY_PATH"%<<$C_$color[none]$_C"

## Le prompt le plus magnifique du monde, et c'est le mien ! 
# Affiche l'user, l'host, le tty et le pwd. Rien que ça... 
# Note que pour le pwd, on n'affiche que les 4 derniers dossiers pour éviter
# de pourrir le fenêtre de terminal avec un prompt à rallonge.
	PS1="$MAILSTAT""$ERROR"$C_$prompt_colors[bar]$_C"$HBAR""$DATE
"$C_$prompt_colors[user]$_C"%n"$C_$prompt_colors[arob]$_C"@"$C_$prompt_colors[host]$_C"%m $CURDIR$GITBRANCH "$C_$prompt_colors[dies]$_C"%#"$C_$prompt_colors[cmd]$_C" "


}

precmd()
{
	old_precmd
}

chpwd()
{
    which todo > /dev/null 2>&1 && todo
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
SPROMPT="zsh: $C_$color[blue]$_C%B'%R'%b$C_$color[none]$_C ? Vous ne vouliez pas plutôt $C_$color[magenta]$_C%B'%r'%b$C_$color[none]$_C ? [%BN%byae] "

