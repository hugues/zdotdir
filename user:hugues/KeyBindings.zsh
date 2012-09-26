zstyle ':zle:replace-pattern' edit-previous false
autoload -Uz replace-string
autoload -Uz replace-string-again
zle -N replace-pattern replace-string
zle -N replace-string-again

### vi-mode.zsh - example vi mode setup for zsh.
###
### Zsh's line editor has two built-in editing models. One is modeled
### after the `emacs' editor's input system, the other is modeled after
### the `vi' editor's modal input mode.
###
### To use the latter, it is helpful to track the current input mode
### and update the prompt dynamically to reflect the current mode at
### all times.
###
### This setup tracks the current mode in `$psvar[x]', which is
### available in prompts in the `%xv' expansion. It'll be one of the
### following strings:
###
###    "i"  - insert mode
###    "c"  - command mode
###    "im" - insert mode, with a minibuffer being active
###    "cm" - ditto, but for command mode
###    "r"  - replace mode: insert mode with the overwrite bit set.
###
### The `x' is configurable via the `psvmodeidx' variable below.
###
### The code in this file requires zsh version 4.3.1 or newer.
###
### Copyright (c) 2010, Frank Terbeck <ft@bewatermyfriend.org>
### The same licensing terms as with zsh apply.

############################################################################
### CONFIGURATION ##########################################################

# Use either `ins' or `cmd' as the default input mode.
zle_default_mode='ins'

# This defines in which index of `$psvar[]' the information is tracked.
# The default is `1'. Set this to whatever fits you best.
psvmodeidx='8'

# If this is set to `yes', use `C-d' instead of `ESC' to switch from insert
# mode to command mode. `ESC' may require a timeout to actually take effect.
# Using `C-d' will work immediately. Therefore that is the default.
zle_use_ctrl_d='yes'

# If set to `yes', make viins mode behave more like `emacs' mode. Bindings
# such as `^r' and `^s' will work. Backspace and `^w' will work more like
# emacs would, too.
zle_ins_more_like_emacs='no'

# This is an example prompt to show how this can be used. Yours may
# obviously be a lot more colourful and whatnot. As ugly as you like.
#PS1='%(?..[%?]-)%1v-(%!) %3~ %% '

############################################################################
### MODE SETUP - Do not change anything below! #############################

# Create _functions[] arrays for `zle-line-init', `zle-line-finish'
# and `zle-keymap-select', too. Analogous to precmd_functions[]
# etc. The actual functions only cycle through these arrays and
# execute all existing functions in order.
typeset -ga zle_init_functions
typeset -ga zle_finish_functions
typeset -ga zle_keymap_functions

# This is an associative array, that tracks the current zle
# state. This may contain the following key-value pairs:
#      minibuffer  - values: yes/no; yes if a minibuffer is active.
#      overwrite   - values: yes/no; yes if zle is in overwrite mode.
typeset -gA ft_zle_state


# We're not in overwrite mode, when zsh starts.
ft_zle_state[overwrite]=no

# When this is hooked into `zle-keymap-select', keymap changes are
# correctly tracked in `psvar[x]', which may be used in PS1 as `%xv'.
function ft-psvx() {
    if [[ ${ft_zle_state[minibuffer]} == yes ]]; then
        if [[ ${psvar[$psvmodeidx]} != *m ]]; then
            psvar[$psvmodeidx]="${psvar[$psvmodeidx]}+"
        fi
    else
        case ${KEYMAP} in
            vicmd) psvar[$psvmodeidx]='ESC';;
            *)
                if [[ ${ft_zle_state[overwrite]} == yes ]]; then
                    psvar[$psvmodeidx]='REP'
                else
                    psvar[$psvmodeidx]=''
                fi
                ;;
        esac
    fi
    zle 'reset-prompt'
}

# This needs to be hooked into `zle-line-finish' to make sure the next
# newly drawn prompt has the correct mode display.
function ft-psvx-default() {
    if [[ ${zle_default_mode} == 'cmd' ]]; then
        psvar[$psvmodeidx]='ESC'
    else
        psvar[$psvmodeidx]=''
    fi
}
# This makes sure the first prompt is drawn correctly.
ft-psvx-default

# Need to handle SIGINT, too (which is sent by ^C).
# If we don't do this, being in a minibuffer and pressing ^C confuses
# the zle state variable; the `minibuffer' state won't be turned off.
function TRAPINT() {
    ft_zle_state[minibuffer]=no
    ft-psvx-default
    zle reset-prompt 2>/dev/null
    return 127
}

# If a keymap change is done, we do need a status update, obviously.
zle_keymap_functions=( "${zle_keymap_functions[@]}" ft-psvx )
# When a command line finishes, the next keyboard mode needs to be set
# up, so that `psvar[x]' is correct when the next prompt is drawn.
zle_finish_functions=( "${zle_finish_functions[@]}" ft-psvx-default )
if [[ ${zle_default_mode} == 'cmd' ]]; then
    # We cannot simply link `vicmd' to `main'. If we'd do that the
    # whole input system could not be set into insert mode. See the
    # zshzle(1) manual for details.  To make vicmd the default mode
    # for new command lines, we simply turn it on in `zle-line-init()'.
    zle_init_functions=( "${zle_init_functions[@]}" ft-vi-cmd )
fi

function zle-line-init() {
    local w
    for w in "${zle_init_functions[@]}"; do
        (( ${+functions[$w]} )) && "$w"
    done
}
zle -N zle-line-init
function zle-line-finish() {
    local w
    for w in "${zle_finish_functions[@]}"; do
        (( ${+functions[$w]} )) && "$w"
    done
}
zle -N zle-line-finish
function zle-keymap-select() {
    local w
    for w in "${zle_keymap_functions[@]}"; do
        (( ${+functions[$w]} )) && "$w"
    done
}
zle -N zle-keymap-select

