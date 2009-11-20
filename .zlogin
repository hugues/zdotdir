
:>.tmp.screen-list
if cmd_exists tmux
then
	session_manager=tmux
	tmux list-sessions | strings > .tmp.screen-list
elif cmd_exists screen
then
	session_manager=screen
	screen -list | strings | grep -v "^No Sockets found" >> .tmp.screen-list
fi
if [ -s .tmp.screen-list ]
then
	preprint "$session_manager" $color[bold] && echo
	< .tmp.screen-list
	rm -f .tmp.screen-list
fi

cmd_exists keychain && eval $(keychain --eval --inherit any-once --quick)

true
