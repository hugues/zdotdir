
export MUSICPLAYER=musicplayer

# ccache
export CCACHE_DIR=/work/$USER/.ccache

# proxy
export http_proxy="http://proxy.foret:3128"
export ftp_proxy=$http_proxy
export no_proxy="127.0.0.1,10.,.foret,.qosmos.com"


export GET_IXM_BRANCHES="if [ \\\"\$(dirname %p/%f)\\\" == \\\".\\\" ] ; then
                             git clone work:%r -b %b \$( basename %p/%f ) ;
                         else
                             mkdir -p \$(dirname %p/%f) ; cd \$(dirname %p/%f ) ;
                             git module add \$( basename %p/%f ) work:%r %b ;
                             cd - ;
                         fi"

