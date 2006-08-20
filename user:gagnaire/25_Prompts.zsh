#!/bin/zsh

unset PS1 PS2 PS3 PS4 RPS1 SPROMPT

PS1="%{[%(!."$PS1_ROOT"."$PS1_USER")m%}%B%~%b%{[0m%} " 
