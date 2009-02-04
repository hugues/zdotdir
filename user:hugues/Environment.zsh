##
## Part of configuration files for Zsh4
## AUTHOR: Hugues Hiegel <hugues@hiegel.fr>
## 
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##

## Options pour ``bc''
# pour ne plus avoir
# le message d'invite
# au démarrage
export BC_ENV_ARGS="-q"

## Editeur par défaut
export EDITOR=`which vim || which vi || which emacs`
export VISUAL=$EDITOR
export FCEDIT=$EDITOR

## Pageur par défaut
export PAGER=less
export LESS="-R -F -X"

## Quelle commande utiliser par défaut ?
export NULLCMD=cat

# Locale en français unicode
export LC_ALL=${LC_ALL:-fr_FR.UTF-8}
export LC_MESSAGES=${LC_MESSAGES:-fr_FR}
unset LANG # Unuseful

# Couleurs pour grep --color=auto
export GREP_COLOR=$color[yellow]\;$color[bold]

cmd_exists dircolors && eval $(dircolors ~/.dir_colors)
export TZ="Europe/Paris"
export TIME_STYLE="+%Y-%b-%d %H:%M:%S"

export LS_OPTIONS="-F --color=always"

##  Trucs à la con spécifiques à Zsh
LOGCHECK=10                             # %n has logged on/off ..
REPORTTIME=1                            # ``time'' automatique
TIMEFMT='`%J` -- %P cpu
   User	%U
 System	%S
  Total	%E'

KEYTIMEOUT=1 # 0.01s

WATCHFMT=$c_$color[bold]$_c"%n"$c_$color[none]$_c" has "$c_$color[bold]$_c"%a"$c_$color[none]$_c" %l from %M"
WATCH=notme

WORDCHARS='*?-_~!#$%^' ## Caractères faisant partie des mots
                        ## J'ai viré les  '/()[]{}'

MUSICPLAYER=audacious
