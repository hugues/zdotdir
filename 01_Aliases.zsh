alias a='alias'

a una=unalias

a e='emacs'
a ne='emacs -nw'

a close='eject -t'

a rm='rm -i'
a mv='mv -i'
autoload zmv
a mmv='noglob zmv -W'

a apt-get='sudo apt-get'

a rt='find . -type f \( -name "*~" -o -name ".*~" -o -name "#*#" \) -exec rm -vf \{\} \;'

a eg=egrep

a hg='< $HISTFILE egrep'
a lg='ls -lap | egrep'

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
