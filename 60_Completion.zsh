##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

# Show groups for completion results
zstyle ':completion:*' group-name ''
zstyle ':completion:*' format '%B---------------[ %d ]%b'
# Uses dircolors for colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*' completer _complete _expand
zstyle ':completion:*' ignore-parents parent pwd directory

# Displays selection menu only when there is 2 items or more
zstyle ':completion:*' menu select=2
#zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
#zstyle ':completion:*' matcher-list '+l:|=* r:|=*' '+' '+m:{a-z}={A-Z} m:{a-zA-Z}={A-Za-z}' 'r:|[._-/]=** r:|=**'
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' prompt '%e errors found >'
zstyle ':completion:*' select-prompt '%B[ %p ]%b'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-compctl true
# End of lines added by compinstall

autoload -Uz compinit
compinit -i
