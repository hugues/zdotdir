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
    local NPROC=${${2:+"$(( $(echo $MAKEFLAGS | sed 's/.*j\([0-9]*\).*/\1/') $@))"}:-$1}

    export MAKEFLAGS="$(echo $MAKEFLAGS | sed 's/j[0-9]*//')"
    [ "$NPROC" -ge 0 ] && MAKEFLAGS+="j"
    [ "$NPROC" -gt 0 ] && MAKEFLAGS+=$NPROC

    true
}

for keymap in viins vicmd emacs
do
    bindkey -M $keymap -s '+' 'Q up_up ; __nproc + 1\n'
    bindkey -M $keymap -s '-' 'Q up_up ; __nproc - 1\n'
done

