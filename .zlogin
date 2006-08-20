
[ -f $ZDOTDIR/user:`whoami`/zlogin ] && source $ZDOTDIR/user:`whoami`/zlogin

[ -f $ZDOTDIR/.keychain ] && source $ZDOTDIR/.keychain
which keychain 2>&1 >/dev/null && keychain --quiet --stop others --inherit any
#keychain --quiet --quick id_dsa
#keychain --quiet --quick 593F1F92
