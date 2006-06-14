#!/bin/zsh

## Zsh options
#
# zshoptions(1)
#

# J'ai pas très bien compris mais en gros ça va me permettre
# d'être sûr de retrouver ma commande dans tous les cas...
setopt Always_Last_Prompt

setopt Always_to_End

# Je préfère nettement faire un "export" sur les variables qui
# m'intéressent plutôt qu'utiliser cette option, car ça fait un
# peu porkasse quand même...
unsetopt All_Export

## ``cd'' automatique
# Si la commande n'existe pas et qu'elle correspond à
# un dossier, zsh fait automatiquement un ``cd'' dessus.
setopt Auto_Cd

## Envoie le signal CONT aux jobs passés en arrière-plan. 
setopt Auto_Continue

## Complétion automatique
setopt Auto_List
unsetopt Auto_Menu
setopt Menu_Complete

setopt Auto_Param_Keys
unsetopt Auto_Param_Slash
unsetopt Cd_Able_Vars
setopt Complete_Aliases
setopt Complete_in_Word
unsetopt Correct
setopt Correct_All
unsetopt Equals
unsetopt Extended_Glob
unsetopt Extended_History
setopt Hash_Cmds
setopt Hash_Dirs

## Gestion de l'historique
setopt Hist_Expire_Dups_First
setopt Hist_Ignore_All_Dups
setopt Hist_Ignore_Space
setopt Hist_No_Functions
setopt Hist_No_Store
setopt Hist_Reduce_Blanks
setopt Inc_Append_History


setopt Magic_Equal_Subst
setopt Mail_Warning
setopt Mark_Dirs
setopt No_Bg_Nice
setopt No_Hup
setopt No_Prompt_Cr
setopt Numeric_Glob_Sort
unsetopt Prompt_Cr
setopt Pushd_Ignore_Dups
