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


## Colors 
autoload colors && colors
c_='['$color[none]";"
_c=m
C_="%{$c_"
_C="$_c%}"

unset has_termcaps
[ $TERM = "rxvt-unicode" -o $TERM = "screen" ] && has_termcaps="true"
T_=${has_termcaps:+$termcap[as]}
_T=${has_termcaps:+$termcap[ae]}
_t_q=${${has_termcaps:+q}:--}
_t_j=${${has_termcaps:+j}:-[}
_t_k=${${has_termcaps:+k}:-[}
_t_l=${${has_termcaps:+l}:-]}
_t_m=${${has_termcaps:+m}:-]}
_t_t=${${has_termcaps:+t}:-]}
_t_u=${${has_termcaps:+u}:-[}
_t_x=${${has_termcaps:+x}:-|}

# I hate kik00l0l colorized prompts, so I'm using a way to
# give a dominant color for each part of the prompt, each of
# these remain still configurable one by one.
# Take a look to set_prompt_colors for these colorizations.
#
# To set the dominant color I'm using this :
#
#  - PS1_ROOT when we are root
#  - PS1_USER for normal usage
#
# I'm storing the resulting dominant color in $prompt_colors[generic]

PS1_ROOT=${PS1_ROOT:-$color[red]}
PS1_USER=${PS1_USER:-$color[blue]}
PS1_YEAH="38;5;82"

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
if [ -w $ZDOTDIR ]
then
	HISTFILE=$ZDOTDIR/.history.$USER.$HOST # Pour éviter les conflits de conf
else
	HISTFILE=~$USER/.zsh.history.$HOST
fi

SAVEHIST=42000
HISTSIZE=$(( $SAVEHIST * 1.10 ))

export GPG_TTY=`tty`

# YeahConsole..
if ( ps x | grep $$ -B1 | grep -q yeahconsole )
then
	YEAHCONSOLE=true
fi

# Display guess
CURRENT_DISPLAY=$(finger 2>&- | tail -n+2 | grep -E $USER'[[:blank:]]+.*[[:blank:]]+tty[0-9][[:blank:]]+($DISPLAY)' | head -n1 | cut -d'(' -f2 | cut -d')' -f1)
if [ "$DISPLAY" = "" -a "$CURRENT_DISPLAY" = "" ]
then
	GUESS_DISPLAY=$(finger 2>&- | tail -n+2 | grep -E $USER'[[:blank:]]+.*[[:blank:]]+tty[0-9]' | head -n1 | cut -d'(' -f2 | cut -d')' -f1)
	if [ "$GUESS_DISPLAY" != "" ]
	then
		export DISPLAY=$GUESS_DISPLAY
	else
		unset DISPLAY
	fi
fi

export COLUMNS
