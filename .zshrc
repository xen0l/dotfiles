# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/xenol/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Custom zsh options
setopt hist_ignore_all_dups
setopt nohashcmds
setopt nohashdirs
setopt rmstarsilent
setopt interactivecomments
setopt nobeep

# Useful stuff

export LANG=en_US.UTF-8

case $OSTYPE in 

darwin*)
	export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/bin
;;

*)
	export PATH=$PATH:$HOME/bin
;;

esac

export SHELL=`which zsh`
export PAGER=less
export EDITOR=vim

# Aliases

case "$OSTYPE" in

freebsd*|darwin*)
	alias ls="ls -G"
;;

linux-gnu)
	eval `dircolors -b`
	alias ls="ls --color"
;;
esac

alias la="ls -A"
alias grep="grep --color=auto"
alias egrep="grep --color=auto"

alias vi=vim

# Prompt

autoload -U colors zsh/terminfo
colors
setopt prompt_subst

for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
	eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
	eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'

	export PR_$color
	export PR_LIGHT_$color
done

export PR_NO_COLOR="%{$terminfo[sgr0]%}"

# Check if we are connected via SSH or not
if [[ -n "$SSH_CLIENT" || -n "$SSH2_CLIENT" ]]; then
	eval PR_HOST='${PR_MAGENTA}%m${PR_NO_COLOR}'		# SSH connection
else
	eval PR_HOST='${PR_NO_COLOR}%m${PR_NO_COLOR}'		# no SSH connection
fi

# 
PS1='%n@${PR_HOST} %c %# '
PS2=$'%_> '

# Keybindings
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey '^R' history-incremental-search-backward

#case "$TERM" in
#    *xterm*|rxvt|rxvt-unicode|rxvt-256color|(dt|k|E)term)
#		precmd () { print -Pn "\e]0;%n@%m\:%~\a" } 
#		preexec () { print -Pn "\e]0;%n@%m\:%~ $1\a" }
#	;;
#    
#    screen)
#	precmd () { 
#			print -Pn "\e]83;title \"$1\"\a" 
#			print -Pn "\e]0;%n@%m\:%~\a" 
#		}
#	preexec () { 
#			print -Pn "\e]83;title \"$1\"\a" 
#			print -Pn "\e]0;%n@%m $1\a" 
#		}
#	;; 
#esac
