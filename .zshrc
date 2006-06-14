ZDOTDIR=~/.zsh

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

