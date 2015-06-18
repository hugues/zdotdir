
_cn () {
	local _CN=/usr/local/Cavium_Networks/
	local SDK MODEL GCC
	case $1 in
		([Oo]+*) MODEL=OCTEON_CN58XX 
			SDK=${2:-OCTEON-SDK-1.7.2} 
			case $1 in
				(*-) GCC=tools  ;;
				(*) GCC=tools-gcc-4.7.2  ;;
			esac
			TARGET=OCTEONPLUS_64-CAVIUMSE-SMP-PERF-EXTFLOW  ;;
		([Oo]2*) case $1 in
				(O*) MODEL=OCTEON_CN68XX  ;;
				(o*) MODEL=OCTEON_CN66XX  ;;
			esac
			SDK=${2:-cnUSERS-SDK-2.3} 
			case $1 in
				(*-) GCC=tools  ;;
				(*) GCC=tools-gcc-4.7.2  ;;
			esac
			TARGET=OCTEON2_64-CAVIUMSE-SMP-PERF-EXTFLOW  ;;
		(*) TARGET=x86_64-LSB-SMP-PERF-EXTFLOW 
			unset OCTEON_ROOT ;;
	esac
	PATH=${(j/:/)$(echo ${${(s/:/)PATH}##/usr/local/Cavium_Networks/*})} 
	if [ -n "$SDK" ]
	then
		pushd $_CN/$SDK > /dev/null 2>&1
		source ./env-setup $MODEL --runtime-model --tools=$GCC
		popd > /dev/null 2>&1
	fi
}

