
#for _col in {1..$COLUMNS} ; do echo -n "_" ; done ;\ echo;\
if cmd_exists when
then

	LATEST=`stat 2>&- --printf="%z\n" ~/.when/.today | cut -d' ' -f1`
	TODAY=`date "+%Y-%m-%d"`	

	if [ "$TODAY" != "$LATEST" ]
	then
		when w --calendar=~/.when/birthdays | tail -n+3 > ~/.when/.today
	fi

	if [ -s ~/.when/.today ]
	then
		preprint "événements" $color[bold] ; echo
		cat ~/.when/.today
	fi
fi
#cmd_exists calendar && calendar -A0 | sed "s/\(\*.*\)/[1m\1[0m/;s/\(\*.*\*\)/[33;1m\1[0m/" ;\

cmd_exists screen && screen -list | strings | grep -v "^No Sockets found" > .tmp.screen-list
[ -s .tmp.screen-list ] \
&& preprint "screen" $color[bold] && echo \
&& < .tmp.screen-list \
&& rm -f .tmp.screen-list


#preprint "calendrier" $color[bold] ; echo
#[ -x ~/sbin//calendrier ] && ~/sbin/calendrier

#cmd_exists remind && remind -n

cmd_exists keychain && eval $(keychain --eval --inherit any-once --quick)
#keychain id_dsa 593F1F92

true
