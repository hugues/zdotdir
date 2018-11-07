if ( ! __zsh_status )
then
    echo
    echo -n $c_$_prompt_colors[warning]$_c
    #toilet -f bigmono9 "D1rTY Zsh.."

    HBAR=${${(l:13::q:)}//q/$_tq_}
    VBAR=$T_$_tx_$_T

    echo
    echo -n "    "
    echo -n $T_$_tl_
    echo -n $HBAR
    echo -n $_tk_$_T
    echo
    echo "    $VBAR WARNING !!  $VBAR"
    echo "    $VBAR D1rTY Zsh.. $VBAR"

    echo -n "    "
    echo -n $T_$_tm_
    echo -n $HBAR
    echo -n $_tj_$_T
    echo
    echo $c_$_prompt_colors[none]$_c
fi

__cmd_exists keychain && eval $(keychain --inherit any --eval)

__cmd_exists when && when

if __cmd_exists fortune
then
	__preprint "Pensée du jour"
	fortune | fmt -s -w 74
	__preprint
	echo
fi | sed 's/^/   /'


true
