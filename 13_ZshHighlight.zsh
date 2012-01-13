#
# Use zsh syntax highlighting
#

if [ -d $ZDOTDIR/zsh-syntax-highlighting ]
then
	unfunction preexec

	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
	source $ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

fi

ZSH_HIGHLIGHT_STYLES[default]="none"

ZSH_HIGHLIGHT_STYLES[assign]="none"

ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]="fg=yellow,bold"
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]="green"

ZSH_HIGHLIGHT_STYLES[bracket-error]="fg=red,bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-1]="fg=yellow,bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-2]="fg=green"
ZSH_HIGHLIGHT_STYLES[bracket-level-3]="fg=cyan,bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-4]="fg=blue"
ZSH_HIGHLIGHT_STYLES[bracket-level-5]="fg=magenta"
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]="fg=white,underline,bold"

ZSH_HIGHLIGHT_STYLES[builtin]="fg=cyan,bold,underline"
ZSH_HIGHLIGHT_STYLES[function]="fg=cyan,bold"
ZSH_HIGHLIGHT_STYLES[alias]="fg=cyan"
ZSH_HIGHLIGHT_STYLES[command]="fg=normal"
ZSH_HIGHLIGHT_STYLES[hashed-command]="fg=normal,bold"
ZSH_HIGHLIGHT_STYLES[path]="fg=normal,bold"
ZSH_HIGHLIGHT_STYLES[precommand]="fg=normal,underline"
ZSH_HIGHLIGHT_STYLES[reserved-word]="fg=cyan,underline"

ZSH_HIGHLIGHT_STYLES[history-expansion]="fg=blue"

ZSH_HIGHLIGHT_STYLES[globbing]="fg=yellow"

ZSH_HIGHLIGHT_STYLES[commandseparator]="none"

ZSH_HIGHLIGHT_STYLES[cursor]="bold"

ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]="fg=yellow"
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]="none"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=yellow,bold"


ZSH_HIGHLIGHT_STYLES[root]="standout"

ZSH_HIGHLIGHT_STYLES[single-hyphen-option]="none"
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=green,bold"

ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=red,bold"
