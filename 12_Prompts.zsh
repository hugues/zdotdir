##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
##
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
##

_prompt_colors[generic]=${PS1_USER:-}

if __privileged_user
then
    _prompt_colors[generic]=${PS1_ROOT:-$color[bold];$color[red]}
fi
if [ "$_yeahconsole" = "true" ]
then
    _prompt_colors[generic]=${PS1_YEAH}
fi

__set_prompt_colors

## Prompts
#
#  man zshmisc(1)
#

PS1_TASKBAR=()
PS1_EXTRA_INFO=()

## Automagic funcs
#
# chpwd        : changement de répertoire
# preexec    : avant d'exécuter une commande
# precmd    : avant d'afficher le prompt
#

chpwd()
{

    __cmd_exists todo && todo

    #if ( __cmd_exists git && test -d .git )
    #then
	#	__debug -n "    GIT check..."
	#	# Shows tracked branches and modified files
	#	git status | sed -n '2{/# Your branch/p;q}'
	#	__debug
    #fi
}

preexec ()
{
    __term_title "$2"

    __set_prompt_date exec

    # Only redraws the date, not the full prompt, since we got glitches with BANG_HIST and AUTOCORRECT...
    tput sc # save cursor position
    up_up # go to start of current prompt
    print -Pn "$(__show_date)" # prints date
    tput rc # restore cursor position

    print -Pn "$C_$_prompt_colors[exec]$_C"
 }

