#!/bin/zsh

export BC_ENV_ARGS="-q"
export EDITOR=${EDITOR:-vim}
export HISTFILE=".zsh/.history.zsh"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/libs
eval $(dircolors ~/.dir_colors 2>&-)
export PATH=$PATH:~/sbin:~/bin
export PKG_CONFIG_PATH=/usr/X11R6/lib/pkgconfig
export TIME_STYLE="+%Y-%b-%d %H:%M"
export TZ="Europe/Paris"
source $ZDOTDIR/.keychain
# Set locales only if they are undefined
export LC_ALL=${LC_ALL:-fr_FR.UTF-8}
export LC_MESSAGES=${LC_MESSAGES:-fr_FR}
export MANPATH=$MANPATH:~/man
export NULLCMD=cat
unset LANG # Unuseful

##
##  basic setup
##
LOGCHECK=13
WATCHFMT=$COLOR_BLUECLAIR"%n"$COLOR_END
WATCHFMT=$WATCHFMT" has "$COLOR_YELLOW"%a[0m %l from %M"
WATCH=notme
WORDCHARS="*?-._[]~=&;!#$%^(){}<>"	# I suppressed the '/'

HISTFILE=$ZDOTDIR/.history
HISTSIZE=42000
SAVEHIST=42000

##
## Prompts
##
#  For more info on PROMPT expansion, see 'man zshmisc'
##

PS1_ROOT=${PS1_ROOT:-31}
if ( [ "$SSH_TTY" = "" ] )
then
	PS1_USER=${PS1_USER:-34}
else
	PS1_USER=${PS1_USER_SSH:-35}
fi

PS1="%{[%(!."$PS1_ROOT"."$PS1_USER")m%}%n%{[1;%(!."$PS1_ROOT"."$PS1_USER")m%}@%{[0;%(!."$PS1_ROOT"."$PS1_USER")m%}%m%{[0m%} (%{[36m%}%y%{[0m%}) [%(!.%{["$PS1_ROOT"m%}%d%{[0m%}.%{["$PS1_USER"m%}%(5~:.../:)%4~%{[0m%})]"${LD_PRELOAD:t:s/lib//:r}" %h%{[%(!."$PS1_ROOT";1."$PS1_USER")m%}#%{[0m%} "

RPS1="%(?;;%{[1;32m%}%?%{[0m%}) %{[0;%(!."$PS1_ROOT"."$PS1_USER")m%}%D{%a%d%b|%H:%M'%S}%{[0m%}"

PS2="%{[33m%}%B%_%b%{[36m%}%B>%b%{[0m%} "

SPROMPT="zsh: %{[34m%}%B«%R»%b%{[0m%} ? Ce ne serait pas plutôt %{[35m%}%B«%r»%b%{[0m%} ? [nyae] "

##
# PS3="?# "
# 
# PS4="+%N:%i> "
##


#TIMEFMT="\`%J': %U user %S system %*E total (%P cpu)"
