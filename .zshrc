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
# If you want to make user, host or network specific configurations,
# add your specific scripts to the folders
#  - "user:$(whoami)" for user-specific conf,
#  - "host:$(hostname -s)" for host-specific conf,
#  - "net:$(domainname)" for network-specific conf,
# rename your scripts to the form mentionned above, minus the "??_"
# prefix. An original script prefixed by a two-digits number SHOULD
# be present on the $ZDOTDIR folder, even if empty.
#

ZDOTDIR=${ZDOTDIR:-~/.zsh}
mkdir -p $ZDOTDIR

# Useful environment variables which may be used
# at any time - We compute them now to avoid calling
# the required processes each time we'll need.
USER=${USER:-`whoami`}
UID=${UID:-`id -u`}
HOST=${HOST:-$(hostname -s)}
DOMAIN=${DOMAIN:-${$(hostname -d 2>&-):-$(hostname -y 2>&-)}}

DEBUG=no

export USER HOST DOMAIN UID

if [ -d $ZDOTDIR ]; then
	for script in $ZDOTDIR/??_*.zsh
	do

        [ "$DEBUG" = "yes" ] && echo "${${script:t:r}/??_/}... ";
		source $script

        for i in "net:$DOMAIN" "host:$HOST" "user:$USER" "user:$SUDO_USER"
        do
            specific_script=${script:h}/$i/${${script:t}/??_/}
            if test -f $specific_script
			then
        		[ "$DEBUG" = "yes" ] && echo "$i/${${specific_script:t:r}/??_/}... ";
				source $specific_script
			fi
        done
	done
fi

# For sudo shells
#if [ "$USER" = "root" ]
#then
	[ "`pwd`" = ~ ] && cd ~$USER
	export HOME=~$USER
#fi

