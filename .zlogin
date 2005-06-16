
for i in {1..$COLUMNS} ; do echo -n "_" ; done
echo
#/usr/games/fortune\
#    ~/bdd/fortunes/fr\
#| cowsay

calendar -A0 | sed "s/^\(......\*.*\)/[1m\1[0m/"

for i in {1..$COLUMNS} ; do echo -n "_" ; done
echo "[0m"

