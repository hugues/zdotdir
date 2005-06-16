
cd_back() {
	for folder in $@
	do
		cd $(echo $folder | sed "s:[^/]\+:..:g")
	done
}

ldd()
{
	LDD=$(dlocate ldd | egrep "bin/ldd$" | head -n1 | cut -d' ' -f2)
	$LDD $@ | sed "s/\(.*local.*\)/[34m\1[0m/;s/\(.*not found.*\)/[34;1m\1[0m/" | tr -d '	'
}

exports()
{
	if ( [ $# -ne 0 ] )
	then
		if ( [ $1 != "-" ] )
		then
			export LD_LIBRARY_PATH=${1}/lib
			export PKG_CONFIG_PATH=$LD_LIBRARY_PATH/pkgconfig
			export ACLOCAL_FLAGS="-I ${1}/share/aclocal"
		else
			unset LD_LIBRARY_PATH
			unset PKG_CONFIG_PATH
			unset ACLOCAL_FLAGS
		fi
	fi

	for i in LD_LIBRARY_PATH PKG_CONFIG_PATH ACLOCAL_FLAGS
	do
		if ( [ ! -z ${(P)i} ] ) ; then
			echo "[34;1m$i:  	[0;34m"${(P)i}"[0m"
		else
			echo "[34m$i is unset.[0m"
		fi
	done
}

precmd()
{
    if ( [ "$DEBUG_MODE" = "yes" ] )
    then
    	exports
    fi
}

