
function __Preload () {
	local _preload=""
	for lib in "$LD_PRELOAD"
	do
		_preload=${_preload:+$_preload }${${${lib:t}#lib}%%.*}
	done

	echo ${_preload:+$T_$_tu_$_T $_preload $T_$_tt_$_T}
}
PS1_TASKBAR+=(__Preload)

PS1_TASKBAR+=(__debian_dist)
