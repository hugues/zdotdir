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
MYCOLOR=$(print -Pn "%(! $PS1_ROOT $PS1_USER)")

if ( [ "$SSH_TTY" != "" ] )
then
    # Permet de faire une distinction rapide entre les shells locaux
    # et les shells distants. C'est trop bon, mangez-en !
    MYCOLOR=${PS1_USER_SSH:-$MYCOLOR}
fi

c_=[
_c=m

## Les couleurs !! ##
COLOR_PATH="0;%(!  $BOLD;)$MYCOLOR"
COLOR_TERM="0;$MYCOLOR"
COLOR_USER="0;$MYCOLOR"
COLOR_HOST="0;$MYCOLOR"
COLOR_HIST=$VOID
COLOR_AROB="0;1;%(! $BOLD; )$MYCOLOR"
COLOR_DIES="0;%(! $BOLD; )"
COLOR_DOUBLEDOT="0;%(! $VOID $MYCOLOR)"
COLOR_BRANCH="0;%(! $BOLD; )$MYCOLOR"
COLOR_BRACES="0;$CYAN"
COLOR_PAREN="0;$CYAN"

COLOR_ERRR="$BOLD;$RED"
COLOR_DATE="0;$MYCOLOR"

## Prompts
#
# Pour plus d'infos sur les param�tres d'expansion du prompt:
#  man zshmisc(1)
#
# La d�finition des prompts est s�par�e de celles desvariables d'environnement
# classiques pour permettre de configurer, par exemple, les couleurs par d�faut
# dans ces fichiers. 

## Automagic funcs
#
# Fonctions ex�cut�es automatiquement sous certaines conditions
#
# chpwd		: changement de r�pertoire
# preexec	: avant d'ex�cuter une commande
# precmd	: avant d'afficher le prompt
#

term_title()
{
  [[ -t 1 ]] &&
    case $TERM in
      sun-cmd)
        print -Pn "\e]l%n@%m %~$1\e\\" ;;
      *term*|rxvt*)
	    print -Pn "\e]0;%n@%m (%l) %~$1\a" ;;
    esac
}

preexec ()
{
    term_title " ��� $1"
}

precmd ()
{
##   [[ -t 1 ]] &&
#    print -nP "%(?,,%{[34;1m%}Foirage n�%{[38;1;45m%}%?\n)%{[0m%}"
    term_title

	DATE=$(date "+%H:%M:%S-%d/%m/%Y")
	if [ ! $? -eq 0 ]
	then
		ERROR=$?
	else
		ERROR=
	fi
	HBAR=
	for i in {1..$(($COLUMNS - ${#DATE} - ${#ERROR} - 2))}
	do
		HBAR=$HBAR-
	done

	echo "$c_$BOLD;$MYCOLOR$_c-$c_$COLOR_ERRR$_c$ERROR$c_$MYCOLOR$_c$HBAR$DATE-$c_$VOID$_c"
}

## Le prompt le plus magnifique du monde, et c'est le mien ! 
# Affiche l'user, l'host, le tty et le pwd. Rien que �a... 
# Note que pour le pwd, on n'affiche que les 4 derniers dossiers pour �viter
# de pourrir le fen�tre de terminal avec un prompt � rallonge.
chpwd()
{
    term_title
    which todo > /dev/null 2>&1 && todo

	PS1=""$C_$COLOR_USER$_C"%n"$C_$COLOR_AROB$_C"@"$C_$COLOR_HOST$_C"%m "$C_$COLOR_PAREN$_C"("$C_$COLOR_TERM$_C"%y"$C_$COLOR_PAREN$_C") "$C_$COLOR_BRACES$_C"["$C_$COLOR_PATH$_C"%(!.%d.%(5~:.../:)%4~)"$C_$VOID$_C${$(git branch):+$C_$COLOR_DOUBLEDOT$_C:$C_$COLOR_BRANCH$_C$(git branch | cut -c3-)}$C_$COLOR_BRACES$_C"]"$C_$VOID$_C${LD_PRELOAD:t:s/lib//:r}" "$C_$COLOR_HIST$_C"%h"$C_$COLOR_DIES$_C"%#"$C_$VOID$_C" "
}


# Prompt level 2
PS2="%{[33m%}%B%_%b%{[36m%}%B>%b%{[0m%} "

# Prompt level 3
PS3="?# "

# Prompt level 4
PS4="+%N:%i> "

# Prompt de droite, pour l'heure et le code d'erreur de la derni�re commande
RPS1="%(?;;"$C_$COLOR_ERRR$_C"%?"$C_$VOID$_C")"

# Ultime : prompt de correction :-)
SPROMPT="zsh: $C_$BLUE$_C%B'%R'%b$C_$VOID$_C ? Vous ne vouliez pas plut�t $C_$MAGENTA$_C%B'%r'%b$C_$VOID$_C ? [%BN%byae] "

