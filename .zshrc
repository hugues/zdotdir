ZDOTDIR=~/.zsh

if [ -d $ZDOTDIR ]; then
	for script in $ZDOTDIR/??_*.zsh
	do
		source $script
		local_script="${script:r}.`hostname -s`"

		if ( [ -f $local_script ] )
		then
			source $local_script
		fi
	done
fi

if [ "`whoami`" = "root" ]
then
	if [ "`pwd`" = ~ ]
	then
		cd ~root
	fi
	export HOME=~root
fi
#cd ~

