
export MUSICPLAYER=musicplayer

# ccache
export CCACHE_DIR=~/Work/.ccache

# proxy
export http_proxy="http://proxy.foret:3128"
export ftp_proxy=$http_proxy
export no_proxy="127.0.0.1,10.,.foret,.qosmos.com"


export GET_IXM_BRANCHES="~/sbin/git_get.sh %p/%f %r %b"

# The following sets another std-user color for a specific tmux session
if ( __cmd_exists tmux && tmux list-panes -F '#S #{pane_tty}' 2>&- | grep -q "^pause $(tty)" )
then
	PS1_USER="31"
fi
