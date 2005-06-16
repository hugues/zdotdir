
if ( [ "`uname -s`" = "Darwin" ] )
then
	## Fink / DarwinPorts

	PATH=/bin:/usr/bin:/sbin:/usr/sbin
	MANPATH=/usr/share/man
	INFOPATH=/usr/share/info

	for i in usr/X11R6 dp sw usr/local ; do
		export PATH=$PATH:/$i/bin:/$i/sbin
		export MANPATH=$MANPATH:/$i/share/man
		export INFOPATH=$INFOPATH:/$i/share/info
	done

fi
