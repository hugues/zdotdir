##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@nullpart.net>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 
alias a='alias'

a -g DEVNULL='>/dev/null 2>&1'
a -g NOTROOT='[ "`whoami`" != "root" ] && '

a -g ASCII='LC_ALL=fr_FR'
a -g UNICODE='LC_ALL=fr_FR.UTF-8'

a una=unalias

a e='emacsclient'
a ne='emacs -nw'

a v='vim'

a close='eject -t'

a rm='rm -i'
a mv='mv -i'
autoload zmv
a mmv='noglob zmv -W'

NOTROOT which apt-get DEVNULL && a apt-get='sudo apt-get'

a rt='find . -type f \( -name "*~" -o -name ".*~" -o -name "#*#" \) -exec rm -vf \{\} \;'

a eg=egrep

a hg='< $HISTFILE cat -n | grep'
##'hc' stands for something like 'fc' and 'hg'##
a hc='history 0| grep'
a lg='ls -lap | grep'

a s='cd ..' 
a so='cd ${OLDPWD}'

a x=exit

a ls='ls -F --color=always'
a l='ls -lh'
a ll='ls -l'
a la='ls -la'
a lc='ls -c'
a lm='ls -ma'
a lc1='\ls -c1'

a definition='dict -h dict.org'
a traduction='dict -h localhost -P-'

a dosbox='dosbox -c "mount c \"`pwd`\"" -c "mount d /cdrom -t cdrom" -c "c:" '
a gnus='emacs -f gnus'

#a make='make -j'

# Unicode-uncompliant
a mutt='ASCII mutt'
a svn='ASCII svn'

## Suffixes Aliases
a -s patch=editdiff
a -s c=$EDITOR
a -s h=$EDITOR
