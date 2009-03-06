##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 
typeset -A prompt_colors git_colors mail_colors correct_colors battery_colors date_colors agent_colors

# I hate kik00l0l colorized prompts, so I'm using a way to
# give a dominant color for each part of the prompt, each of
# these remain still configurable one by one.
# Take a look to set_prompt_colors for these colorizations.
#
# To set the dominant color I'm using this :
#
#  - PS1_ROOT when we are root
#  - PS1_USER for normal usage
#  - PS1_USER_SSH when we are connected through SSH
#
# I'm storing the resulting dominant color in $prompt_colors[generic]

if [ "$termcap[Co]" = "256" -o "$termcap[Co]" = "88" ]
then
	# We have a 256 colors term !

	local nb_colors=$(( 256 - 16 ))

	PS1_ROOT=${PS1_ROOT:-38;5;$(( 16 + (36 * $SHLVL) % $nb_colors ))}
	PS1_USER=${PS1_USER:-38;5;$(( 16 + $SHLVL % $nb_colors ))}
	PS1_SUDO=${PS1_USER:-38;5;$(( 88 - $SHLVL % $nb_colors ))}
	PS1_USER_SSH=${PS1_USER_SSH:-38;5;$(( 88 - $SHLVL % $nb_colors ))}
	PS1_USER_SCR=${PS1_USER_SCR:-38;5;$(( 88 - $SHLVL % $nb_colors ))}
else
	PS1_ROOT=${PS1_ROOT:-$color[red]}
	PS1_USER=${PS1_USER:-$color[blue]}
	PS1_SUDO=${PS1_SUDO:-$color[green]}
	PS1_USER_SSH=${PS1_USER_SSH:-$color[magenta]}
	PS1_USER_SCR=${PS1_USER_SCR:-$color[cyan]}
fi

correct_colors[error]="$color[red];$color[bold]"
correct_colors[suggest]="$color[blue];$color[bold]"

