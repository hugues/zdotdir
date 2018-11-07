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
## on l'exporte. Sinon pas.
##

export SHELL=`which zsh`


## Colors 
autoload colors && colors
c_='['$color[none]";"
_c=m
C_="%{$c_"
_C="$_c%}"

unset _has_tcaps
case "$( _process_tree )" in
	*":: SCREEN ::"*)
		# Discards termcaps even if screen is launched from an urxvt..
		;;
	*":: "*"urxvt ::"*|\
	*":: tmux ::"*)
		has_termcaps=${has_termcaps:-true}
		;;
	*)
		;;
esac
_has_tcaps="${has_termcaps}"
[ "${_has_tcaps}" != "true" ] && unset _has_tcaps

T_=${_has_tcaps:+$termcap[as]}
_T=${_has_tcaps:+$termcap[ae]}
_tq_=${${_has_tcaps:+"q"}:-"-"}
_tj_=${${_has_tcaps:+"j"}:-"'"}
_tk_=${${_has_tcaps:+"k"}:-"."}
_tl_=${${_has_tcaps:+"l"}:-","}
_tm_=${${_has_tcaps:+"m"}:-"\`"}
_tt_=${${_has_tcaps:+"t"}:-"]"}
_tu_=${${_has_tcaps:+"u"}:-"["}
_tx_=${${_has_tcaps:+"x"}:-"|"}
# Not needed anymore
unset _has_tcaps

# I hate kik00l0l colorized prompts, so I'm using a way to
# give a dominant color for each part of the prompt, each of
# these remain still configurable one by one.
# Take a look to _set_prompt_colors (01_Internals) for these colorizations.
#
# To set the dominant color I'm using this :
#
#  - PS1_ROOT when we are root
#  - PS1_USER for normal usage
#
# I'm storing the resulting dominant color in $_prompt_colors[generic]

PS1_ROOT=${PS1_ROOT:-$color[red]}
PS1_USER=${PS1_USER:-$color[blue]}
# Specific color for YeahConsole
PS1_YEAH="38;5;124"

## Variables d'environnement ``classiques''
#
# L'utilisation de la forme ${VARIABLE:+$VARIABLE:} permet d'accoler ``:''
# si et seulement si $VARIABLE contient déjà des choses, cela pour éviter
# d'avoir un PATH (p.e.) de la forme : PATH=:/bin
#
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:~/libs
#export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/X11R6/lib/pkgconfig
export PATH=$PATH:~/sbin:~/local/bin
PATH=/sbin:/usr/sbin:$PATH
export MANPATH=~/man:~/local/share/man:/usr/local/share/man:$MANPATH
export INFOPATH=~/info:~/local/share/info:/usr/local/share/info:$INFOPATH
[ "$DEBUG" = "yes" ] && export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}~/libs
[ "$DEBUG" = "yes" ] && export PKG_CONFIG_PATH=${PKG_CONFIG_PATH:+$PKG_CONFIG_PATH:}~/pkgconfig

## Nettoyage des précédentes variables pour supprimer les duplicata
typeset -gU PATH MANPATH INFOPATH PKG_CONFIG_PATH LD_LIBRARY_PATH

## Gestion de l'historique
# Voir le fichier d'Options pour plus de contrôle là-dessus
HISTFILE=~$USER/.zsh.history.$HOST

SAVEHIST=42000
HISTSIZE=$(( $SAVEHIST * 1.10 ))

export GPG_TTY=`tty`

# YeahConsole..
if ( ps 2>&- | grep $$ -B1 | grep -q yeahconsole )
then
	_yeahconsole=true
else
	_yeahconsole=false
fi

# Display guess
_current_display=$(finger 2>&- | tail -n+2 | grep -E $USER'[[:blank:]]+.*[[:blank:]]+tty[0-9][[:blank:]]+($DISPLAY)' | head -n1 | cut -d'(' -f2 | cut -d')' -f1)
if [ "$DISPLAY" = "" -a "$_current_display" = "" ]
then
	_guess_display=$(finger 2>&- | tail -n+2 | grep -E $USER'[[:blank:]]+.*[[:blank:]]+tty[0-9]' | head -n1 | cut -d'(' -f2 | cut -d')' -f1)
	if [ "$_guess_display" != "" ]
	then
		export DISPLAY=$_guess_display
	else
		unset DISPLAY
	fi
fi

