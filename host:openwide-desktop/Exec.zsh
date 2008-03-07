
[ "$USER" != openwide ] && ( 
	echo -n "sudo openwide ? [Y/n] " ; read answer
	[ "$answer" != "n" ] && sudo -u openwide -s
)

