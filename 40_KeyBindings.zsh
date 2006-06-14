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
"^A"-"^C" self-insert
"^D" list-choices
"^E"-"^F" self-insert
"^G" list-expand
"^H" vi-backward-delete-char
"^I" expand-or-complete
"^J" accept-line
"^K" self-insert
"^L" clear-screen
"^M" accept-line
"^N"-"^P" self-insert
"^Q" vi-quoted-insert
"^R" redisplay
"^S"-"^T" self-insert
"^U" vi-kill-line
"^V" vi-quoted-insert
"^W" vi-backward-kill-word
"^X" self-insert
"^X^R" _read_comp
"^X?" _complete_debug
"^XC" _correct_filename
"^Xa" _expand_alias
"^Xc" _correct_word
"^Xd" _list_expansions
"^Xe" _expand_word
"^Xh" _complete_help
"^Xm" _most_recent_file
"^Xn" _next_tags
"^Xt" _complete_tag
"^X~" _bash_list-choices
"^Y"-"^Z" self-insert
"^[" vi-cmd-mode
"^[^[[3~" kill-region
"^[^[[A" history-search-backward
"^[^[[B" history-search-forward
"^[^[[C" forward-word
"^[^[[D" backward-word
"^[," _history-complete-newer
"^[/" _history-complete-older
"^[OA" vi-up-line-or-history
"^[OB" vi-down-line-or-history
"^[OC" vi-forward-char
"^[OD" vi-backward-char
"^[R" "rehash^J"
"^[[2~" overwrite-mode
"^[[3~" delete-char
"^[[A" up-line-or-history
"^[[B" down-line-or-history
"^[[C" vi-forward-char
"^[[D" vi-backward-char
"^[r" "rehash^J"
"^[~" _bash_complete-word
"^\\\\"-"~" self-insert
"^?" vi-backward-delete-char
"\M-^@"-"\M-^?" self-insert
