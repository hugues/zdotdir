
ZDOTDIR=~/.zsh

##
## THIS FILE IS NOT INTENDED TO BE MODIFIED ! READ ABOVE...
##
## Instead, add/edit your configuration files inside $ZDOTDIR.
##
## If you want to add a file, name it specifically in the form
##
## 	$ZDOTDIR/??_*.zsh
##
## Where "??" should be a two-digits number.
## With that, file ``10_Toto.zsh'' would be parsed before
## file ``20_Tutu.zsh'', allowing you to organize your scripts.
## 
## If you want to make host-specific configurations, create a
## file named with the root of your configuration file, and
## append to it ".$(hostname -s)". (replace "zsh" by the hostname.
## if you have a computer named "zsh", well....... :-) )
## For example, for specific configuration for the host HAL in
## the file 10_Toto.zsh, you would create a file named 10_Toto.HAL
##

if [ -d $ZDOTDIR ]; then
	for script in $ZDOTDIR/??_*.zsh
	do
		source $script
		# find host-based script and source it
		local_script="${script:r}.`hostname -s`"
		[ -f $local_script ] && source $local_script
	done
fi

if [ "`whoami`" = "root" ]
then
	[ "`pwd`" = ~ ] && cd ~root
	export HOME=~root
	HISTFILE=$HISTFILE.root
fi

