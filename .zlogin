
cmd_exists calendar && (\
#for _col in {1..$COLUMNS} ; do echo -n "_" ; done ;\ echo;\
echo "------------------------------[ événements ]---" ;\
calendar -A0 -f all -f ~/.calendar/calendar		| sed "s/\(\*.*\)/[1m\1[0m/;s/\(\*.*\*\)/[33;1m\1[0m/" ;\
)

#cmd_exists keychain && keychain --quiet --stop others --inherit any
#keychain --quiet --quick id_dsa
#keychain --quiet --quick 593F1F92

#cmd_exists remind && remind -n
[ -s ~/calendrier_* ] && ( echo "------------------------------[ calendrier ]---" ;\
grep -v '^#' ~/calendrier_* | sed "s/^\(\*.*\)/[1m\1/;s/^\(\?.*\)/[34m\1/;s/^/[0m/" \
)

