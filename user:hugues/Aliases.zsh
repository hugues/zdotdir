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

__cmd_exists emacsclient && a e='emacsclient'
__cmd_exists emacs && a ne='emacs -nw'

if ( __cmd_exists vim )
then
	a v='vim'

	if ( vim --version | grep -- "+clientserver" >/dev/null )
	then
		if ( __cmd_exists vims )
		then
			a vim='vim --servername `print -P "%l"`'
		fi
	fi
fi

__cmd_exists eject && a close='eject -t'

a goto='cd -P' ## Resolve symlinks

a rm='rm -i'
a mv='mv -i'
a cp && una cp ## Dé-assigne les alias de ``cp''
autoload zmv
a mmv='noglob zmv -W'

__normal_user && __cmd_exists apt-get && a apt-get='sudo apt-get'
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
a lc1='\ls -c1'

a gitk='\gitk --date-order'

__cmd_exists dict && a definition='dict -h dict.org'
__cmd_exists dict && a traduction='dict -h hiegel.fr -P-'

__cmd_exists dosbox && a dosbox='dosbox -c "mount c \"`pwd`\"" -c "mount d /cdrom -t cdrom" -c "c:" '
__cmd_exists emacs && a gnus='emacs -f gnus'

#a make='make -j'

## Suffixes Aliases
# I don't like this, I never used it.
#
__cmd_exists editdiff && a -s patch=editdiff
a -s c=$EDITOR
a -s h=$EDITOR
