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

# Funky run-help hooks
autoload run-help-git
autoload run-help-svn

function SetOPT() {
	SetOPTifExists $1 on
}
function UnsetOPT() {
	SetOPTifExists $1 off
}

function SetOPTifExists() {
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
				__debug "setopt $option"
				setopt $option
				;;
			off)
				__debug "unsetopt $option"
				unsetopt $option
				;;
		esac
	else
		__debug "$option not supported by this version of zsh !"
	fi
}



# J'ai pas très bien compris mais en gros ça va me permettre
# d'être sûr de retrouver ma commande dans tous les cas...
SetOPT ALWAYS_LAST_PROMPT

SetOPT ALWAYS_TO_END

# Je préfère nettement faire un "export" sur les variables qui
# m'intéressent plutôt qu'utiliser cette option, car ça fait un
# peu porkasse quand même...
UnsetOPT ALL_EXPORT

## ``cd'' automatique
# Si la commande n'existe pas et qu'elle correspond à
# un dossier, zsh fait automatiquement un ``cd'' dessus.
# Pour les fainéants qui ont la flemme de taper "cd " :-)
SetOPT AUTO_CD

## Envoie le signal CONT aux jobs passés en arrière-plan. 
SetOPT AUTO_CONTINUE

## Complétion automatique
SetOPT AUTO_LIST
SetOPT AUTO_MENU
# Ces trucs sont pénibles car ils n'autorisent pas une
# complétion "petit à petit".
UnsetOPT MENU_COMPLETE
UnsetOPT REC_EXACT

SetOPT AUTO_PARAM_KEYS
UnsetOPT AUTO_PARAM_SLASH
UnsetOPT CD_ABLE_VARS
SetOPT COMPLETE_ALIASES
SetOPT COMPLETE_IN_WORD
UnsetOPT CORRECT
SetOPT CORRECT_ALL
UnsetOPT EQUALS
SetOPT EXTENDED_GLOB
SetOPT HASH_CMDS
SetOPT HASH_DIRS

SetOPT BRACECCL # EXPANSION DES CLASSES DE CARACTÈRES, COMME {A-Z} AU MÊME TITRE QUE {00..99}

## Gestion de l'historique
SetOPT EXTENDED_HISTORY
SetOPT HIST_EXPIRE_DUPS_FIRST
SetOPT HIST_IGNORE_ALL_DUPS
SetOPT HIST_IGNORE_SPACE
UnsetOPT HIST_NO_FUNCTIONS
UnsetOPT HIST_NO_STORE
SetOPT HIST_REDUCE_BLANKS
SetOPT INC_APPEND_HISTORY


SetOPT MAGIC_EQUAL_SUBST
SetOPT MAIL_WARNING
SetOPT MARK_DIRS
UnsetOPT MULTI_OS
SetOPT NO_BG_NICE
SetOPT NO_HUP
SetOPT NO_PROMPT_CR
SetOPT NUMERIC_GLOB_SORT
UnsetOPT PROMPT_CR
SetOPT AUTO_PUSHD
SetOPT PUSHD_IGNORE_DUPS
SetOPT GLOB

## Gestion de l'UTF-8 !!
SetOPT MULTIBYTE
