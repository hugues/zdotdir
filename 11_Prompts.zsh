##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

## Colors 

VOID=0
BOLD=1
UNDERLINE=4
color=0
for COLOR in BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE
do
	eval    $COLOR=$[ $color + 30 ]
	eval BG_$COLOR=$[ $color + 40 ]
    color=$[ $color + 1 ]
done
unset color

# Pour personnaliser les couleurs du prompt, configurez ces variables :
#  - PS1_ROOT pour la couleur du prompt ROOT
#  - PS1_USER pour la couleur du prompt USER local
#  - PS1_USER_SSH pour la couleur du prompt USER distant (en ssh)

PS1_ROOT=${PS1_ROOT:-$RED}
PS1_USER=${PS1_USER:-$BLUE}
PS1_USER_SSH=${PS1_USER_SSH:-$MAGENTA}
GENERIC=$(print -Pn "%(! $PS1_ROOT $PS1_USER)")

if ( [ "$SSH_TTY" != "" ] )
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
COLOR_PATH="0;%(!  $BOLD;)$GENERIC"
COLOR_TERM="0;$GENERIC"
COLOR_USER="0;$GENERIC"
COLOR_HOST="0;$GENERIC"
COLOR_HIST=$VOID
COLOR_AROB="0;1;%(! $BOLD; )$GENERIC"
COLOR_DIES="0;%(! $BOLD; )"
COLOR_DOUBLEDOT="0;%(! $VOID $GENERIC)"
COLOR_BRANCH="0;%(! $BOLD; )$GENERIC"
COLOR_BRACES="0;$CYAN"
COLOR_PAREN="0;$CYAN"
COLOR_BAR="0;$GENERIC;$BOLD"

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
    term_title " ··· $1"
}

precmd ()
{
    term_title

	DATE=$(date "+%H:%M:%S-%d/%m/%Y")
	ERROR='%?'
	HBAR=
	for i in {1..$(($COLUMNS - ${#DATE} - 3 - 2))}
	do
		HBAR=$HBAR-
	done

## Le prompt le plus magnifique du monde, et c'est le mien ! 
# Affiche l'user, l'host, le tty et le pwd. Rien que ça... 
# Note que pour le pwd, on n'affiche que les 4 derniers dossiers pour éviter
# de pourrir le fenêtre de terminal avec un prompt à rallonge.
	PS1=$C_$COLOR_BAR$_C"-"%(? "---" $C_$COLOR_ERRR$_C"%3>>%?$C_$COLOR_BAR$_C---%>>")$C_$COLOR_BAR$_C$HBAR$C_$COLOR_DATE$_C$DATE$C_$COLOR_BAR$_C"-
"$C_$COLOR_USER$_C"%n"$C_$COLOR_AROB$_C"@"$C_$COLOR_HOST$_C"%m "$C_$COLOR_PAREN$_C"("$C_$COLOR_TERM$_C"%y"$C_$COLOR_PAREN$_C") "$C_$COLOR_BRACES$_C"["$C_$COLOR_PATH$_C"%(!.%d.%(5~:.../:)%4~)"$C_$VOID$_C${$(git branch 2>&-):+$C_$COLOR_DOUBLEDOT$_C:$C_$COLOR_BRANCH$_C$(git branch | cut -c3-)}$C_$COLOR_BRACES$_C"]"$C_$VOID$_C${LD_PRELOAD:t:s/lib//:r}" "$C_$COLOR_HIST$_C"%h"$C_$COLOR_DIES$_C"%#"$C_$VOID$_C" "
}

chpwd()
{
    term_title
    which todo > /dev/null 2>&1 && todo
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

