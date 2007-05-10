
[ -f $ZDOTDIR/user:`whoami`/zlogin ] && source $ZDOTDIR/user:`whoami`/zlogin

[ -f $ZDOTDIR/.keychain ] && source $ZDOTDIR/.keychain
which keychain >/dev/null 2>&1 && keychain --quiet --stop others --inherit any
#keychain --quiet --quick id_dsa
#keychain --quiet --quick 593F1F92

which remind >/dev/null 2>&1 && remind -n

