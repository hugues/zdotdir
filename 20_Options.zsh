##
## Part of configuration files for Zsh 4
## by Hugues Hiegel <hugues@hiegel.fr>
## 
## NO WARRANTY PROVIDED, USE AT YOUR OWN RISKS
##
## You are encouraged to use, modify, and redistribute
## these files with or without this notice.
## 

## Zsh options
#
# see man zshoptions(1) for more details ;-)
#

function _setopt() {
	_test_and_set $1 on
}
function _unsetopt() {
	_test_and_set $1 off
}

function _test_and_set() {
	local option=${(L)1//_/} # lowercase and no '_'

	case "$option" in
		"no"*)
			option=${option/no/}
			# resets $1 and $2
			set $option off
			;;
	esac

	if ( echo ${(k)options} | grep $option >/dev/null )
	then
		# option exists, set it.
		case "$2" in
			on)
				[ "$DEBUG" = "yes" ] && echo "setopt $option" >&2
				setopt $option
				;;
			off)
				[ "$DEBUG" = "yes" ] && echo "unsetopt $option" >&2
				unsetopt $option
				;;
		esac
	else
		[ "$DEBUG" = "yes" ] && echo "$option not supported by this version of zsh !" >&2
	fi
}



# J'ai pas très bien compris mais en gros ça va me permettre
# d'être sûr de retrouver ma commande dans tous les cas...
_setopt Always_Last_Prompt

_setopt Always_to_End

# Je préfère nettement faire un "export" sur les variables qui
# m'intéressent plutôt qu'utiliser cette option, car ça fait un
# peu porkasse quand même...
_unsetopt All_Export

## ``cd'' automatique
# Si la commande n'existe pas et qu'elle correspond à
# un dossier, zsh fait automatiquement un ``cd'' dessus.
# Pour les fainéants qui ont la flemme de taper "cd " :-)
_setopt Auto_Cd

## Envoie le signal CONT aux jobs passés en arrière-plan. 
_setopt Auto_Continue

## Complétion automatique
_setopt Auto_List
_setopt Auto_Menu
# Ces trucs sont pénibles car ils n'autorisent pas une
# complétion "petit à petit".
_unsetopt Menu_Complete
_unsetopt Rec_Exact

_setopt Auto_Param_Keys
_unsetopt Auto_Param_Slash
_unsetopt Cd_Able_Vars
_setopt Complete_Aliases
_setopt Complete_in_Word
_unsetopt Correct
_setopt Correct_All
_unsetopt Equals
_setopt Extended_Glob
_setopt Hash_Cmds
_setopt Hash_Dirs

## Gestion de l'historique
_setopt Extended_History
_setopt Hist_Expire_Dups_First
_setopt Hist_Ignore_All_Dups
_setopt Hist_Ignore_Space
_unsetopt Hist_No_Functions
_unsetopt Hist_No_Store
_setopt Hist_Reduce_Blanks
_setopt Inc_Append_History


_setopt Magic_Equal_Subst
_setopt Mail_Warning
_setopt Mark_Dirs
_setopt No_Bg_Nice
_setopt No_Hup
_setopt No_Prompt_Cr
_setopt Numeric_Glob_Sort
_unsetopt Prompt_Cr
_setopt Auto_Pushd
_setopt Pushd_Ignore_Dups
_setopt Glob

## Gestion de l'UTF-8 !!
_setopt MultiByte
