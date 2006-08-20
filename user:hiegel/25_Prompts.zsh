#!/bin/zsh

PS1="%{[%(!."$PS1_ROOT"."$PS1_USER")m%}%n%{[0m%}@%{[0;%(!."$PS1_ROOT"."$PS1_USER")m%}%y%{[0m%} %(!.%{[1;"$PS1_ROOT"m%}%d%{[0m%}.%{[1;"$PS1_USER"m%}%~%{[0m%})"${LD_PRELOAD:t:s/lib//:r}" "

