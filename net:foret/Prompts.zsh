##
## Part of configuration files for Zsh4
## AUTHOR: Hugues Hiegel <hugues@hiegel.fr>
## 
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##

_prompt_colors[target]="1;31"

__compilation ()
{
    unset COMPILATION
    if [ -n "$TARGET" -o $((${V:-0} + ${NPROC:-0})) -gt 0 ]
    then
        COMPILATION="["
        COMPILATION+=$C_$_make_colors[target]$_C${TARGET:+$TARGET}$C_$_prompt_colors[soft_generic]$_C
        [ -n "$V" -a "$V" -gt 0 ] && \
            COMPILATION+=$C_$_make_colors[verbose]$_C$(for i in {1..$V} ; echo -n "V")$C_$_prompt_colors[soft_generic]$_C
        [ -n "$NPROC" -a "$NPROC" -gt 0 ] && \
            COMPILATION+=$C_$_make_colors[nproc]$_C$(for i in {1..$NPROC} ; echo -n "|")$C_$_prompt_colors[soft_generic]$_C
        COMPILATION+="] "
    fi
}
