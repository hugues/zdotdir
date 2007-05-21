##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

term_title()
{
  [[ -t 1 ]] &&
    case $TERM in
      sun-cmd)
        print -Pn "\e]l%n@%m %~$1\e\\" ;;
      *term*|rxvt*)
	    print -Pn "\e]0;%n@%m (%l) %~$1\a" ;;
    esac
}

_chpwd()
{
    term_title
}

chpwd()
{
    _chpwd
    which todo > /dev/null 2>&1 && todo
}

precmd ()
{
##   [[ -t 1 ]] &&
#    print -nP "%(?,,%{[34;1m%}Foirage n°%{[38;1;45m%}%?\n)%{[0m%}"
    _chpwd
}

preexec ()
{
    term_title " ··· $1"
}

cmd_exists ()
{
	which $1 2>/dev/null >&2
}

normal_user ()
{
	if [ -e /etc/login.defs ]
	then
		eval `grep -v '^[$#]' /etc/login.defs | grep "^UID_" | tr -d '[:blank:]' | sed 's/^[A-Z_]\+/&=/'`
		[ \( $UID -ge $UID_MIN \) -a \( $UID -le $UID_MAX \) ]
	else
		[ "`whoami`" != "root" ]
	fi
}

privileged_user ()
{
	! normal_user
}

