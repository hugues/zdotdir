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

export SHELL=`which zsh`

## Agent de clefs SSH/GPG
if [ "$SUDO_USER" = "" ]
then
	KEYCHAIN=~/.keychain/$(hostname)-sh
	cmd_exists keychain && keychain --quiet
	[ -f ${KEYCHAIN}     ] && source ${KEYCHAIN}
	[ -f ${KEYCHAIN}-gpg ] && source ${KEYCHAIN}-gpg
fi

## Colors 
autoload colors && colors
c_='['$color[none]";"
_c=m
C_="%{$c_"
_C="$_c%}"

## Termcaps ###########################

# Activates the alternate charset
echo $termcap[eA]

typeset -A chars

chars['-']="$termcap[as]q$termcap[ae]"
chars['|']="$termcap[as]x$termcap[ae]"

chars[lr]="$termcap[as]j$termcap[ae]"
chars[ur]="$termcap[as]k$termcap[ae]"
chars[ul]="$termcap[as]l$termcap[ae]"
chars[ll]="$termcap[as]m$termcap[ae]"

chars['+']="$termcap[as]n$termcap[ae]"

chars[lT]="$termcap[as]t$termcap[ae]"
chars[rT]="$termcap[as]u$termcap[ae]"
chars[bT]="$termcap[as]v$termcap[ae]"
chars[tT]="$termcap[as]w$termcap[ae]"


## Variables d'environnement ``classiques''
#
# L'utilisation de la forme ${VARIABLE:+$VARIABLE:} permet d'accoler ``:''
# si et seulement si $VARIABLE contient déjà des choses, cela pour éviter
# d'avoir un PATH (p.e.) de la forme : PATH=:/bin
#
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:~/libs
#export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/X11R6/lib/pkgconfig
export PATH=$PATH:~/sbin:~/local/bin
privileged_user && PATH=/sbin:/usr/sbin:$PATH
export MANPATH=$MANPATH:~/man:~/local/share/man
export INFOPATH=$INFOPATH:~/info:~/local/share/info
[ "$DEBUG" = "yes" ] && export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}~/libs
[ "$DEBUG" = "yes" ] && export PKG_CONFIG_PATH=${PKG_CONFIG_PATH:+$PKG_CONFIG_PATH:}~/pkgconfig

## Nettoyage des précédentes variables pour supprimer les duplicata
typeset -gU PATH MANPATH INFOPATH PKG_CONFIG_PATH LD_LIBRARY_PATH

## Gestion de l'historique
# Voir le fichier d'Options pour plus de contrôle là-dessus
HISTFILE=$ZDOTDIR/.history.$USER.$HOSTNAME # Pour éviter les conflits de conf
HISTSIZE=42000
SAVEHIST=42000


