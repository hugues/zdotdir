#!/bin/zsh
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

cmd_exists mailstat && a mailstats='mailstat -mo ~/.procmail/procmail.log'
cmd_exists mailstat && a mails='mailstat -k ~/.procmail/procmail.log | egrep -v "## .*:" ; cat ~/.procmail/procmail.log >> ~/.procmail/procmail.log.old ; echo -n > ~/.procmail/procmail.log'
cmd_exists mutt && a junkmail='[ -f ~/Mail/junk.gz ] && mutt -f ~/Mail/junk.gz'
