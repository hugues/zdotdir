##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@nullpart.net>
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
      *xterm*|rxvt*|(k|E|dt)term|gnome-terminal)
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
    term_title "  $1"
}
