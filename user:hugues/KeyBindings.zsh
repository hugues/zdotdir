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

#
# First pass with my personal bindings in vicmd-mode
# 
bindkey -A vicmd main ; source $0:h/Bindings
# And here we re-define the 'push-line' macro
bindkey -s "q" "iq"
bindkey -s "Q" "iQ"

# Second pass with my personal bindings in viins-mode
bindkey -A viins main ; source $0:h/Bindings

# Start every line editor in vicmd-mode.
# 'bindkey -A vicmd main' is not the good way since
# there is no way to enter viins-mode !!.. How tricky..
zle-line-init() { zle vi-cmd-mode }
zle -N zle-line-init
# Go see man zshzle for more details.

zle-keymap-select()
{
	# $1      is the old keymap
	# $KEYMAP is the new one

	local curr="$([ "$KEYMAP" = "main" ] && echo "viins" || echo $KEYMAP)"

	term_title " [$curr]"

}
zle -N zle-keymap-select
