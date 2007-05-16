##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

VOID=0
BOLD=1
UNDERLINE=4
RED=31
GREEN=32
YELLOW=33
BLUE=34
MAGENTA=35
CYAN=36
WHITE=37

# Pour personnaliser les couleurs du prompt, configurez ces variables :
#  - PS1_ROOT pour la couleur du prompt ROOT
#  - PS1_USER pour la couleur du prompt USER local
#  - PS1_USER_SSH pour la couleur du prompt USER distant

PS1_ROOT=$RED
PS1_USER=$BLUE
PS1_USER_SSH=$MAGENTA

if ( [ "$SSH_TTY" != "" ] )
then
    # Couleur par défaut pour les utilisateurs normaux loggués via SSH
    # Ça permet de faire une distinction rapide entre les shells locaux
    # et les shells distants. C'est trop bon, mangez-en !
    PS1_USER=${PS1_USER_SSH:-$PS1_USER}
fi

## Les couleurs !! ##
C_="%{["
_C="m%}"
COLOR_PATH="0;%(!.$PS1_ROOT.$BOLD;$PS1_USER)"
COLOR_TERM="0;%(!.$PS1_ROOT.$PS1_USER)"
COLOR_USER="0;%(!.$PS1_ROOT.$PS1_USER)"
COLOR_HOST="0;%(!.$PS1_ROOT.$PS1_USER)"
COLOR_HIST=$VOID
COLOR_AROB="0;1;%(!.$BOLD;$PS1_ROOT.$PS1_USER)"
COLOR_DIES="0;%(!.$BOLD;$PS1_ROOT.$PS1_USER)"

COLOR_ERRR="$BOLD;$RED"
COLOR_DATE="0;%(!.$PS1_ROOT.$PS1_USER)"

## Prompts
#
# Pour plus d'infos sur les paramètres d'expansion du prompt:
#  man zshmisc(1)
#
# La définition des prompts est séparée de celles desvariables d'environnement
# classiques pour permettre de configurer, par exemple, les couleurs par défaut
# dans ces fichiers. 

## Le prompt le plus magnifique du monde, et c'est le mien ! 
# Affiche l'user, l'host, le tty et le pwd. Rien que ça... 
# Note que pour le pwd, on n'affiche que les 4 derniers dossiers pour éviter
# de pourrir le fenêtre de terminal avec un prompt à rallonge.
PS1=""$C_$COLOR_USER$_C"%n"$C_$COLOR_AROB$_C"@"$C_$COLOR_HOST$_C"%m"$C_$VOID$_C" ("$C_$COLOR_TERM$_C"%y"$C_$VOID$_C") ["$C_$COLOR_PATH$_C"%(!.%d.%(5~:.../:)%4~)"$C_$VOID$_C"]"${LD_PRELOAD:t:s/lib//:r}" "$C_$COLOR_HIST$_C"%h"$C_$COLOR_DIES$_C"%#"$C_$VOID$_C" "

# Prompt level 2
PS2="%{[33m%}%B%_%b%{[36m%}%B>%b%{[0m%} "

# Prompt level 3
PS3="?# "

# Prompt level 4
PS4="+%N:%i> "

# Prompt de droite, pour l'heure et le code d'erreur de la dernière commande
RPS1="%(?;;"$C_$COLOR_ERRR$_C"%?"$C_$VOID$_C") "$C_$COLOR_DATE$_C"%D{%H:%M:%S %d/%m/%Y}"$C_$VOID$_C""

# Ultime : prompt de correction :-)
SPROMPT="zsh: $C_$BLUE$_C%B'%R'%b$C_$VOID$_C ? Vous ne vouliez pas plutôt $C_$MAGENTA$_C%B'%r'%b$C_$VOID$_C ? [%BN%byae] "

