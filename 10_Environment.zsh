##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

##
## NDLA: 
##
## ma politique pour l'export des variables est très simple :
## si elle a pour vocation d'être utilisée en dehors de Zsh,
## on l'exporte. SInon pas. 
##

## Agent de clefs SSH/GPG
KEYCHAIN=~/.keychain/$(hostname)-sh
[ -f ${KEYCHAIN}     ] && source ${KEYCHAIN}
[ -f ${KEYCHAIN}-gpg ] && source ${KEYCHAIN}-gpg
( ps fax | grep -v grep | grep $SSH_AGENT_PID 2>&- >&- ) || ( cmd_exists keychain && keychain --quiet --stop others --inherit any ) && \
	[ -f ${KEYCHAIN}     ] && source ${KEYCHAIN} ;\
	[ -f ${KEYCHAIN}-gpg ] && source ${KEYCHAIN}-gpg

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

## Variables d'environnement ``classiques''
#
# L'utilisation de la forme ${VARIABLE:+$VARIABLE:} permet d'accoler ``:''
# si et seulement si $VARIABLE contient déjà des choses, cela pour éviter
# d'avoir un PATH (p.e.) de la forme : PATH=:/bin
#
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:~/libs
#export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/X11R6/lib/pkgconfig
export PATH=$PATH:~/sbin:~/bin
privileged_user && PATH=/sbin:/usr/sbin:$PATH
export MANPATH=$MANPATH:~/man
export INFOPATH=$INFOPATH:~/info
[ "$DEBUG" = "yes" ] && export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}~/libs
[ "$DEBUG" = "yes" ] && export PKG_CONFIG_PATH=${PKG_CONFIG_PATH:+$PKG_CONFIG_PATH:}~/pkgconfig
## Nettoyage des précédentes variables pour supprimer les duplicata
typeset -gU PATH MANPATH INFOPATH PKG_CONFIG_PATH LD_LIBRARY_PATH

## Gestion de l'historique
# Voir le fichier d'Options pour plus de contrôle là-dessus
HISTFILE=$ZDOTDIR/.history.$USER.$HOSTNAME # Pour éviter les conflits de conf
HISTSIZE=42000
SAVEHIST=42000


