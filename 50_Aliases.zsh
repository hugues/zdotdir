##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 
alias a=alias
a una=unalias

a -g ¬ISO='LC_ALL=fr_FR'
a -g ¬UTF='LC_ALL=fr_FR.UTF-8'

a -g ...=../..
a -g ....=../../..
a -g .....=../../../..
a -g ......=../../../../..
a -g .......=../../../../../..
a -g ........=../../../../../../..
a -g .........=../../../../../../../..

cmd_exists emacsclient && a e='emacsclient'
cmd_exists emacs && a ne='emacs -nw'

cmd_exists vim && a v='vim'

cmd_exists eject && a close='eject -t'

a goto='cd -P' ## Resolve symlinks

a rm='rm -i'
a mv='mv -i'
a cp && una cp ## Dé-assigne les alias de ``cp''
autoload zmv
a mmv='noglob zmv -W'

normal_user && cmd_exists apt-get && a apt-get='sudo apt-get'

a rt='find -maxdepth 1 -type f \( -name "*~" -o -name ".*~" -o -name "#*#" -o -name ".*.swp" \) -exec rm -vf \{\} \;'
a RT='find -type f \( -name "*~" -o -name ".*~" -o -name "#*#" -o -name ".*.swp" \) -exec rm -vf \{\} \;'

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

cmd_exists dict && a definition='dict -h dict.org'
cmd_exists dict && a traduction='dict -h localhost -P-'

cmd_exists dosbox && a dosbox='dosbox -c "mount c \"`pwd`\"" -c "mount d /cdrom -t cdrom" -c "c:" '
cmd_exists emacs && a gnus='emacs -f gnus'

#a make='make -j'

## Suffixes Aliases
cmd_exists editdiff && a -s patch=editdiff
a -s c=$EDITOR
a -s h=$EDITOR
