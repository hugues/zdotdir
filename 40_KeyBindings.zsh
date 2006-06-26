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
bindkey -s "r" " rehash\n"
bindkey -s "R" " rehash\n"

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

## Résultat d'un ``bindkey''

bindkey "^@" set-mark-command
bindkey "^A" beginning-of-line
bindkey "^B" backward-char
bindkey "^D" delete-char-or-list
bindkey "^E" end-of-line
bindkey "^F" forward-char
bindkey "^G" send-break
bindkey "^H" backward-delete-char
bindkey "^I" expand-or-complete
bindkey "^J" accept-line
bindkey "^K" kill-line
bindkey "^L" clear-screen
bindkey "^M" accept-line
bindkey "^N" down-line-or-history
bindkey "^O" accept-line-and-down-history
bindkey "^P" up-line-or-history
bindkey "^Q" push-line
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward
bindkey "^T" transpose-chars
bindkey "^U" kill-whole-line
bindkey "^V" quoted-insert
bindkey "^W" backward-kill-word
bindkey "^X^B" vi-match-bracket
bindkey "^X^F" vi-find-next-char
bindkey "^X^J" vi-join
bindkey "^X^K" kill-buffer
bindkey "^X^N" infer-next-history
bindkey "^X^O" overwrite-mode
bindkey "^X^R" _read_comp
bindkey "^X^U" undo
bindkey "^X^V" vi-cmd-mode
bindkey "^X^X" exchange-point-and-mark
bindkey "^X*" expand-word
bindkey "^X=" what-cursor-position
bindkey "^X?" _complete_debug
bindkey "^XC" _correct_filename
bindkey "^XG" list-expand
bindkey "^Xa" _expand_alias
bindkey "^Xc" _correct_word
bindkey "^Xd" _list_expansions
bindkey "^Xe" _expand_word
bindkey "^Xg" list-expand
bindkey "^Xh" _complete_help
bindkey "^Xm" _most_recent_file
bindkey "^Xn" _next_tags
bindkey "^Xr" history-incremental-search-backward
bindkey "^Xs" history-incremental-search-forward
bindkey "^Xt" _complete_tag
bindkey "^Xu" undo
bindkey "^X~" _bash_list-choices
bindkey "^Y" yank
bindkey "^D" list-choices
bindkey "^G" send-break
bindkey "^H" backward-kill-word
bindkey "^I" self-insert-unmeta
bindkey "^J" self-insert-unmeta
bindkey "^L" clear-screen
bindkey "^M" self-insert-unmeta
bindkey "[3~" kill-region
bindkey "[A" history-search-backward
bindkey "[B" history-search-forward
bindkey "[C" forward-word
bindkey "[D" backward-word
bindkey "^_" copy-prev-word
bindkey " " magic-space
bindkey "!" expand-history
bindkey "\"" quote-region
bindkey "\$" spell-word
bindkey "'" quote-line #'"
bindkey "," _history-complete-newer
bindkey "-" neg-argument
bindkey "." insert-last-word
bindkey "/" _history-complete-older
bindkey "0" digit-argument
bindkey "1" digit-argument
bindkey "2" digit-argument
bindkey "3" digit-argument
bindkey "4" digit-argument
bindkey "5" digit-argument
bindkey "6" digit-argument
bindkey "7" digit-argument
bindkey "8" digit-argument
bindkey "9" digit-argument
bindkey "<" beginning-of-buffer-or-history
bindkey ">" end-of-buffer-or-history
bindkey "?" which-command
bindkey "A" accept-and-hold
bindkey "B" backward-word
bindkey "C" capitalize-word
bindkey "D" kill-word
bindkey "F" forward-word
bindkey "G" get-line
bindkey "H" run-help
bindkey "L" down-case-word
bindkey "N" history-search-forward
bindkey "OA" up-line-or-history
bindkey "OB" down-line-or-history
bindkey "OC" forward-char
bindkey "OD" backward-char
bindkey "P" history-search-backward
bindkey "Q" push-line
bindkey "S" spell-word
bindkey "T" transpose-words
bindkey "U" up-case-word
bindkey "W" copy-region-as-kill
bindkey "[1~" beginning-of-line
bindkey "[2~" overwrite-mode
bindkey "[3~" delete-char
bindkey "[4~" end-of-line
bindkey "[5~" history-beginning-search-backward-end
bindkey "[6~" history-beginning-search-forward-end
bindkey "[A" up-line-or-history
bindkey "[B" down-line-or-history
bindkey "[C" forward-char
bindkey "[D" backward-char
bindkey "_" insert-last-word
bindkey "a" accept-and-hold
bindkey "b" backward-word
bindkey "c" capitalize-word
bindkey "d" kill-word
bindkey "f" forward-word
bindkey "g" get-line
bindkey "h" run-help
bindkey "l" down-case-word
bindkey "n" history-search-forward
bindkey "p" history-search-backward
bindkey "q" push-line
bindkey "s" spell-word
bindkey "t" transpose-words
bindkey "u" up-case-word
bindkey "w" copy-region-as-kill
bindkey "x" execute-named-cmd
bindkey "y" yank-pop
bindkey "z" execute-last-named-cmd
bindkey "|" vi-goto-column
bindkey "~" _bash_complete-word
bindkey "^?" backward-kill-word
bindkey "^\[A" up-history
bindkey "^\[B" down-history
bindkey "^\[C" forward-char
bindkey "^\[D" backward-char
bindkey "^_" undo
bindkey " "-"~" self-insert
bindkey "" backward-delete-char
bindkey "\M-^@"-"\M-" self-insert
