##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

# zshall

_reset_=$C_$_prompt_colors[soft_generic]$_C

autoload -Uz vcs_info
zstyle ':vcs_info:*'       formats "%R $_reset_$C_$color[cyan];$color[bold]$_C/$C_$_prompt_colors[bold_generic]$_C%S$_reset_ [$_reset_%c%u%b$_reset_]"
zstyle ':vcs_info:*' actionformats "%R $_reset_/%S %B[$_reset_(%a) %c%u%b$_reset_%B]$_reset_"
zstyle ':vcs_info:*' stagedstr "$C_$color[yellow];$color[bold]$_C"
zstyle ':vcs_info:*' unstagedstr "$_C_$color[green]$_C"
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' get-revision false

