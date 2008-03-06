##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

# Pour personnaliser les couleurs du prompt, configurez ces variables :
#  - PS1_ROOT pour la couleur du prompt ROOT
#  - PS1_USER pour la couleur du prompt USER local
#  - PS1_USER_SSH pour la couleur du prompt USER distant (en ssh)

PS1_ROOT=${PS1_ROOT:-$color[red]}
PS1_USER=${PS1_USER:-$color[blue]}
PS1_USER_SSH=${PS1_USER_SSH:-$color[magenta]}
GENERIC=`print -Pn "%(! $PS1_ROOT $PS1_USER)"`

normal_user && if ( [ "$SSH_TTY" != "" ] )
then
    # Permet de faire une distinction rapide entre les shells locaux
    # et les shells distants. C'est trop bon, mangez-en !
    GENERIC=${PS1_USER_SSH:-$GENERIC}
fi

c_=[
_c=m
C_="%{$c_"
_C="$_c%}"

## Les couleurs !! ##
COLOR_PATH="$color[reset];$GENERIC;$color[bold]"
COLOR_TERM="$color[reset];$GENERIC"
COLOR_USER="$color[reset];$GENERIC"
COLOR_HOST="$color[reset];$GENERIC"
COLOR_HIST="$color[reset]"
COLOR_AROB="$color[reset];1;%(! $color[bold]; )$GENERIC"
COLOR_DIES="$color[reset];$GENERIC"
COLOR_DOUBLEDOT="$color[reset];"
COLOR_PAREN="$color[reset];$color[cyan]"
COLOR_MAIL="$color[reset];$color[yellow];$color[bold]"
COLOR_BAR="$color[reset];$GENERIC;$color[bold]"
COLOR_BRACES=$COLOR_BAR

COLOR_BRANCH_OR_REV="$color[reset];$GENERIC"
COLOR_NOT_UP_TO_DATE="$color[reset];$color[green];$color[bold]"
COLOR_TO_BE_COMMITED="$color[reset];$color[yellow];$color[bold]"

COLOR_CMD="$color[reset]"
COLOR_EXEC="$color[reset]"

COLOR_ERRR="$color[bold];$color[yellow]"
COLOR_DATE="$color[reset];$GENERIC"

## Prompts
#
# Pour plus d'infos sur les paramètres d'expansion du prompt:
#  man zshmisc(1)
#
# La définition des prompts est séparée de celles desvariables d'environnement
# classiques pour permettre de configurer, par exemple, les couleurs par défaut
# dans ces fichiers. 

## Automagic funcs
#
# Fonctions exécutées automatiquement sous certaines conditions
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
	MAILSTAT=$(eval echo "`[ -s ~/.procmail/procmail.log ] && < ~/.procmail/procmail.log awk 'BEGIN {RS="From" ; HAM=-1} !/JUNK/ { HAM++ } END { if (HAM > 0) { print "$C_$COLOR_BAR$_C""-""$C_$COLOR_MAIL$_C""@" } }'`")
	MAILSTATEXPAND=$(expand_text "$MAILSTAT")
	MAILSTATSIZE=${#MAILSTATEXPAND}

	# get git status
	GITBRANCH=$(get_git_branch)
	GITBRANCH=${GITBRANCH:+$C_$COLOR_DOUBLEDOT$_C:$C_$(get_git_status)$_C$GITBRANCH}

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

