
cmd_exists calendar && \
for _col in {1..$COLUMNS} ; do echo -n "_" ; done ;\
calendar -A0 | sed "s/^\(......\*.*\)/[1m\1[0m/"

cmd_exists keychain && keychain --quiet --stop others --inherit any
#keychain --quiet --quick id_dsa
#keychain --quiet --quick 593F1F92

cmd_exists remind && remind -n
