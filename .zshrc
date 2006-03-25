ZDOTDIR=~/.zsh

if [ -d $ZDOTDIR ]; then
	for script in $ZDOTDIR/*.zsh
	do
		source $script
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

