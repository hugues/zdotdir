
PS1_SUDO=${PS1_SUDO:-$color[green]}
PS1_USER_SSH=${PS1_USER_SSH:-$color[magenta]}
#PS1_USER_SCR=${PS1_USER_SCR:-$color[cyan]}
PS1_USER_SCR=$PS1_USER

if ( [ "$SSH_TTY" != "" ] )
then
	PS1_USER=$PS1_USER_SSH
fi
if ( echo "$TERM" | grep "^screen.*$" >/dev/null )
then
	PS1_USER=$PS1_USER_SCR
fi
if ( [ ! -z "$SUDO_USER" ] )
then
	PS1_USER=$PS1_SUDO
fi

