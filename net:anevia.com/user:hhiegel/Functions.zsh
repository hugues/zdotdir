
__debian_dist() {
	_dist=${DIST:-$(awk < ~/.pbuilderrc '/DIST:=/ { gsub(/^.*{DIST:=/, "") ; gsub(/}$/, "") ; print ; exit }')}
	print -Pn $C_${_env_colors[dist_$_dist]:-$_env_colors[dist_none]}
	( export | grep -q '^DIST=' ) && print -Pn ";"$color[bold]
	print -Pn $_C
	print -n $_dist

	print -Pn $C_"38;5;33"$_C"-"

	_base=${BASE:-$(awk < ~/.pbuilderrc '/BASE:=/ { gsub(/^.*{BASE:=/, "") ; gsub(/}$/, "") ; print ; exit }')}
	print -Pn $C_${_env_colors[base_$_base]:-$_env_colors[base_none]}
	( export | grep -q '^BASE=' ) && print -Pn ";"$color[bold]
	print -Pn $_C
	print -n $_base
}

