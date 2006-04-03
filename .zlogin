
for i in {1..$COLUMNS} ; do echo -n "_" ; done
echo

calendar -A0 | sed "s/^\(......\*.*\)/[1m\1[0m/"

for i in {1..$COLUMNS} ; do echo -n "_" ; done
echo "[0m"

keychain --quiet --quick id_dsa
keychain --quiet --quick 593F1F92
