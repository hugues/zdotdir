#!/bin/zsh
##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@nullpart.net>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

## Paranoid specifics aliases

a mailstats='mailstat -mo ~/.procmail/procmail.log'
a mails='mailstat -k ~/.procmail/procmail.log | egrep -v "## .*:" ; cat ~/.procmail/procmail.log >> ~/.procmail/procmail.log.old ; echo -n > ~/.procmail/procmail.log'
a junkmail='mutt -f ~/Mail/junk.gz'
