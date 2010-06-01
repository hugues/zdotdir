
cmd_exists keychain && eval $(keychain --eval --inherit any-once --quick)

if cmd_exists fortune
then
	preprint "Pensée du jour" && echo
	fortune fr
	preprint "" && echo
	echo
fi | sed 's/^/   /'

birthdays

true
