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

## Prompts
#
# Pour plus d'infos sur les paramètres d'expansion du prompt:
#  man zshmisc(1)
#
# La définition des prompts est séparée de celles desvariables d'environnement
# classiques pour permettre de configurer, par exemple, les couleurs par défaut
# dans ces fichiers. 
# Pour personnaliser les couleurs du prompt, configurez ces variables :
#  - PS1_ROOT pour la couleur du prompt ROOT
#  - PS1_USER pour la couleur du prompt USER local
#  - PS1_USER_SSH pour la couleur du prompt USER distant

#color_red=31
#color_green=32
#color_yellow=33
#color_blue=34
#color_magenta=35
#color_cyan=36

## Couleur par défaut pour le prompt ROOT (c'est super pour sudo, ça...)
PS1_ROOT=${PS1_ROOT:-31}
if ( [ "$SSH_TTY" = "" ] )
then
    # Couleur par défaut pour les utilisateurs normaux (moi, quoi)
	PS1_USER=${PS1_USER:-34}
else
    # Couleur par défaut pour les utilisateurs normaux loggués via SSH
    # Ça permet de faire une distinction rapide entre les shells locaux
    # et les shells distants. C'est trop bon, mangez-en !
	PS1_USER=${PS1_USER_SSH:-35}
fi

## Le prompt le plus magnifique du monde, et c'est le mien ! 
# Affiche l'user, l'host, le tty et le pwd. Rien que ça... 
# Note que pour le pwd, on n'affiche que les 4 derniers dossiers pour éviter
# de pourrir le fenêtre de terminal avec un prompt à rallonge.
PS1="%{[%(!."$PS1_ROOT"."$PS1_USER")m%}%n%{[1;%(!."$PS1_ROOT"."$PS1_USER")m%}@%{[0;%(!."$PS1_ROOT"."$PS1_USER")m%}%m%{[0m%} (%{[36m%}%y%{[0m%}) [%(!.%{["$PS1_ROOT"m%}%d%{[0m%}.%{["$PS1_USER"m%}%(5~:.../:)%4~%{[0m%})]"${LD_PRELOAD:t:s/lib//:r}" %h%{[%(!."$PS1_ROOT";1."$PS1_USER")m%}#%{[0m%} "

# Prompt level 2
PS2="%{[33m%}%B%_%b%{[36m%}%B>%b%{[0m%} "

# Prompt level 3
PS3="?# "

# Prompt level 4
PS4="+%N:%i> "

# Prompt de droite, pour l'heure et le code d'erreur de la dernière commande
RPS1="%(?;;%{[1;32m%}%?%{[0m%}) %{[0;%(!."$PS1_ROOT"."$PS1_USER")m%}%D{%a%d%b|%H:%M\'%S}%{[0m%}"

# Ultime : prompt de correction :-)
SPROMPT="zsh: %{[34m%}%BÂ«%RÂ»%b%{[0m%} ? Vous ne vouliez pas plutÃ´t %{[35m%}%BÂ«%rÂ»%b%{[0m%} ? [%BN%byae] "

