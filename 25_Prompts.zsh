#!/bin/zsh
##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@nullpart.net>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

# Pour personnaliser les couleurs du prompt, configurez ces variables :
#  - PS1_ROOT pour la couleur du prompt ROOT
#  - PS1_USER pour la couleur du prompt USER local
#  - PS1_USER_SSH pour la couleur du prompt USER distant

C_="%{["
_C="m%}"

COLOR_RSET=0
COLOR_BOLD=1
COLOR_LINE=4
COLOR_RED=31
COLOR_GREEN=32
COLOR_YELLOW=33
COLOR_BLUE=34
COLOR_MAGENTA=35
COLOR_CYAN=36

## Couleur par défaut pour le prompt ROOT (c'est super pour sudo, ça...)
PS1_ROOT=${PS1_ROOT:-$COLOR_RED}

# Couleur par défaut pour les utilisateurs normaux (moi, quoi)
PS1_USER=${PS1_USER:-$COLOR_BLUE}
PS1_USER_SSH=${PS1_USER_SSH:-$COLOR_MAGENTA}

if ( [ "$SSH_TTY" != "" ] )
then
    # Couleur par défaut pour les utilisateurs normaux loggués via SSH
    # Ça permet de faire une distinction rapide entre les shells locaux
    # et les shells distants. C'est trop bon, mangez-en !
    PS1_USER=${PS1_USER_SSH:-$PS1_USER}
fi

PS1_COLOR="%(!.$PS1_ROOT.$PS1_USER)"

# COULEURS DU PROMPT
# La classe.

PATHCOLOR="$C_$COLOR_RSET;$PS1_COLOR$_C"
USERCOLOR="$C_$COLOR_RSET;$PS1_COLOR$_C"
HOSTCOLOR="$C_$COLOR_RSET;$PS1_COLOR$_C"
TERMCOLOR="$C_$COLOR_RSET;$COLOR_CYAN$_C"
ERRRCOLOR="$C_$COLOR_RED$_C"
RESET="$C_$COLOR_RSET$_C"
MISC="$C_$COLOR_RSET;$COLOR_BOLD;$PS1_COLOR$_C"


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
PS1=$USERCOLOR"%n"$MISC"@"$HOSTCOLOR"%m"$RESET" ("$TERMCOLOR"%y"$RESET") ["$PATHCOLOR"%(!.%d.%(5~:.../:%4~))"$RESET"]"${LD_PRELOAD:t:s/lib//:r}" %h"$MISC"#"$RESET" "

# Prompt level 2
PS2="%{[33m%}%B%_%b%{[36m%}%B>%b%{[0m%} "

# Prompt level 3
PS3="?# "

# Prompt level 4
PS4="+%N:%i> "

# Prompt de droite, pour l'heure et le code d'erreur de la dernière commande
RPS1="%(?..$ERRRCOLOR%?$COLOR_RSET) %{[0;%(!."$PS1_ROOT"."$PS1_USER")m%}%D{%a%d%b|%H:%M\'%S}%{[0m%}"

# Ultime : prompt de correction :-)
SPROMPT="zsh: %{[34m%}%B«%R»%b%{[0m%} ? Vous ne vouliez pas plutôt %{[35m%}%B«%r»%b%{[0m%} ? [%BN%byae] "

