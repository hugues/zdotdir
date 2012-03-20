##
## Part of configuration files for Zsh4
## AUTHOR: Hugues Hiegel <hugues@hiegel.fr>
## 
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##

__cmd_exists git && \
git () {
	GIT=$(which -p git)
	case $1 in
		init|clone|config)
			;;
		*)
			if [ "$( ( $GIT ls-files ; $GIT ls-tree HEAD . ) 2>&- | head -n1)" = ""\
				-a \( ! -d .git -o "$($GIT rev-parse --git-dir 2>&-)" != ".git" \)\
				-a "$($GIT rev-parse --is-inside-git-dir 2>&-)" != "true" ]
			then
				echo >&2 "git $1: the current folder is not managed by git"
				return
			fi
			;;
	esac

	$(which -p git) $@
}

__cmd_exists when && \
when()
{
	TODAY_FILE=~/.when/.today

	$(which -p when) $@ | tail -n+3 | \
	sed 's/^\(aujourd.hui *[0-9][0-9][0-9][0-9] [A-Z][a-z]\+ [0-9][0-9][    ]*\)\(.*\)/'$c_'1;33'$_c'\1\2'$c_'0'$_c'/;
			  s/^\(demain *[0-9][0-9][0-9][0-9] [A-Z][a-z]\+ [0-9][0-9][    ]*\)\(.*\)/'$c_'1'$_c'\1\2'$c_'0'$_c'/;
				s/^\(hier *[0-9][0-9][0-9][0-9] [A-Z][a-z]\+ [0-9][0-9][        ]*\)\(.*\)/'$c_'3'$_c'\1\2'$c_'0'$_c'/' \
	> $TODAY_FILE

	if [ -s $TODAY_FILE ]
	then
		__preprint "À ne pas manquer" $color[red]
		cat $TODAY_FILE
		__preprint "" $color[red]
		echo
	fi | sed 's/^/   /'
}

__cmd_exists todo && \
todo()
{
	TODO=${=$(which -p todo | cut -d: -f2)}
	if [ $($TODO $@ | wc -l) -gt 0 ]
	then
		__preprint "À faire" $color[yellow]
		$TODO $@ --force-colour
		__preprint "" $color[yellow]
		echo
	fi | sed 's/^/   /'
}

