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

PS1_ROOT=${PS1_ROOT:-$color[red]}
PS1_USER=${PS1_USER:-$color[blue]}
PS1_USER_SSH=${PS1_USER_SSH:-$color[magenta]}
GENERIC=`print -Pn "%(! $PS1_ROOT $PS1_USER)"`

normal_user && if ( [ "$SSH_TTY" != "" ] )
then
	# This allows us to easily distinguish shells
	# which really are on the local machine or not.
	# That's so good, use it ! :-)
	GENERIC=${PS1_USER_SSH:-$GENERIC}
fi

c_=[
_c=m
C_="%{$c_"
_C="$_c%}"

set_prompt_colors ()
{
	local generic=${1:-$GENERIC}

	## Les couleurs !! ##
	COLOR_PATH="$color[reset];$generic;$color[bold]"			# pwd
	#COLOR_TERM="$color[reset];$generic"							# tty
	COLOR_USER="$color[reset];$generic"							# login
	COLOR_HOST="$color[reset];$generic"							# hostname
	#COLOR_HIST="$color[reset]"									# history number
	COLOR_AROB="$color[reset];1;%(! $color[bold]; )$generic"	# <login>@<hostname>
	COLOR_DIES="$color[reset];$generic"							# the bottom-end of the prompt
	COLOR_DOUBLEDOT="$color[reset];"							# separates pwd from git-branch
	#COLOR_PAREN="$color[reset];$color[cyan]"					# parenthesis (around tty)
	COLOR_MAIL="$color[reset];$color[yellow];$color[bold]"		# mail received
	COLOR_LISTES="$color[reset];$color[red];$color[bold]"		# less important mail received
	COLOR_BAR="$color[reset];$generic;$color[bold]"				# horizontal bar
	COLOR_BRACES=$COLOR_BAR										# braces (around date)
	COLOR_ERRR="$color[bold];$color[yellow]"					# error code
	COLOR_DATE="$color[reset];$generic"							# full date

	COLOR_CMD="$color[reset]"									# command prompt
	COLOR_EXEC="$color[reset]"									# command output

	COLOR_BRANCH_OR_REV="$color[reset];$generic"						# up-to-date
	COLOR_NOT_UP_TO_DATE="$color[reset];$color[green];$color[bold]" 	# not up to date
	COLOR_TO_BE_COMMITED="$color[reset];$color[yellow];$color[bold]"	# changes in cache

	COLOR_GIT_MANAGMENT="$color[reset];$color[red];$color[bold]"	# .git/... folder browsing
	COLOR_GIT_CACHED="$color[reset];$COLOR_TO_BE_COMMITED"			# git changes in cache
	COLOR_GIT_NOT_UP_TO_DATE="$color[reset];$COLOR_NOT_UP_TO_DATE"	# git changes in working tree
	COLOR_GIT_UP_TO_DATE="$color[reset];$generic"					# git up-to-date
}

set_prompt_colors $GENERIC

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
	print -Pn "$C_$COLOR_EXEC$_C"
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
	ERROR[color] = $COLOR_ERROR
	ERROR[string] = "%(?;;%?)"
	ERROR[pre] = "-"
	ERROR[post] = 
	ERROR[size] = ${#$(print -Pn $ERROR["pre"]$ERROR["string"]$ERROR["post"])}
}

old_precmd()
{
	# Error
	error=$(print -Pn "%(?;;-%?)")
	ERRORSIZE=${#error}
	ERROR="%(?;;"$C_$COLOR_BAR$_C"-"$C_$COLOR_ERRR$_C"%?)"

	# Flush the term title
    term_title

	# Date
	DATE=$C_$COLOR_BRACES$_C"[ "$C_$COLOR_DATE$_C"%D{%a-%d-%b-%Y %H:%M:%S}"$C_$COLOR_BRACES$_C" ]"$C_$COLOR_BAR$_C"-"
	DATEEXPAND=$(expand_text "$DATE")
	DATESIZE=${#DATEEXPAND}
	
	# Mailcheck
	MAILSTAT=$(eval echo "`[ -s ~/.procmail/procmail.log ] && < ~/.procmail/procmail.log awk 'BEGIN {RS="From" ; HAM=-1 ; LISTES=0 } !/JUNK/ { HAM++ } /Listes|Newsletters|Notifications/ { LISTES++ } END { if ((HAM - LISTES) > 0) { print "$C_$COLOR_BAR$_C""-""$C_$COLOR_MAIL$_C""@" } else if (LISTES > 0) { print "$C_$COLOR_BAR$_C""-""$C_$COLOR_LISTES$_C""@" } }'`")
	MAILSTATEXPAND=$(expand_text "$MAILSTAT")
	MAILSTATSIZE=${#MAILSTATEXPAND}

	# get git status
	GITBRANCH=$(get_git_branch)
	GITBRANCH=${GITBRANCH:+$C_$COLOR_DOUBLEDOT$_C:$C_"$(get_git_status)"$_C$GITBRANCH}

	# First line of prompt, calculation of the remaining place
	spaceleft=$((1 + $COLUMNS - $ERRORSIZE - $MAILSTATSIZE - $DATESIZE))

	unset HBAR
	for h in {1..$(($spaceleft - 1))}
	do
		HBAR=$HBAR-
	done
	#
	## Second line of prompt : don't let the path garbage the entire line
	MY_PATH="%(!.%d.%~)"
	spaceleft=`print -Pn "%n@%m $(expand_text $GITBRANCH) $ ls -laCdtrux $(expand_text "$DATE")"`
	spaceleft=$(($COLUMNS - ${#spaceleft}))
	minimalsize=`print -Pn "%1~"`
	minimalsize=$((3 + ${#minimalsize}))
	[ $spaceleft -lt $minimalsize ] && spaceleft=$minimalsize
	CURDIR="$C_$COLOR_PATH$_C%`echo $spaceleft`<..<"$MY_PATH"%<<$C_$color[reset]$_C"

## Le prompt le plus magnifique du monde, et c'est le mien ! 
# Affiche l'user, l'host, le tty et le pwd. Rien que ça... 
# Note que pour le pwd, on n'affiche que les 4 derniers dossiers pour éviter
# de pourrir le fenêtre de terminal avec un prompt à rallonge.
	PS1="$MAILSTAT""$ERROR"$C_$COLOR_BAR$_C"$HBAR""$DATE
"$C_$COLOR_USER$_C"%n"$C_$COLOR_AROB$_C"@"$C_$COLOR_HOST$_C"%m $CURDIR$GITBRANCH "$C_$COLOR_DIES$_C"%#"$C_$COLOR_CMD$_C" "


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
PS2="$C_$color[yellow];$color[bold]$_C%_$C_$color[reset];$color[cyan];$color[bold]$_C>$C_$color[reset]$_C "

# Prompt level 3
PS3="?# "

# Prompt level 4
PS4="+%N:%i> "

# Prompt de droite, pour l'heure et le code d'erreur de la dernière commande
#RPS1="%(?;;"$C_$COLOR_ERRR$_C"%?"$C_$color[reset]$_C")"

# Ultime : prompt de correction :-)
SPROMPT="zsh: $C_$color[blue]$_C%B'%R'%b$C_$color[reset]$_C ? Vous ne vouliez pas plutôt $C_$color[magenta]$_C%B'%r'%b$C_$color[reset]$_C ? [%BN%byae] "

