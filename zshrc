HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

zstyle :compinstall filename '/home/xenol/.zshrc'

fpath=(~/.zsh/plguins/zsh-completions/src $fpath)

autoload -Uz compinit
compinit

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
zstyle ':completion:*:*:*:*:processes' command "ps -u ${USER} -o pid,user,comm -w -w"
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

# Custom zsh options
setopt appendhistory
setopt hist_ignore_all_dups
setopt nohashcmds
setopt nohashdirs
setopt rmstarsilent
setopt interactivecomments
setopt nobeep

# Useful stuff
export LANG=en_US.UTF-8

case ${OSTYPE} in
	darwin*)
		export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/bin
	;;
	*)
		export PATH=$PATH:$HOME/bin
	;;
esac

export PAGER=less
export EDITOR=vim

# Aliases
case "${OSTYPE}" in
	freebsd*|darwin*)
		alias ls="ls -G"
	;;
	linux-gnu)
		eval `dircolors -b`
		alias ls="ls --color"
	;;
esac

alias grep="grep --color=auto"
alias egrep="grep --color=auto"
alias vi=vim

# Prompt
autoload -U colors zsh/terminfo
colors
setopt prompt_subst

# Colors
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

# VCS
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats ' (%b)'
zstyle ':vcs_info:*' actionformats ' (%b|%a)'

precmd() {
    vcs_info
}

PS1='%n@${PR_HOST} %c${vcs_info_msg_0_} %# '
PS2=$'%_> '

# Keybindings
bindkey -e
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

# Syntax highlighting plugin
if [[ -e ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
	source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# History substring search plugin
if [[ -e ~/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
	source ~/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

	bindkey '^[[A' history-substring-search-up
	bindkey '^[[B' history-substring-search-down
fi

# Autosuggestion plugin
if [[ -e ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
	source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# virtualenvwrapper support
if command -V virtualenvwrapper_lazy.sh >/dev/null 2>&1; then
	export WORKON_HOME=$HOME/.virtualenvs
	export PROJECT_HOME=$HOME/Development
	source $(command -v virtualenvwrapper_lazy.sh)
fi
