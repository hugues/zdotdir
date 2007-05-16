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

## Options pour ``bc''
export BC_ENV_ARGS="-q"

## Editeur par défaut
export EDITOR=`which vim || which vi || which emacs`
export VISUAL=$EDITOR
export FCEDIT=$EDITOR

## Pageur par défaut
export PAGER=less

## Quelle commande utiliser par défaut ?
export NULLCMD=cat

cmd_exists dircolors && eval $(dircolors ~/.dir_colors)
export TZ="Europe/Paris"
export TIME_STYLE="+%Y-%b-%d %H:%M:%S"

## Agent de clefs SSH/GPG
# En principe il a été fait dans le .zlogin, mais si on n'est pas en
# login shell on n'aura pas ces informations. Donc on le fait ici aussi.
[ -f $ZDOTDIR/.keychain ] && source $ZDOTDIR/.keychain

# Locale en français unicode
export LC_ALL=${LC_ALL:-fr_FR.UTF-8}
export LC_MESSAGES=${LC_MESSAGES:-fr_FR}
unset LANG # Unuseful

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
## Nettoyage des précédentes variables pour supprimer les duplicata
typeset -gU PATH MANPATH INFOPATH PKG_CONFIG_PATH LD_LIBRARY_PATH

##  Trucs à la con spécifiques à Zsh
LOGCHECK=10							# %n has logged on/off ..
REPORTTIME=1							# ``time'' automatique
TIMEFMT='`%J` -- %P cpu
   User	%U
 System	%S
  Total	%E'

WATCHFMT=$COLOR_BLUECLAIR"%n"$COLOR_END
WATCHFMT=$WATCHFMT" has "$COLOR_YELLOW"%a[0m %l from %M"
WATCH=notme

WORDCHARS='*?-_~!#$%^.' ## Caractères faisant partie des mots
                        ## J'ai viré les  '/()[]{}'

## Gestion de l'historique
# Voir le fichier d'Options pour plus de contrôle là-dessus
HISTFILE=$ZDOTDIR/.history.$USER.$HOSTNAME # Pour éviter les conflits de conf
HISTSIZE=42000
SAVEHIST=42000
