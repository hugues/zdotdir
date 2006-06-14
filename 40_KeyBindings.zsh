#!/bin/zsh

## Key bindings
#
# Lancez un chtit bindkey dans votre zsh pour voir... 
#

bindkey "\e[3~" delete-char			# delete
bindkey "\e[2~" overwrite-mode			# insert
bindkey "\e[A" up-line-or-history		# up
bindkey "\e[B" down-line-or-history		# down
bindkey "[A" history-search-backward	# META-up
bindkey "[B" history-search-forward		# META-down
bindkey "\e\e[C" forward-word			# ESC right
bindkey "\e\e[D" backward-word			# ESC left
bindkey "\e\e[3~" kill-region			# ESC del

# Pratique pour rehasher rapidement
bindkey -s "r" "rehash\n"
bindkey -s "R" "rehash\n"

test $TERM = "rxvt" -o $TERM = "xterm" -o $TERM = "aterm" &&
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
# Lancez ``bindkey'' pour en savoir plus !!
bindkey "^A"-"^C" self-insert
bindkey "^D" list-choices
bindkey "^E"-"^F" self-insert
bindkey "^G" list-expand
bindkey "^H" vi-backward-delete-char
bindkey "^I" expand-or-complete
bindkey "^J" accept-line
bindkey "^K" self-insert
bindkey "^L" clear-screen
bindkey "^M" accept-line
bindkey "^N"-"^P" self-insert
bindkey "^Q" vi-quoted-insert
bindkey "^R" redisplay
bindkey "^S"-"^T" self-insert
bindkey "^U" vi-kill-line
bindkey "^V" vi-quoted-insert
bindkey "^W" vi-backward-kill-word
bindkey "^X" self-insert
bindkey "^X^R" _read_comp
bindkey "^X?" _complete_debug
bindkey "^XC" _correct_filename
bindkey "^Xa" _expand_alias
bindkey "^Xc" _correct_word
bindkey "^Xd" _list_expansions
bindkey "^Xe" _expand_word
bindkey "^Xh" _complete_help
bindkey "^Xm" _most_recent_file
bindkey "^Xn" _next_tags
bindkey "^Xt" _complete_tag
bindkey "^X~" _bash_list-choices
bindkey "^Y"-"^Z" self-insert
bindkey "^[" vi-cmd-mode
bindkey "^[^[[3~" kill-region
bindkey "^[^[[A" history-search-backward
bindkey "^[^[[B" history-search-forward
bindkey "^[^[[C" forward-word
bindkey "^[^[[D" backward-word
bindkey "^[," _history-complete-newer
bindkey "^[/" _history-complete-older
bindkey "^[OA" vi-up-line-or-history
bindkey "^[OB" vi-down-line-or-history
bindkey "^[OC" vi-forward-char
bindkey "^[OD" vi-backward-char
bindkey "^[R" "rehash^J"
bindkey "^[[2~" overwrite-mode
bindkey "^[[3~" delete-char
bindkey "^[[A" up-line-or-history
bindkey "^[[B" down-line-or-history
bindkey "^[[C" vi-forward-char
bindkey "^[[D" vi-backward-char
bindkey "^[r" "rehash^J"
bindkey "^[~" _bash_complete-word
bindkey "^\\\\"-"~" self-insert
bindkey "^?" vi-backward-delete-char
bindkey "\M-^@"-"\M-^?" self-insert
