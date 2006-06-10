#!/bin/zsh
##
## bindkey
##

bindkey "\e[3~" delete-char			# delete
bindkey "\e[2~" overwrite-mode			# insert
bindkey "\e[A" up-line-or-history		# up
bindkey "\e[B" down-line-or-history		# down
bindkey "[A" history-search-backward	# META-up
bindkey "[B" history-search-forward		# META-down
bindkey "\e\e[C" forward-word			# ESC right
bindkey "\e\e[D" backward-word			# ESC left
bindkey "\e\e[3~" kill-region			# ESC del

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
test $TERM = "xterm" &&
{
    bindkey "\eOH" beginning-of-line	# home
    bindkey "\eOF" end-of-line		# end-of-line
}
#bindkey "\C-t" gosmacs-transpose-chars	# J, ca c'est un truc pour toi
# ne pas oublier de s'en servir :
# vi-match-bracket est sur ^X^B par defaut
# npo : quote-region est sur ESC-" par defaut
# npo : which-command est sur ESC-? par defaut

