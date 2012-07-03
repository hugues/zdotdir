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

__compilation_arch ()
{
    [ -n "$ARCH" ] || return
    echo -n $C_
    export | grep -q '^ARCH=' && echo -n "1;"
    echo -n $_make_colors[target]$_C$ARCH
}

__compilation_os ()
{
    [ -n "$OS" ] || return
    echo -n $C_
    export | grep -q '^OS=' && echo -n "1;"
    echo -n $_make_colors[target]$_C$OS
}

__compilation_target ()
{
    [ -n "$TARGET" ] || return
    echo -n $C_
    export | grep -q '^TARGET=' && echo -n "1;"
    echo -n $_make_colors[target]$_C$TARGET
}

__verbose_compilation ()
{
    [ -n "$V" -a "$V" -gt 0 ] || return
    echo -n $C_
    export | grep -q '^V=' && echo -n "1;"
    echo -n $_make_colors[verbose]$_C$(for i in {1..$V} ; echo -n -n "V")
}

__nproc_compilation ()
{
    NPROC=${NPROC:-0}
    [ $(($NPROC)) -gt 0 ] || { unset NPROC ; return }

    echo -n $C_
    export | grep -q '^NPROC=' && echo -n "1;"
    echo -n $_make_colors[nproc]$_C$(for i in {1..$NPROC} ; echo -n -n "|")
}
__makeflags ()
{
    [ -z "$MAKEFLAGS" ] && return
    echo -n $C_
    export | grep -q '^MAKEFLAGS=' && echo -n "1;"
    echo -n $_prompt_colors[soft_generic]";3"$_C${MAKEFLAGS// -/}
}

PS1_TASKBAR+=(__makeflags __verbose_compilation __nproc_compilation)
PS1_EXTRA_INFO+=(__static_dynamic __compilation_os __compilation_arch __compilation_target)

