
#for _col in {1..$COLUMNS} ; do echo -n "_" ; done ;\ echo;\
preprint "événements" $color[bold] ; echo
cmd_exists when && when w --calendar=~/.when/birthdays
#cmd_exists calendar && calendar -A0 | sed "s/\(\*.*\)/[1m\1[0m/;s/\(\*.*\*\)/[33;1m\1[0m/" ;\

cmd_exists screen && [ "$(find /var/run/screen/S-$USER/ ! -type d | wc -l)" -gt 0 ] &&\
preprint "screen" $color[bold] && echo &&\
screen -list

#preprint "calendrier" $color[bold] ; echo
#[ -x ~/sbin//calendrier ] && ~/sbin/calendrier

#cmd_exists remind && remind -n
#
#cmd_exists keychain && keychain --quiet --stop others --inherit any
#keychain --quiet --quick id_dsa
#keychain --quiet --quick 593F1F92
