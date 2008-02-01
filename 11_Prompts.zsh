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

PS1_ROOT=${PS1_ROOT:-$RED}
PS1_USER=${PS1_USER:-$BLUE}
PS1_USER_SSH=${PS1_USER_SSH:-$MAGENTA}
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
COLOR_PATH="0;$GENERIC;$BOLD"
COLOR_TERM="0;$GENERIC"
COLOR_USER="0;$GENERIC"
COLOR_HOST="0;$GENERIC"
COLOR_HIST="$VOID"
COLOR_AROB="0;1;%(! $BOLD; )$GENERIC"
COLOR_DIES="0;$GENERIC"
COLOR_DOUBLEDOT="0;%(! $VOID $VOID)"
COLOR_PAREN="0;$CYAN"
COLOR_BAR="0;$GENERIC;$BOLD"
COLOR_BRACES=$COLOR_BAR

COLOR_BRANCH_OR_REV="0;$GENERIC"
COLOR_NOT_UP_TODATE="0;$GREEN;$BOLD"
COLOR_TOBE_COMMITED="0;$YELLOW;$BOLD"

COLOR_CMD="$VOID"
COLOR_EXEC="$VOID"

COLOR_ERRR="$BOLD;$YELLOW"
COLOR_DATE="0;$GENERIC"

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

GITCHECK=${GITCHECK:-}
#SVNCHECK=${SVNCHECK:-}
#unset GITCHECK SVNCHECK

precmd ()
{
    term_title

	DATE="%D{%H:%M:%S %d/%m/%Y}"
	datesize=`print -Pn $DATE`
	datesize=${#datesize}
	ERROR=%(? "$C_$COLOR_BAR$_C----" "%4>>"$C_$COLOR_ERRR$_C"%?$C_$COLOR_BAR$_C"---"%>>")
	errorsize=4

	## SVN TRACKING ##
	SVNREV=$(svn info 2>&- | grep '^Révision : ' | sed 's/^.* : /r/')
	if [ "$SVNREV" != "" ]
	then
		if [ "$SVNCHECK" != "" ] && ( preprint "Checking svn status..." ; [ $(svn status 2>&- | grep -v '^?' | wc -l) -gt 0 ] )
		then
			COLOR_SVN=$COLOR_NOT_UP_TODATE
		else
			COLOR_SVN=$COLOR_BRANCH_OR_REV
		fi
	else
		SVNREV=
	fi

	## First line of prompt : 
	#
	# -ERR------------------------git-svn-[ date ]-
	#
	spaceleft=$(($COLUMNS - ${errorsize} - ${#SVNREV} - 3 - ${datesize} - 3))

	unset HBAR
	for h in {1..$(($spaceleft - 1))}
	do
		HBAR=$HBAR-
	done

	## Second line of prompt : don't let the path garbage the entire line
	MY_PATH="%(!.%d.%~)"
	pathsize=`print -Pn $MY_PATH`
	pathsize=${#pathsize}
	spaceleft=`print -Pn "%n@%m $GitBranch %#-ls -laCdtrux-[ $DATE ]-"`
	spaceleft=$(($COLUMNS - ${#spaceleft}))
	minimalsize=`print -Pn "%1~"`
	minimalsize=$((3 + ${#minimalsize}))
	[ $spaceleft -lt $minimalsize ] && spaceleft=$minimalsize
	CURDIR="$C_$COLOR_PATH$_C%`echo $spaceleft`<..<"$MY_PATH"%<<$C_$VOID$_C"

## Le prompt le plus magnifique du monde, et c'est le mien ! 
# Affiche l'user, l'host, le tty et le pwd. Rien que ça... 
# Note que pour le pwd, on n'affiche que les 4 derniers dossiers pour éviter
# de pourrir le fenêtre de terminal avec un prompt à rallonge.
	PS1=$C_$COLOR_BAR$_C"-""$ERROR$HBAR"$C_$COLOR_SVN$_C"$SVNREV"$C_$COLOR_BAR$_C"-"$C_$COLOR_BRACES$_C"[ "$C_$COLOR_DATE$_C$DATE$C_$COLOR_BRACES$_C" ]"$C_$COLOR_BAR$_C"-
"$C_$COLOR_USER$_C"%n"$C_$COLOR_AROB$_C"@"$C_$COLOR_HOST$_C"%m $CURDIR$GITBRANCH "$C_$COLOR_DIES$_C"%#"$C_$COLOR_CMD$_C" "

	# Mailcheck
	[ -s ~/.procmail/procmail.log ] && sbin/mails
}

chpwd()
{
    which todo > /dev/null 2>&1 && todo
	check_git_status
}


# Prompt level 2
PS2="%{[33m%}%B%_%b%{[36m%}%B>%b%{[0m%} "

# Prompt level 3
PS3="?# "

# Prompt level 4
PS4="+%N:%i> "

# Prompt de droite, pour l'heure et le code d'erreur de la dernière commande
#RPS1="%(?;;"$C_$COLOR_ERRR$_C"%?"$C_$VOID$_C")"

# Ultime : prompt de correction :-)
SPROMPT="zsh: $C_$BLUE$_C%B'%R'%b$C_$VOID$_C ? Vous ne vouliez pas plutôt $C_$MAGENTA$_C%B'%r'%b$C_$VOID$_C ? [%BN%byae] "

