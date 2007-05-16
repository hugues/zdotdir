##
## THIS FILE IS NOT INTENDED TO BE MODIFIED ! READ ABOVE...
##
#
# Instead, add/edit your configuration files inside $ZDOTDIR.
#
# If you want to add a file, name it specifically in the form
#
# 	$ZDOTDIR/??_*.zsh
#
# Where "??" should be a two-digit number.
# With that, file ``10_Toto.zsh'' would be parsed before
# file ``20_Tutu.zsh'', allowing you ordering your scripts.
# 
# If you want to make host-specific configurations, create a
# file named with the root of your configuration file, and
# append to it ".$(hostname -s)". (replace "zsh" by the hostname.
# if you have a computer named "zsh", well....... :-) )
# For example, for specific configuration for the host HAL in
# the file 10_Toto.zsh, you would create a file named 10_Toto.HAL
#

ZDOTDIR=${ZDOTDIR:-~/.zsh}
mkdir -p $ZDOTDIR

# Useful environment variables which may be used
# at any time - We compute them now to avoid calling
# the required processes each time we'll need.
USER=${USER:-`whoami`}
UID=${UID:-`id -u`}
HOST=${HOST:-$(hostname -s)}
DOMAIN=${DOMAIN:-${$(hostname -d):-$(hostname -y)}}

export USER HOST DOMAIN UID

if [ -d $ZDOTDIR ]; then
	for script in $ZDOTDIR/??_*.zsh
	do

        [ "$DEBUG" != "" ] && echo "${${script:t:r}/??_/}... ";
		source $script

        for i in "net:$DOMAIN" "host:$HOST" "user:$USER" "user:$SUDO_USER"
        do
            specific_script=${script:h}/$i/${${script:t}/??_/}
            if test -f $specific_script
			then
				source $specific_script
			fi
        done
	done
fi

if [ "`whoami`" = "root" ]
then
	[ "`pwd`" = ~ ] && cd ~root
	export HOME=~root
fi