__set_prompt_date()
{
    begin=${${1:+$_tj_}:-$_tk_}
    end=${${1:+$_tm_}:-$_tl_}

    # Date
    __debug -n "    Date..."
    DATE=$C_$_prompt_colors[braces]$_C$T_"${begin}"$_T" "$C_$_date_colors[${1:-normal}]$_C"%D{%a-%d-%b-%Y %H:%M:%S}"$C_$_prompt_colors[braces]$_C" "$C_$_prompt_colors[bar]$_C$T_"${end}$_tq_"$_T
    DATEEXPAND=$(__expand_text "$DATE")
    DATESIZE=${#DATEEXPAND}
    __debug
}

__update_prompt_elements()
{
    __term_title
    __set_prompt_date
    __hbar

    CURDIR=$C_$_prompt_colors[path]$_C"%(!.%d.%~)"$C_$color[none]$_C

}

__error_code ()
{
    # Error
    __debug -n "    Error code..."
    echo ${ERROR:+$C_$_prompt_colors[error]$_C$ERROR}
    __debug
}
PS1_TASKBAR+=(__error_code)

__ssh_gpg_agents ()
{
    __debug -n "    Agents..."
    # GPG/SSH agents
    AGENTS=""

    __debug
    __debug -n "    ......SSH"
    # Check ssh-agent only if the env socket has been set and is accessible
    if [ -S "$SSH_AUTH_SOCK" ]
    then
        # Get keylist
        SSH_AGENT_KEYLIST="$( ssh-add -l | grep "^[[:digit:]]\+ \([[:digit:]a-f]\{2\}:\)\{15\}[[:digit:]a-f]\{2\} .* (.*)$" )"
        # Check if it is a forwarded agent
        if [ "$SSH_AGENT_PID" -gt 0 -a -e /proc/$SSH_AGENT_PID/cmdline ]
        then
            # That's a local agent
            if [ "$SSH_AGENT_KEYLIST" != "" ]
            then
                AgentChar=${AGENT_WITH_KEYS:-✔}
                for i in $(echo $SSH_AGENT_KEYLIST | cut -d' ' -f3 )
                do
                    AGENTS=$AGENTS$C_${_agent_colors[$i:t]:-$_agent_colors[has_keys]}$_C$AgentChar
                done
            else
                AGENTCOLOR="empty"
                AgentChar=${AGENT_EMPTY:-✘}
                AGENTS=$C_$_agent_colors[$AGENTCOLOR]$_C"$AgentChar"
            fi
        else
            # That's a forwarded agent
            if [ "$SSH_AGENT_KEYLIST" != "" ]
            then
                AGENTCOLOR="has_remote_keys"
                AgentChar=${AGENT_SOCK_WITH_KEYS:-✓}
            else
                AGENTCOLOR="remote_empty"
                AgentChar=${AGENT_SOCK_EMPTY:-✗}
            fi
            AGENTS=$C_$_agent_colors[$AGENTCOLOR]$_C"$AgentChar"
        fi
    fi

    __debug
    __debug -n "    ......GPG"
    GPG_AGENT_PID="$(echo $GPG_AGENT_INFO | cut -d: -f2)"
    if [ "$GPG_AGENT_PID" != "" -a -e /proc/$GPG_AGENT_PID/cmdline ]
    then
        if [ "`strings /proc/$GPG_AGENT_PID/cmdline | head -n1`" = "gpg-agent" ]
        then
            AGENTCOLOR="has_keys"
            AGENTS=$AGENTS$C_$_agent_colors[$AGENTCOLOR]$_C${GPG_AGENT_RUNNING:-⚡}
        fi
    fi
    __debug

    echo $AGENTS
}
PS1_TASKBAR+=(__ssh_gpg_agents)

__display ()
{
    __debug -n "    Display..."
    echo ${DISPLAY:+$C_$_prompt_colors[display]$_C"("$DISPLAY")"}
    __debug
}
PS1_TASKBAR+=(__display)

__vcsbranch ()
{
    local CVSTAG
    local SVNREV SVNREVSIZE SVNSTATUS
    local HGBRANCH
    local GITBRANCH GITBRANCHSIZE GITBRANCHCHUNK CHUNKABLE
    local vcsbranch

    # get cvs tag
    #
    CVSTAG=""
    if [ -d CVS ]
    then
        __debug -n "    CVS status..."
        CVSTAG=$(test -e CVS/Tag && cat CVS/Tag || basename $(cat CVS/Root 2>&- || echo "HEAD") )
        CVSTAG=${CVSTAG:+$C_$_gcl_colors[uptodate]$_C$CVSTAG}
        __debug
    fi
    vcsbranch+=$CVSTAG

    if [ -d .svn ]
    then
        # get svn status
        #
        __debug -n "    SVN status..."
        SVNREV=$(LC_ALL=C svn info 2>&- $PWD | awk '/^Revision: / {print $2}')
        SVNREVSIZE=${#${SVNREV:+ r$SVNREV}}
        if [ "$SVNREV" != "" ]
        then
            if [ ! -z "$CHECK_SVN_STATUS" ]
            then
                SVNSTATUS="$(svn diff 2>&-)"
                SVNSTATUS=${${SVNSTATUS:+$_gcl_colors[changed]}:-$_gcl_colors[uptodate]}
            fi
        fi
        SVNREV=${SVNREV:+$C_$_prompt_colors[doubledot]$_C$C_$SVNSTATUS$_C"r"$SVNREV}
        __debug
    fi
    [ -n "$SVNREV" ] && vcsbranch+=${vcsbranch:+ }$SVNREV

    # get hg status
    HGBRANCH=$(__get_gcl_branch hg)
    [ -n "$HGBRANCH" ] && vcsbranch+=${vcsbranch:+ }$HGBRANCH

    # get git status
    #
    GITBRANCH=$(__get_git_fullstatus)
    [ -n "$GITBRANCH" ] && vcsbranch+=${vcsbranch:+ }$GITBRANCH

    echo $vcsbranch
}
PS1_EXTRA_INFO+=(__vcsbranch)

__subvcsbranches () {
	local GITBRANCH

	GIT_DIR=$(git rev-parse --git-dir 2>/dev/null)
	[ "$( ( git ls-files ; git ls-tree HEAD . ) 2>&- | head -n1)" = "" -a \
	  \( ! -d .git -o -z "$GIT_DIR" \) -a \
	  "$(git rev-parse --is-inside-git-dir 2>&-)" != "true" ] && return

	# Get recursive submodules statuses
	for SUBMODULE in $(git config --get zsh.recurse-dirs)
	do
		if [ -d $(dirname $GIT_DIR)/$SUBMODULE ]
		then
			GITBRANCH+=${GITBRANCH:+$(tput cuf1)}
			GITBRANCH+=$C_$_prompt_colors[bar]$_C"[%{%B%}$SUBMODULE%{%b%}:"
			GITBRANCH+=$(__get_git_fullstatus $(dirname $GIT_DIR)/$SUBMODULE)
			GITBRANCH+=$C_$_prompt_colors[bar]$_C"]"
		fi
	done
	echo $GITBRANCH

}
PS1_TASKBAR+=(__subvcsbranches)

__redefine_prompt ()
{
    case "$_yeahconsole" in
        "true")
            __yeah_prompt
            ;;
        *)
            __two_lines_prompt
            ;;
    esac
}
zle -N __redefine_prompt

