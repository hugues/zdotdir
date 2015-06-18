
__debian_dist() {

	[ -e ~/.pbuilderrc ] || return
	eval $(grep '^:' ~/.pbuilderrc)

	print -Pn $T_$_tu_$_T" "

	#_dist=${DIST:-$(awk < ~/.pbuilderrc '/DIST:=/ { gsub(/^.*{DIST:=/, "") ; gsub(/}$/, "") ; print ; exit }')}
	print -Pn $C_${_env_colors[dist_$DIST]:-$_env_colors[dist_none]}
	( export | grep -q '^DIST=' ) && print -Pn ";"$color[bold]
	print -Pn $_C
	print -n $DIST

	print -Pn $C_"38;5;33"$_C"-"

	#_base=${BASE:-$(awk < ~/.pbuilderrc '/BASE:=/ { gsub(/^.*{BASE:=/, "") ; gsub(/}$/, "") ; print ; exit }')}
	print -Pn $C_${_env_colors[base_$BASE]:-$_env_colors[base_none]}
	( export | grep -q '^BASE=' ) && print -Pn ";"$color[bold]
	print -Pn $_C
	print -n $BASE

	print -Pn $C_${_env_colors[arch_$ARCH]:-$_env_colors[arch_none]}
	( export | grep -q '^ARCH=' ) && print -Pn ";"$color[bold]
	print -Pn $_C
	print -n " "$ARCH

	print -Pn $C_$_prompt_colors[bar]$_C
	print -Pn " "$T_$_tt_$_T
}

