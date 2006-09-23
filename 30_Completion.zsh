##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@nullpart.net>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 
# Fichier de conf pour la personnalisation de la compl√tion automagique :-)
# Hugues HIEGEL <hugues@nullpart.net>
# jeu mar  3 10:00:44 CET 2005

autoload -U compinit 2> /dev/null
compinit -i

## Affiche le menu de s√lection si au moins 2 entr√es sont possibles
zstyle ':completion:*' menu select=2
## Utilise les couleurs d√©finies avec dircolors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Premiers essais...
#_ssh_hosts=(${(o)${${(M)${(f)"$(<~/.ssh/config)"}##host*}/host /}%% *})
#zstyle ':completion:*:*:ssh,scp:*' hosts $_ssh_hosts
#zstyle ':completion:*:(ssh|scp):*:my-accounts' hosts ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*}


# http://www.michael-prokop.at/computer/config/.zsh/zsh_completition

zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'
zstyle ':completion:*:kill:*' insert-ids single
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
#zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# ssh/scp-completion
zstyle ':completion:*:scp:*' tag-order \
  'hosts:-host hosts:-domain:domain hosts:-ipaddr:IP\ address *'
zstyle ':completion:*:scp:*' group-order \
  users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order \
  users 'hosts:-host hosts:-domain:domain hosts:-ipaddr:IP\ address *'
zstyle ':completion:*:ssh:*' group-order \
  hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp):*:hosts-host' ignored-patterns \
  '*.*' loopback localhost
zstyle ':completion:*:(ssh|scp):*:hosts-domain' ignored-patterns \
  '<->.<->.<->.<->' '^*.*' '*@*'
zstyle ':completion:*:(ssh|scp):*:hosts-ipaddr' ignored-patterns \
  '^<->.<->.<->.<->' '127.0.0.<->'
zstyle ':completion:*:(ssh|scp):*:users' ignored-patterns \
  adm bin daemon halt lp named shutdown sync
zstyle -e ':completion:*:(ssh|scp):*' hosts 'reply=(
  ${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) \
  /dev/null)"}%%[# ]*}//,/ }
  ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*}
  ${${${(M)${(s:# :)${(zj:# :)${(Lf)"$([[ -f ~/.ssh/config ]] && <~/.ssh/config)"}%%\#*}}##host(|name) *}#host(|name) }/\*}
  )'
#  ${(A)ssh_config_hosts:=${${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*\**}:#*\?*}}

zstyle -e ':completion:*:quilt:*' command 'quilt help|tail -n +4|head -6'
