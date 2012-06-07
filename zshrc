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
#  - "sys:$(uname -s)" for OS-specific conf,
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
OSNAME=`uname -s`
USER=${USER:-`whoami`}
UID=${UID:-`id -u`}
HOST=$HOST:r
HOST=${HOST:-$(hostname -s)}
DOMAIN=${DOMAIN:-$(hostname -a 2>&-| sed 's/^[^\.]*\.\?//')}
DOMAIN=${DOMAIN:-$(hostname -d 2>&-)}
DOMAIN=${DOMAIN:-$(hostname -y 2>&-)}
[ "$DOMAIN" = "" -o "$DOMAIN" = "localdomain" -o "$DOMAIN" = "(none)" ] && DOMAIN=$(grep "^search " /etc/resolv.conf | cut -d' ' -f2)

## Agent de clefs SSH/GPG
KEYCHAIN=~/.keychain/$(hostname)-sh
[ -r "${KEYCHAIN}"     ] && source ${KEYCHAIN}
[ -r "${KEYCHAIN}-gpg" ] && source ${KEYCHAIN}-gpg


__debug ()
{
    [ -n "$DEBUG" ] && echo >&2 $@
}

export USER HOST DOMAIN UID

if [ -d $ZDOTDIR ]; then

	for script in $ZDOTDIR/??_*.zsh
	do

        __debug -n "${${script:t:r}/??_/}... "
		source $script
		__debug

        for i in	"net:$DOMAIN"\
					"host:$HOST"\
					"sys:$OSNAME"\
					"user:$USER"\
					"user:$USER/net:$DOMAIN"\
					"user:$SUDO_USER"\
					"net:$DOMAIN/host:$HOST"\
					"net:$DOMAIN/sys:$OSNAME"\
					"net:$DOMAIN/user:$USER"\
					"net:$DOMAIN/user:$SUDO_USER"\
					"net:$DOMAIN/host:$HOST/sys:$OSNAME"\
					"net:$DOMAIN/host:$HOST/user:$USER"\
					"net:$DOMAIN/host:$HOST/user:$SUDO_USER"\
					"net:$DOMAIN/host:$HOST/sys:$OSNAME"\
					"net:$DOMAIN/host:$HOST/sys:$OSNAME/user:$USER"\
					"net:$DOMAIN/host:$HOST/sys:$OSNAME/user:$SUDO_USER"\
					"host:$HOST/sys:$OSNAME"\
					"host:$HOST/user:$USER"\
					"host:$HOST/user:$SUDO_USER"\
					"host:$HOST/sys:$OSNAME/user:$USER"\
					"host:$HOST/sys:$OSNAME/user:$SUDO_USER"
        do
            specific_script=${script:h}/$i/${${script:t}/??_/}
            if test -f $specific_script
			then
                __debug -n "$i/${${specific_script:t:r}/??_/}... ";
				source $specific_script
                __debug
			fi
            if test -f $specific_script.gpg
			then
                __debug -n "$i/${${specific_script:t:r}/??_/} [CRYPTED]... ";
				eval $(gpg --quiet --decrypt $specific_script.gpg)
				__debug
			fi
        done
	done
fi

# For sudo shells
if [ ! -z "$SUDO_USER" ]
then
	export HOME=~$USER
	[ "`pwd`" = ~$SUDO_USER ] && cd
fi

