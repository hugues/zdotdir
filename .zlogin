
cmd_exists screen && screen -list | strings | grep -v "^No Sockets found" > .tmp.screen-list
[ -s .tmp.screen-list ] \
&& preprint "screen" $color[bold] && echo \
&& < .tmp.screen-list
[ -e .tmp.screen-list ] && rm -f .tmp.screen-list

cmd_exists keychain && eval $(keychain --eval --inherit any-once --quick)

true
