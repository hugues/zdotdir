#!/bin/zsh
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

move_to_trash ()
{
	FOLDER=$TRASH/$PWD

	for element in $@
	do
		if [ -e $element ]
		then
			echo "Deleting $element..."
			mkdir -p $FOLDER/${element:h}
			mv -f $element $FOLDER/${element:h}/.
		fi
	done
}

list_deleted_elements ()
{
	FOLDER=$TRASH/$PWD

	if [ -d $FOLDER ]
	then
		for element in $(find $FOLDER -maxdepth 1 ! -wholename "$FOLDER" )
			ls -lad $element | sed "s:$FOLDER/::"
	else
		echo "Nothing found in trash."
	fi
}

undelete_from_trash ()
{
	FOLDER=$TRASH/$PWD

	for element in $@
	do
		if [ -e $FOLDER/$element ]
		then
			echo "Getting back $element..."
			mkdir -p ${element:h}
			mv $FOLDER/$element .
			rmdir --ignore-fail-on-non-empty -p $FOLDER 
		else
			echo "Not found in trash: $element"
		fi
	done
}

alias delete='move_to_trash'
alias undelete='undelete_from_trash'
alias deleted='list_deleted_elements'
