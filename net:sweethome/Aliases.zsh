##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

## Paranoid specifics aliases

#cmd_exists mailstat && a maillogs='mailstat -mo ~/.procmail/procmail.log | cut -c8- | sed "s:^[0-9]*::"'
#cmd_exists mailstat && a mailstats='echo ; echo "\tToday" ; awk < ~/.procmail/procmail.log{,.old} "BEGIN {RS=\"From\"} /`LC_ALL=C date "+%a %b %d ..:..:.. %Y"`/ { print \"From \"\$0 }" | grep -v "^$" | mailstat | cut -c8- | sed "s:^[0-9]*::"'
#cmd_exists mailstat && a mails='mailstat -km ~/.procmail/procmail.log | sed "s/^No mail.*/        No mail/" | cut -c8- | sed "s:^[0-9]*::" | egrep -v "## .*:" ; cat ~/.procmail/procmail.log >> ~/.procmail/procmail.log.old ; :> ~/.procmail/procmail.log'
cmd_exists mutt && a junkmail='[ -f ~/Mail/junk.gz ] && mutt -f ~/Mail/junk.gz'
