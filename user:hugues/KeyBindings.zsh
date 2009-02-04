##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
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

bindkey '[3~' delete-char			# delete
bindkey '[2~' overwrite-mode			# insert
bindkey '[A' up-line-or-history		# up
bindkey '[B' down-line-or-history		# down
bindkey '[A' history-search-backward	# META-up
bindkey '[B' history-search-forward		# META-down
bindkey '[C' forward-word			# ESC right
bindkey '[D' backward-word			# ESC left
bindkey '[3~' kill-region			# ESC del

# Pratique pour rehasher rapidement
bindkey -s 'r' 'Q rehash\n'
bindkey -s 'R' 'Q reset\n'

test $TERM = 'rxvt' -o $TERM = 'xterm' -o $TERM = 'aterm' &&
{
    bindkey '[1~' beginning-of-line	# home
    bindkey '[4~' end-of-line		# end-of-line
    bindkey 'Oc' forward-word		# CTRL right
    bindkey 'Od' backward-word	# CTRL left
    bindkey '[3$' vi-set-buffer		# SHIFT del
    bindkey 'Oa' history-search-backward	# CTRL UP
    bindkey 'Ob' history-search-forward	# CTRL DOWN
}
# (gnome-terminal)
test $TERM = 'xterm' &&
{
    bindkey 'OH' beginning-of-line	# home
    bindkey 'OF' end-of-line		# end-of-line
}
#bindkey '\C-t' gosmacs-transpose-chars	# J, ca c'est un truc pour toi
# ne pas oublier de s'en servir :
# vi-match-bracket est sur ^X^B par defaut
# npo : quote-region est sur ESC-' par defaut
# npo : which-command est sur ESC-? par defaut
# Lancez ``bindkey'' pour en savoir plus !!

main=viins
# Vi-mode
bindkey -A main $main

for keymap in viins vicmd
do
	bindkey -M $keymap -s 'r' 'Q rehash\n'
	bindkey -M $keymap -s 'R' 'Q reset\n'

	bindkey -M $keymap -s 't' 'Q todo\n'
	#bindkey -M $keymap -s 'T' 'Q todo all -c\n'

	bindkey -M $keymap -s 'é' ' 2>/dev/null '
	bindkey -M $keymap -s '2' ' 2>&1 '

	bindkey -M $keymap -s 'm' 'Q make\n'
	bindkey -M $keymap -s 'M' 'Q make\n'

	bindkey -M $keymap -s 'l' 'Q l\n'

	bindkey -M $keymap -s ' ' '\\ '

	bindkey -M $keymap -s 'g' 'Q git-status\n'
	bindkey -M $keymap -s 'G' 'Q git-repack -d -a\n'

	bindkey -M $keymap -s 'S' 'Q sudo !!'

	bindkey -M $keymap -s 'X' 'Q exec zsh\n'
done

# redefines push-line
bindkey -M viins "q" push-line
bindkey -M viins "Q" push-line
bindkey -M vicmd -s "q" "iq"
bindkey -M vicmd -s "Q" "iQ"

# Sets vicmd-mode vim-compliant
bindkey -M vicmd "u" "undo"
bindkey -M vicmd "" "redo"
bindkey -M vicmd "j" "history-search-forward"
bindkey -M viins "j" "history-search-forward"
bindkey -M vicmd "k" "history-search-backward"
bindkey -M viins "k" "history-search-backward"


menuselect_vi-mode()
{
	# Sets menuselect vim-compliant
	bindkey -M menuselect "j" "down-line-or-history"
	bindkey -M menuselect "k" "up-line-or-history"
	bindkey -M menuselect "h" "backward-char"
	bindkey -M menuselect "l" "forward-char"
}

# Enters vi-cmd mode at each prompt
#zle-line-init() { zle vi-cmd-mode }
#zle -N zle-line-init

# Show the current keymap used
zle-keymap-select()
{
	local keymap=$( [ $KEYMAP = "main" ] && echo "$main" || echo $KEYMAP )
	term_title " [$keymap]"
}
zle -N zle-keymap-select
zle -N zle-line-init zle-keymap-select
