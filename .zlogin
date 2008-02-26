
cmd_exists calendar && (\
#for _col in {1..$COLUMNS} ; do echo -n "_" ; done ;\ echo;\
echo "--------------------------------------------------[ événements ]---" ;\
( calendar -A0 -f all ; calendar -A0 -f ~/.calendar/calendar ) | sed "s/\(\*.*\)/[1m\1[0m/;s/\(\*.*\*\)/[33;1m\1[0m/" ;\
)

[ -x ~/sbin//calendrier ] && ( \
echo "--------------------------------------------------[ calendrier ]---" ;\
~/sbin/calendrier \
)

#cmd_exists remind && remind -n
#
#cmd_exists keychain && keychain --quiet --stop others --inherit any
#keychain --quiet --quick id_dsa
#keychain --quiet --quick 593F1F92
