##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

__nproc ()
{
    echo $(( ${NPROC:-0} $@ > 0 ? ${NPROC:-0} $@ : 0 ))
}

for keymap in viins vicmd emacs
do
    bindkey -M $keymap -s '+' 'Q __up_up ; export NPROC=$(__nproc + 1)\n'
    bindkey -M $keymap -s '-' 'Q __up_up ; export NPROC=$(__nproc - 1) ; [ "$NPROC" -gt 0 ] || unset NPROC\n'
done

