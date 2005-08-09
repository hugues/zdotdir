## No more core dumps :)
ulimit -c 0
umask 077

export BC_ENV_ARGS="-q"

##chmod 700 ~/tmp
##find ~ \( -name '#*#' -o -name '.*~' -o -name '*~' \) -exec rm -f {} \;

##
## exports && aliases
##

if [ -f ~/.zsh/.exports.zsh ]; then
    source ~/.zsh/.exports.zsh
fi

if [ -f ~/.zsh/.aliases.zsh ]; then
    source ~/.zsh/.aliases.zsh
fi


##
##  sanity
##
[[ -t 0 ]] && /bin/stty erase  "^H" intr  "^C" susp "^Z" dsusp "^Y" stop "^S" start "^Q" kill "^U"  >& /dev/null


case $SHLVL in
    *2)	CLR_SHLVL="%{[33m%}";;
    *3)	CLR_SHLVL="%{[32m%}";;
    *4)	CLR_SHLVL="%{[31m%}";;
    *5)	CLR_SHLVL="%{[34m%}";;
    *6)	CLR_SHLVL="%{[35m%}";;
esac


##
##  basic setup
##
LOGCHECK=13
WATCHFMT=$COLOR_BLUECLAIR"%n"$COLOR_END
WATCHFMT=$WATCHFMT" has "$COLOR_YELLOW"%a[0m %l from %M"
WATCH=notme
NULLCMD="less -f"
WORDCHARS="*?-._[]~=&;!#$%^(){}<>"	# I suppressed the '/'
TIMEFMT="\`%J': %U user %S system %*E total (%P cpu)"

HISTFILE=$ZDOTDIR/.history
HISTSIZE=42000
SAVEHIST=42000

##
## Prompts
##
#  For more info on PROMPT expansion, see 'man zshmisc'
##

C_ROOT="31"
if ( [ "$SSH_TTY" = "" ] )
then
	C_USER="34"
else
	C_USER="35"
fi

PS1="%{[%(!."$C_ROOT"."$C_USER")m%}%n%{[1;%(!."$C_ROOT"."$C_USER")m%}@%{[0;%(!."$C_ROOT"."$C_USER")m%}%m%{[0m%} (%{[36m%}%y%{[0m%}) [%(!.%{["$C_ROOT"m%}%d%{[0m%}.%{["$C_USER"m%}%(5~:../:)%4~%{[0m%})]"${LD_PRELOAD:t:s/lib//:r}" %h%{[%(!."$C_ROOT";1."$C_USER")m%}#%{[0m%} "

RPS1="%(?;;%{[1;32m%}%?%{[0m%}) %{[0;%(!."$C_ROOT"."$C_USER")m%}%D{%a%d%b|%H:%M'%S}%{[0m%}"

PS2="%{[33m%}%B%_%b%{[36m%}%B>%b%{[0m%} "

SPROMPT="zsh: %{[34m%}%B«%R»%b%{[0m%} ? Ce ne serait pas plutôt %{[35m%}%B«%r»%b%{[0m%} ? [nyae] "

##
# PS3="?# "
# 
# PS4="+%N:%i> "
##


##
## Options
##
setopt correct
#setopt correctall
setopt inc_append_history
setopt histignorealldups
setopt histexpiredupsfirst
setopt alwayslastprompt
setopt always_to_end
setopt auto_cd
setopt _auto_list
setopt auto_menu
setopt auto_param_keys
#setopt auto_param_slash
setopt no_bg_nice
setopt complete_aliases
setopt hash_cmds
setopt hash_dirs
setopt no_hup
setopt mail_warning
setopt magic_equal_subst
setopt numericglobsort
setopt mark_dirs
setopt no_prompt_cr
#setopt equals
#setopt extended_glob
unsetopt promptcr

##
## bindkey
##

bindkey "\e[3~" delete-char		# delete
bindkey "\e[2~" overwrite-mode		# insert
bindkey "\e[A" up-line-or-history	# up
bindkey "\e[B" down-line-or-history	# down
bindkey "\e\e[C" forward-word		# ESC right
bindkey "\e\e[D" backward-word		# ESC left
bindkey "\e[5~" up-line-or-history	# page up	# c'est ultime
bindkey "\e[6~" down-line-or-history	# page down
bindkey "\e\e[3~" kill-region		# ESC del
#aterm
test $TERM = "rxvt" -o $TERM = "xterm" &&
{
    bindkey "\e[1~" beginning-of-line	# home
    bindkey "\e[4~" end-of-line		# end-of-line
    bindkey "\eOc" forward-word		# CTRL right
    bindkey "\eOd" backward-word	# CTRL left
    bindkey "\e[3$" vi-set-buffer		# SHIFT del
    bindkey "\eOa" history-search-backward	# CTRL UP
    bindkey "\eOb" history-search-forward	# CTRL DOWN
}
# (gnome-terminal)
#test $TERM = "xterm" &&
#{
#    bindkey "\eOH" beginning-of-line	# home
#    bindkey "\eOF" end-of-line		# end-of-line
#}
#bindkey "\C-t" gosmacs-transpose-chars	# J, ca c'est un truc pour toi
# ne pas oublier de s'en servir :
# vi-match-bracket est sur ^X^B par defaut
# npo : quote-region est sur ESC-" par defaut
# npo : which-command est sur ESC-? par defaut


##
## functions
##
##[[ -t 1 ]] &&
chpwd()
{
    case $TERM in
      sun-cmd) print -Pn "\e]l%n@%m %~\e\\" ;;
      *xterm*|rxvt|(k|E|dt)term|gnome-terminal) print -Pn "\e]0;%n@%m (%l) %~\a" ;;
    esac
#    print -P "%(/,%78>...>%/,%//)%b"
}

precmd ()
{
#    print -nP "%(?,,%{[35;1m%}Foirage n°%{[38;1;45m%}%?\n)%{[0m%}"
}

##
## misc commands
##
chpwd
#(/bin/rm -f ~/.saves-*) 2>/dev/null