__yeah_prompt ()
{
    PS1=$C_$prompt_color[default]$_C$C_$_prompt_colors[user]$_C"%n"$C_$_prompt_colors[arob]$_C"@"$C_$_prompt_colors[host]$_C"%m "$CURDIR${VCSBRANCH:+ $VCSBRANCH}" "$C_$_prompt_colors[dies]$_C">"$C_$_prompt_colors[cmd]$_C" "
    PS2="$C_$_prompt_colors[soft_generic]$_C$(for i in {2..$#lastline} ; print -n "·" ; tput sc ; print -n "\r")$C_$color[yellow];$color[bold]$_C%_$(tput rc)$C_$color[none]$_C "
}

__show_date()
{
    echo $(tput cub $COLUMNS ; tput cuf $(($COLUMNS - $DATESIZE)))$DATE
}

__display_vi_mode()
{
    __debug -n "    	vimode..."
    echo -n "$C_$color[bold];33$_C%8v"
    __debug
}
PS1_TASKBAR+=(__display_vi_mode)

__two_lines_prompt ()
{
    ## Le prompt le plus magnifique du monde, et c'est le mien !
    # Affiche l'user, l'host, le tty et le pwd. Rien que ça...
    #
    PS1_=$(print -Pn '\r')$HBAR_COLOR$HBAR$(print -Pn '\r')
    __debug "-----------------> taskbar..."
    for trigger in $PS1_TASKBAR
    do
	__debug "              ---> $trigger..."
        result=$($trigger)
        [ -n "$result" ] && PS1_+=$_cuf1_${result}$C_$_prompt_colors[bar]$_C
    done

    __debug "-----------------> date..."
    PS1_+=$(__show_date)

    __debug "-----------------> extra..."
    PS1_+="
"$C_$prompt_color[default]$_C$C_$_prompt_colors[user]$_C"%n"$C_$_prompt_colors[arob]$_C"@"$C_$_prompt_colors[host]$_C"%M "$CURDIR${VCSBRANCH:+ $VCSBRANCH}
    for trigger in $PS1_EXTRA_INFO
    do
	__debug "              ---> $trigger..."
        result=$($trigger)
        [ -n "$result" ] && PS1_+=" "${result}
    done
    __debug "-----------------> PS1..."
    PS1=$PS1_" "$C_$_prompt_colors[dies]$_C"%#"$C_$_prompt_colors[cmd]$_C" "

    __debug "-----------------> PS2..."
    local lastline="$(__expand_text $PS1 | tail -n1)"
    # Prompt level 2
    PS2="$C_$_prompt_colors[soft_generic]$_C$(for i in {2..$#lastline} ; print -n "·" ; tput sc ; print -n "\r")$C_$color[yellow];$color[bold]$_C%_$(tput rc)$C_$color[none]$_C "
    __debug "------------------------------"

}

if ( ! __zsh_status )
then
    echo
    echo -n $c_$_prompt_colors[warning]$_c
    #toilet -f bigmono9 "D1rTY Zsh.."

    HBAR=$(for i in {1..13} ; echo -n - "$_tq_")
    VBAR=$T_$_tx_$_T

    echo
    echo -n "    "
    echo -n $T_$_tl_
    echo -n $HBAR
    echo -n $_tk_$_T
    echo
    echo "    $VBAR WARNING !!  $VBAR"
    echo "    $VBAR D1rTY Zsh.. $VBAR"

    echo -n "    "
    echo -n $T_$_tm_
    echo -n $HBAR
    echo -n $_tj_$_T
    echo
    echo $c_$_prompt_colors[none]$_c
fi

precmd()
{
    # Catchs ERROR code
    ERROR=$(print -Pn "%(?;;%?)")

    __update_prompt_elements
    __redefine_prompt
}



# Prompt level 3
PS3="?# "

# Prompt level 4
PS4="+%N:%i> "

# Prompt de droite, pour l'heure et le code d'erreur de la dernière commande
#RPS1="%(?;;"$C_$_prompt_colors[error]$_C"%?"$C_$color[none]$_C")"

# Ultime : prompt de correction :-)
SPROMPT="zsh: $C_$_correct_colors[error]$_C'%R'$C_$color[none]$_C ? Vous ne vouliez pas plutôt $C_$_correct_colors[suggest]$_C'%r'$C_$color[none]$_C ? [%BN%byae] "

