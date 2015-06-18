#
# Use zsh syntax highlighting
#

if [ -d $ZDOTDIR/zsh-syntax-highlighting ]
then
	#unfunction preexec

	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
	source $ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

fi

ZSH_HIGHLIGHT_STYLES[default]="fg=cyan"

ZSH_HIGHLIGHT_STYLES[assign]="fg=cyan"

ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]="fg=yellow,bold"
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]="green"

ZSH_HIGHLIGHT_STYLES[bracket-error]="fg=red,bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-1]="fg=yellow,bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-2]="fg=green"
ZSH_HIGHLIGHT_STYLES[bracket-level-3]="fg=cyan,bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-4]="fg=blue"
ZSH_HIGHLIGHT_STYLES[bracket-level-5]="fg=magenta"
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]="fg=white,underline,bold"

ZSH_HIGHLIGHT_STYLES[precommand]="fg=blue,bold"

ZSH_HIGHLIGHT_STYLES[reserved-word]="fg=normal,bold,underline"
ZSH_HIGHLIGHT_STYLES[builtin]="fg=normal,bold"
ZSH_HIGHLIGHT_STYLES[command]="fg=cyan"
ZSH_HIGHLIGHT_STYLES[hashed-command]="fg=cyan,bold"
ZSH_HIGHLIGHT_STYLES[alias]="fg=cyan,underline"
ZSH_HIGHLIGHT_STYLES[function]="fg=cyan,bold,underline"

ZSH_HIGHLIGHT_STYLES[history-expansion]="fg=blue"

ZSH_HIGHLIGHT_STYLES[path]="fg=blue"
ZSH_HIGHLIGHT_STYLES[path_approx]="fg=magenta,bg=color106"
ZSH_HIGHLIGHT_STYLES[globbing]="fg=blue,bold"

ZSH_HIGHLIGHT_STYLES[commandseparator]="none"

ZSH_HIGHLIGHT_STYLES[cursor]="bold"

ZSH_HIGHLIGHT_STYLES[single-hyphen-option]="fg=blue"
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]="fg=blue,bold"

ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=green,bold"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=yellow,bold"
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]="fg=blue,bold"


ZSH_HIGHLIGHT_STYLES[root]="standout"

ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=red,bold"

