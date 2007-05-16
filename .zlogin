
[ -f $ZDOTDIR/user:`whoami`/zlogin ] && source $ZDOTDIR/user:`whoami`/zlogin

[ -f $ZDOTDIR/.keychain ] && source $ZDOTDIR/.keychain
cmd_exists keychain && keychain --quiet --stop others --inherit any
#keychain --quiet --quick id_dsa
#keychain --quiet --quick 593F1F92

cmd_exists remind && remind -n

