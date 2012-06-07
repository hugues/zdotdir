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

__static_dynamic ()
{
        [ $(( ${STATIC:-$(( 1 ^ ${DYNAMIC:-0} ))} + ${DYNAMIC:-$(( 1 ^ ${STATIC:-0} ))} )) -lt 2 ] && \
        case "${STATIC:-$(( 1 ^ ${DYNAMIC:-0} ))}${DYNAMIC:-$((1 ^ ${STATIC:-0}))}" in
            "10")
                echo -n $C_
                export | grep -q '^DYNAMIC=' && echo -n "1;"
                echo -n $_make_colors[static]$_C"static" ;;
            "01")
                echo -n $C_
                export | grep -q '^STATIC=' && echo -n "1;"
                echo -n $_make_colors[dynamic]$_C"dynamic" ;;
        esac
}

__compilation_target ()
{
        [ -n "$TARGET" ] || exit
        echo -n $C_
        export | grep -q '^TARGET=' && echo -n "1;"
        echo -n $_make_colors[target]$_C$TARGET
}

__verbose_compilation ()
{
        [ -n "$V" -a "$V" -gt 0 ] || exit
        echo -n $C_
        export | grep -q '^V=' && echo -n "1;"
        echo -n $_make_colors[verbose]$_C$(for i in {1..$V} ; echo -n -n "V")
}

__nproc_compilation ()
{
        [ -n "$NPROC" -a "$NPROC" -gt 0 ] || exit
        echo -n $C_
        export | grep -q '^NPROC=' && echo -n "1;"
        echo -n $_make_colors[nproc]$_C$(for i in {1..$NPROC} ; echo -n -n "|")
}
__makeflags ()
{
    echo -n $MAKEFLAGS
}

PS1_TASKBAR+=(__makeflags __verbose_compilation __nproc_compilation)
PS1_EXTRA_INFO+=(__static_dynamic __compilation_target)

