##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

for keymap in viins vicmd emacs
do
    bindkey -M $keymap -s '+' 'Q for i in {1..$(__get_prompt_lines)} ; tput cuu1; export NPROC=$(($NPROC + 1))\n'
    bindkey -M $keymap -s '-' 'Q for i in {1..$(__get_prompt_lines)} ; tput cuu1; [ "$NPROC" -gt 0 ] && export NPROC=$(($NPROC - 1)) || unset NPROC\n'
done

