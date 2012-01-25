##
## Part of configuration files for Zsh4
## AUTHOR: Hugues Hiegel <hugues@hiegel.fr>
## 
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##

TRASH=$ZDOTDIR/.trash

delete ()
{
	local element real_element

	for element in $@
	do
		real_element=$(readlink -f $(dirname $element))/$(basename $element)
		if [ -e $real_element ]
		then
			echo "Deleting $element..."
			if [ ! -d $real_element ]
			then
				mkdir -p $TRASH${real_element:h}
			else
				mkdir -p $TRASH$real_element
			fi
			mv $element $TRASH$real_element
		else
			echo "Skipping unknown '$element' ..."
		fi
	done
}

lsdel ()
{
	local LS_OPTS __ARG
	while [ $# -gt 0 ]
	do
		typeset -A __ARG
		__ARG=$1
		shift

		[ $__ARG == "--" ] && break

		if [ $__ARG[1] == "-" ]
		then
			LS_OPTS="$LS_OPTS $__ARG"
		else
			set -- ${@:-"--"} $__ARG
		fi
	done


	for element in ${@:-.}
	do
		element=$(readlink -f $element)
		[ ! -d $element ] && element_dir=${element:h} || element_dir=$element
		if [ -e $TRASH$element ]
		then
				echo "Deleted from $element_dir:"
				ls ${=LS_OPTS} $TRASH$element | sed "s'$TRASH$element_dir/''"
		else
			echo "Nothing found in trash for '$element'."
		fi
	done
}

undel ()
{

	for element in $@
	do
		if [ -e ~trash/$element ]
		then
			echo "Getting back $element..."
			mkdir -p ${element:h}
			mv ~trash/$element .
			rmdir --ignore-fail-on-non-empty -p ~trash 2>&-
		else
			echo "Not found in trash: $element"
		fi
	done
}

alias lldel='lsdel -l'
alias ldel='lsdel -lh'

