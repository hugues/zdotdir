#!/bin/zsh

[[ -t 1 ]] &&
chpwd()
{
    case $TERM in
      sun-cmd)
		print -Pn "\e]l%n@%m %~\e\\" ;;
      *xterm*|rxvt|(k|E|dt)term|gnome-terminal)
		print -Pn "\e]0;%n@%m (%l) %~\a" ;;
    esac
    #print -P "%(/,%78>...>%/,%//)%b"
}

precmd ()
{
##   [[ -t 1 ]] &&
#    print -nP "%(?,,%{[34;1m%}Foirage n°%{[38;1;45m%}%?\n)%{[0m%}"
}

preexec ()
{
    #nothing :)
}