# Link `viins' to `main'.
bindkey -v

############################################################################
### VI WIDGETS #############################################################

# This setup may change the `ESC' keybinding to `C-d'. That defeats the
# possibility to exit zsh by pressing `C-d' (which usually sends EOF).
# With this widget, you can type `:q<RET>' to exit the shell from vicmd.
function ft-zshexit {
    [[ -o hist_ignore_space ]] && BUFFER=' '
    BUFFER="${BUFFER}exit"
    zle .accept-line
}
zle -N q ft-zshexit

# First the ones that change the input method directly; namely cmd mode,
# insert mode and replace mode.
function ft-vi-replace() {
    ft_zle_state[overwrite]=yes
    zle vi-replace
    ft-psvx
}

function ft-vi-insert() {
    ft_zle_state[overwrite]=no
    zle vi-insert
}

# Since I want to bind `vi-cmd-mode' to Ctrl-D (which is what I'm doing in
# vim and emacs-viper, too) I need to wrap this widget into a user-widget,
# because only those have an effect with empty command buffers and bindings
# to the key, which sends `EOF'. This also needs the ignore_eof option set.
function ft-vi-cmd() {
    ft_zle_state[overwrite]=no
    zle vi-cmd-mode
}

function ft-vi-cmd-cmd() {
    zle -M 'Use `:q<RET>'\'' to exit the shell.'
}

# ...and now the widgets that open minibuffers...
# Oh, yeah. You cannot wrap `execute-named-cmd', so no minibuffer-signaling
# for that. See <http://www.zsh.org/mla/workers/2005/msg00384.html>.
function ft-markminibuf() {
    ft_zle_state[minibuffer]=yes
    ft-psvx
    zle "$1"
    ft_zle_state[minibuffer]=no
    ft-psvx
}

if (( ${+widgets[.history-incremental-pattern-search-backward]} )); then
    function history-incremental-pattern-search-backward() {
        ft-markminibuf .history-incremental-pattern-search-backward
    }
else
    function history-incremental-search-backward() {
        ft-markminibuf .history-incremental-search-backward
    }
fi

if (( ${+widgets[.history-incremental-pattern-search-forward]} )); then
    function history-incremental-pattern-search-forward() {
        ft-markminibuf .history-incremental-pattern-search-forward
    }
else
    function history-incremental-search-forward() {
        ft-markminibuf .history-incremental-search-forward
    }
fi

function ft-vi-search-back() {
    ft-markminibuf vi-history-search-backward
}

function ft-vi-search-fwd() {
    ft-markminibuf vi-history-search-forward
}

function ft-replace-pattern() {
    ft-markminibuf replace-pattern
}

# register the created widgets
for w in \
    ft-replace-pattern \
    ft-vi-{cmd,cmd-cmd,replace,insert,search-back,search-fwd}
do
    zle -N "$w"
done; unset w

############################################################################
### ALTERED KEYBINDINGS ####################################################

source $ZDOTDIR/user:hugues/GusBindings.zsh

if [[ ${zle_use_ctrl_d} == 'yes' ]]; then
    # Remove the escape key binding.
    bindkey -r '^['
fi
bindkey -M viins '^d' ft-vi-cmd
bindkey -M vicmd '^d' ft-vi-cmd-cmd
setopt ignore_eof

bindkey -M vicmd '/'   ft-vi-search-fwd
bindkey -M vicmd '?'   ft-vi-search-back
bindkey -M vicmd 'i'   ft-vi-insert
bindkey -M vicmd 'R'   ft-vi-replace

# The following four widgets require something like the following, to
# load and initialise the `replace-pattern' and `replace-string-again'
# widgets:
#
# zstyle ':zle:replace-pattern' edit-previous false
# autoload -Uz replace-string
# autoload -Uz replace-string-again
# zle -N replace-pattern replace-string
# zle -N replace-string-again
#
# ...and that *before* this file is sourced.

if (( ${+widgets[replace-pattern]} )); then
    bindkey -M vicmd '^x,' ft-replace-pattern
    bindkey -M viins '^x,' ft-replace-pattern
fi

if (( ${+widgets[replace-string-again]} )); then
    bindkey -M vicmd '^x.' replace-string-again
    bindkey -M viins '^x.' replace-string-again
fi

if [[ ${zle_ins_more_like_emacs} == 'yes' ]]; then
    if (( ${+widgets[.history-incremental-pattern-search-backward]} )); then
        bindkey -M viins '^r' history-incremental-pattern-search-backward
        bindkey -M vicmd '^r' history-incremental-pattern-search-backward
    else
        bindkey -M viins '^r' history-incremental-search-backward
        bindkey -M vicmd '^r' history-incremental-search-backward
    fi
    if (( ${+widgets[.history-incremental-pattern-search-forward]} )); then
        bindkey -M viins '^s' history-incremental-pattern-search-forward
        bindkey -M vicmd '^s' history-incremental-pattern-search-forward
    else
        bindkey -M viins '^s' history-incremental-search-forward
        bindkey -M vicmd '^s' history-incremental-search-forward
    fi
    bindkey -M vicmd '^[h' run-help
    bindkey -M viins '^[h' run-help
    bindkey -M viins '^p'  up-line-or-history
    bindkey -M viins '^n'  down-line-or-history
    bindkey -M viins '^w'  backward-kill-word
    bindkey -M viins '^h'  backward-delete-char
    bindkey -M viins '^?'  backward-delete-char
fi

true
