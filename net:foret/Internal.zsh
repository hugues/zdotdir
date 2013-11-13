
__get_git_fullstatus ()
{
	[ -n "$1" ] && pushd $1 >/dev/null

	local _branch _status _tracking _stashes

	_branch=$(__get_git_branch)

	if [ -n "$_branch" ]
	then
		_status=$(__get_git_branch_status)
		_branch=$C_$_prompt_colors[soft_generic]$_C${${_branch/→/$C_$_status$_C}/←/$C_$_prompt_colors[soft_generic]$_C}$C_$color[none]$_C
		_tracking=$(__get_git_tracking_status)
		_stashes=$(__get_git_stashes)
	fi

	[ -n "$1" ] && popd >/dev/null

	echo $_branch${_tracking:+ $_tracking}${_stashes:+ $_stashes} | sed 's/_for_\(ixm\|df\)/’/g'

}
