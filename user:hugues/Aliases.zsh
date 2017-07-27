##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 
a -g ¬ISO='LC_ALL=fr_FR'
a -g ¬UTF='LC_ALL=fr_FR.UTF-8'

a -g ...=../..
a -g ....=../../..
a -g .....=../../../..
a -g ......=../../../../..
a -g .......=../../../../../..
a -g ........=../../../../../../..
a -g .........=../../../../../../../..

if ( __cmd_exists emacs )
then
	a e='emacs'
	a ne='e -nw'
	a gnus='e -f gnus'
fi

if ( __cmd_exists vim )
then
	a v='vim'

	vim --version | grep -- "+clientserver" >/dev/null && \
	__cmd_exists vims && \
		a vim='vim --servername `print -P "%l"`'
fi

a goto='cd -P' ## Resolve symlinks
a so='cd -'

a rm='rm -i'
a mv='mv -i'
a cp && una cp ## Dé-assigne les alias de ``cp''
autoload zmv
a mmv='noglob zmv -W'

# Not an alias, but..
where() { cd $(dirname $(readlink -f $(which $1))) }

__normal_user && __cmd_exists apt-get && a apt-get='sudo apt-get'
__normal_user && __cmd_exists apt && a apt='sudo apt'
__normal_user && __cmd_exists pacman && a pacman='sudo pacman'
__normal_user && __cmd_exists yum && a yum='sudo yum'

a _rt='find -maxdepth 1 -type f \( -name "*~" -o -name ".*~" -o -name "#*#" -o -name ".*.swp" \) -exec rm -vf \{\} \;'
a _RT='find -type f \( -name "*~" -o -name ".*~" -o -name "#*#" -o -name ".*.swp" \) -exec rm -vf \{\} \;'

a grep='grep --color=auto'
a egrep='egrep --color=auto'

# Was 'hg', but conflicts with Mercurial..
a histg='history -E 0| grep'
a lg='ls -lap | grep'

a ls="ls $LS_OPTIONS"
a l='ls -lh' # human readable sizes
a ll='ls -l'
a la='ls -la'
a lt='ls -lhtr' # sort by modification time, first at top
a llt='ls -ltr'
a lta='lt -a'
a llta='llt -a'
a lat='la -tr'
a lc='ls -c'
a l1='\ls -1'

a gitk='\gitk --date-order'
a gm='\git mergetool'
a grc='\git rebase --continue'
a gra='\git rebase --abort'

__cmd_exists dict && a definition='dict -h dict.org'
__cmd_exists dict && a traduction='dict -h hiegel.fr -P-'

__cmd_exists dosbox && a dosbox='dosbox -c "mount c \"`pwd`\"" -c "mount d /cdrom -t cdrom" -c "c:" '


# VERY VERY bad idea...
#a make='make -j'

## Suffixes Aliases
# I don't like this, I never used it.
#
#__cmd_exists editdiff && a -s patch=editdiff
#a -s c=$EDITOR
#a -s h=$EDITOR
