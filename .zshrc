# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt appendhistory
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/xenol/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Completion
#zstyle ':completion:*:*:*:*:*' menu select
#zstyle ':completion:*:matches' group 'yes'
#zstyle ':completion:*:options' description 'yes'
#zstyle ':completion:*:options' auto-description '%d'
#zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
#zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
#zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
#zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
#zstyle ':completion:*:default' list-prompt '%S%M matches%s'
#zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
#zstyle ':completion:*' group-name ''
#zstyle ':completion:*' verbose yes

# Kill
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# Completion caching
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Ignore system users
zstyle ':completion:*:*:*:users' ignored-patterns _\*

# SSH/SCP/RSYNC
#zstyle ':completion:*:(scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
#zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
#zstyle ':completion:*:ssh:*' tag-order users 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
#zstyle ':completion:*:ssh:*' group-order hosts-domain hosts-host users hosts-ipaddr
#zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
#zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
#zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'


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
#	eval PR_HOST='%{$fg[yellow]%}%m$reset_color'		# no SSH connection
fi

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

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor root line)

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
