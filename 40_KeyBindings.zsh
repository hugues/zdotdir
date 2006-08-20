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

## Key bindings
#
# Lancez un chtit bindkey dans votre zsh pour voir... 
#

bindkey "[3~" delete-char			# delete
bindkey "[2~" overwrite-mode			# insert
bindkey "[A" up-line-or-history		# up
bindkey "[B" down-line-or-history		# down
bindkey "[A" history-search-backward	# META-up
bindkey "[B" history-search-forward		# META-down
bindkey "[C" forward-word			# ESC right
bindkey "[D" backward-word			# ESC left
bindkey "[3~" kill-region			# ESC del

# Pratique pour rehasher rapidement
bindkey -s "r" "  rehash\n"
# Exécute la commande ``rt'' qui me permet de nettoyer toutes les saletés
bindkey -s "R" "  rt\n"

test $TERM = "rxvt" -o $TERM = "xterm" -o $TERM = "aterm" &&
{
    bindkey "[1~" beginning-of-line	# home
    bindkey "[4~" end-of-line		# end-of-line
    bindkey "Oc" forward-word		# CTRL right
    bindkey "Od" backward-word	# CTRL left
    bindkey "[3$" vi-set-buffer		# SHIFT del
    bindkey "Oa" history-search-backward	# CTRL UP
    bindkey "Ob" history-search-forward	# CTRL DOWN
}
# (gnome-terminal)
test $TERM = "xterm" &&
{
    bindkey "OH" beginning-of-line	# home
    bindkey "OF" end-of-line		# end-of-line
}
#bindkey "\C-t" gosmacs-transpose-chars	# J, ca c'est un truc pour toi
# ne pas oublier de s'en servir :
# vi-match-bracket est sur ^X^B par defaut
# npo : quote-region est sur ESC-" par defaut
# npo : which-command est sur ESC-? par defaut
# Lancez ``bindkey'' pour en savoir plus !!

