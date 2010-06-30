# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory nomatch
unsetopt autocd beep notify
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/anomaly/.zshrc'

autoload -Uz compinit promptinit
compinit
promptinit
# End of lines added by compinstall


# key bindings
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
bindkey "^H" backward-delete-word
# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix

export red=$'%{\e[0;31m%}'
export RED=$'%{\e[1;31m%}'
export green=$'%{\e[0;32m%}'
export GREEN=$'%{\e[1;32m%}'
export blue=$'%{\e[0;34m%}'
export BLUE=$'%{\e[1;34m%}'
export purple=$'%{\e[0;35m%}'
export PURPLE=$'%{\e[1;35m%}'
export cyan=$'%{\e[0;36m%}'
export CYAN=$'%{\e[1;36m%}'
export WHITE=$'%{\e[1;37m%}'
export white=$'%{\e[0;37m%}'
export NC=$'%{\e[0m%}' 
export yellow=$'%{\e[0;33m%}'
export YELLOW=$'%{\e[1;33m%}'



alias ls="ls -b --color=auto --file-type -h"
alias ll="ls -l --color=auto --file-type -h"
alias la="ls -a --color=auto --file-type -h"
alias df="df -h"
alias y="yaourt"
alias x="extract"
alias dvd="xine --auto-play --auto-scan dvd"
alias walls="nitrogen ~/Pictures/walls"
alias screenshot="scrot '%Y-%m-%d.png' -q 60"
alias alleyoop="~/bin/alleyoop-0.9.5/src/alleyoop"
alias Ss="pacman -Ss"
alias todo="vim ~/.todo"

## For updating clock
#TMOUT=10
#TRAPALRM () {
	## reset-prompt - this will update the prompt
#	zle reset-prompt
#}

gitb() {echo "$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')"}
## for Git
git_branch_info() {
  #gitb=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')
  ref=$(git-symbolic-ref HEAD 2> /dev/null) || return
  echo "(${ref#refs/heads/})"
}
autoload -U colors
colors
setopt prompt_subst

#PROMPT='${PURPLE}%n${NC}${green}%m${NC} ${white}%~${NC} ${CYAN}>>${NC} '
PROMPT='${PURPLE}%n${NC} ${PURPLE}%~${NC} ${CYAN}>>${NC} '
RPROMPT='${blue}$(gitb)${NC}' # prompt for right side of screen

#export PS2="$(print '%{\e[0;34m%}>%{\e[0m%}')"



#export $TERM=xterm




# extract archives -- usage: extract <file>
extract () {
     if [ "$1" = "" ] || [ "$1" = "-h" ]; then 
         echo -e "${blue}Usage:$NC x <file>";
         echo -e "Extracts <file>";
         return 1
     fi
     for file in "$@" 
     do
     	if [ -f $file ] ; then
           case $file in
                *.tar.bz2)   tar xjf $file        ;;
                *.tar.gz)    tar xzf $file     ;;
		*.tbz2)      tar xjf $file      ;;
                *.tgz)       tar xzf $file       ;;
		*)
         	   case $(file -bi $file) in
             		application/x-bzip2)       	bunzip2 $file 		;;
             		application/rar)       		unrar x $file 		;;
             		application/x-gzip)        	gunzip $file     	;;
             		application/x-tar)       	tar xf $file        	;;
             		application/zip)       		unzip $file     	;;
            		application/x-compressed)       uncompress $file  	;;
             		application/x-7z-compressed)    7z x $file    		;;
             		*) echo -e "${RED}Error:$NC No rule how to extract \"$file\" ($(file -bi $file))" ;;
         	   esac
		;;
    	   esac
     	else
         	echo -e "${RED}Error:$NC \"$file\" doesn't exist"
     	fi
     done
}


