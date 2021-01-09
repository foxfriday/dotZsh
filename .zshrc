## --------------------------------------------------------------
## Path
## --------------------------------------------------------------
typeset -U PATH path fpath  # Discard multiple entries
path+=$HOME/.local/bin
## --------------------------------------------------------------
## Defaults
## --------------------------------------------------------------
export LC_ALL=en_US.UTF-8  # Language and locale
export CLICOLOR=1          # Color
setopt numericglobsort     # Sort filenames numerically when it makes sense
setopt extendedglob        # Globbing. Allows using regular expressions with *
setopt nocaseglob          # Case insensitive globbing
setopt rcexpandparam       # Array expension with parameters
setopt nobeep              # No beep
## --------------------------------------------------------------
## Gpg
## --------------------------------------------------------------
## Start agent manually so that we can use the agent to manage SSH keys. See:
## https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
export GPG_TTY=$(tty)
gpg-connect-agent /bye
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
## --------------------------------------------------------------
## History
## --------------------------------------------------------------
HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=1000
SAVEHIST=500
setopt appendhistory       # Immediately append history instead of overwriting
setopt histignorealldups   # If a command is a duplicate, remove the older one
## --------------------------------------------------------------
## Vimify zsh
## --------------------------------------------------------------
export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim
bindkey '^[[3~' delete-char     # Delete key
bindkey '^[[C'  forward-char    # Right key
bindkey '^[[D'  backward-char   # Left key
bindkey '^[[Z'  undo            # Shift+tab undo last action
bindkey -v                      # Vim bindings
KEYTIMEOUT=1                    # No mode switching delay
# Allow commands in editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line
# Change cursor based on mode
# 1 -> blinking block
# 2 -> solid block
# 3 -> blinking underscore
# 4 -> solid underscore
# 5 -> blinking vertical bar
# 6 -> solid vertical bar
echo -ne '\e[6 q'
function zle-keymap-select () {
    if [[ ${KEYMAP} == vicmd ]]; then # ||
      echo -ne '\e[1 q'
else
      echo -ne '\e[6 q'
    fi
}
zle -N zle-keymap-select
## --------------------------------------------------------------
## Aliases
## --------------------------------------------------------------
alias cp='cp -i'      # Confirm before overwriting something
alias mv='mv -i'      # Confirm bevore overwriting something
alias df='df -h'      # Human-readable sizes
alias du='du -h'      # Human-readable sizes
alias free='free -m'  # Show sizes in MB
alias dict='sdcv'     # Look up words
## --------------------------------------------------------------
## Functions
## --------------------------------------------------------------
# Extract
ex () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
# Shred entire directory
shreddir() {
        find $1 -type f -exec shred {} \;
        rm -r $1
}
# Find the directory that contains a file
findfile () {
        find $1 -name $2 | xargs -n1 dirname
}
## --------------------------------------------------------------
## System Dependent Aliases and Functions
## --------------------------------------------------------------
case "$OSTYPE" in
    linux*)
        # modify LS_COLORS if you want different colors with ls
        alias ls="ls --color"
        ;;
    darwin*)
        # modify LSCOLOR if you want different colors with ls
        alias ls="ls -GO"
        # quick update
        alias update="sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup;"
        # empty trashes, logs, and download history
        cleanup () {
            sudo rm -rfv /Volumes/*/.Trashes
            sudo rm -rfv ~/.Trash
            sudo rm -rfv /private/var/log/asl/*.asl
            sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'
        }
        # umount doesn't work on darwin, not to mention the os pukes on drives
        clean_unmount () {
            if mount | grep $1 > /dev/null; then
                if [ -d "$1/.fseventsd" ]; then
                    rm -r "$1/.fseventsd"
                fi
                if [ -d "$1/.Trashes" ]; then
                    rm -r "$1/.Trashes"
                fi
                if [ -d "$1/.DS_Store" ]; then
                    rm -r "$1/.DS_Store"
                fi
                if [ -d "$1/.Spotlight-V100" ]; then
                    rm -r "$1/.Spotlight-V100"
                fi
                diskutil umount $1
            else
                echo "Not a mount"
            fi
        }
        alias umount="clean_unmount"
        ;;
esac
## --------------------------------------------------------------
## Prompt
## --------------------------------------------------------------
NEWLINE=$'\n'
PROMPT="%F{green}%~%f${NEWLINE}%(?.%F{blue}>%f.%F{red}>%f)"
## --------------------------------------------------------------
## Pyenv
## --------------------------------------------------------------
if command -v pyenv 1>/dev/null 2>&1; then
    # disable prompt mangling when activating an environment
    export VIRTUAL_ENV_DISABLE_PROMPT=1
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    # Re evaluate prompt function
    setopt PROMPT_SUBST
    print_prompt () {
        if [[ -v VIRTUAL_ENV ]]; then
            echo "%F{magenta}($(basename $VIRTUAL_ENV))%f%F{green}%~%f${NEWLINE}%(?.%F{blue}>%f.%F{red}>%f)"
        else
            echo "%F{green}%~%f${NEWLINE}%(?.%F{blue}>%f.%F{red}>%f)"
        fi
    }
    PROMPT='$(print_prompt)'
fi
## --------------------------------------------------------------
## Brew
## --------------------------------------------------------------
if type brew &>/dev/null; then
    path+=/usr/local/sbin
    fpath+=$(brew --prefix)/share/zsh/site-functions
    if command -v pyenv 1>/dev/null 2>&1; then
        # make pyenv work well with brew
        # see: https://github.com/pyenv/pyenv/issues/106
        alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
    fi
    # Assumes you bzip2, zlib, and openblas installed, all required by Python
    export LDFLAGS="-L/usr/local/opt/bzip2/lib -L/usr/local/opt/zlib/lib -L/usr/local/opt/openblas/lib -L/usr/local/opt/llvm/lib"
    export CPPFLAGS="-I/usr/local/opt/bzip2/include -I/usr/local/opt/zlib/include -I/usr/local/opt/openblas/include -I/usr/local/opt/llvm/include"
    export PKG_CONFIG_PATH="/usr/local/opt/openblas/lib/pkgconfig"
    OPENBLAS="$(brew --prefix openblas)"
fi
## --------------------------------------------------------------
## Autocompletion
## --------------------------------------------------------------
# Case insensitive tab completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# automatically find new executables in path
zstyle ':completion:*' rehash true
# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.local/zsh/cache
# Don't consider certain characters part of the word
WORDCHARS=${WORDCHARS//\/[&.;]}
# Autocomplete aliases
setopt COMPLETE_ALIASES
# Enable autocompletion
autoload -Uz compinit
compinit
## --------------------------------------------------------------
## Plugins
## --------------------------------------------------------------
## Auto suggestions
## --------------------------------------------------------------
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
## --------------------------------------------------------------
## Search History
## --------------------------------------------------------------
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
## --------------------------------------------------------------
## Syntax Highlight
## --------------------------------------------------------------
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters
## --------------------------------------------------------------
## Theme
## --------------------------------------------------------------
toggletheme ()
{
    if [ "$SHELL_DAY_THEME" != true ]; then
        export SHELL_DAY_THEME=true
    else
        export SHELL_DAY_THEME=false
    fi
    source $ZDOTDIR/day-night-theme.sh
}
export SHELL_DAY_THEME=true
source $ZDOTDIR/day-night-theme.sh
## --------------------------------------------------------------
## Emacs' Vterm
## --------------------------------------------------------------
vterm_printf(){
    if [ -n "$TMUX" ]; then
        # Tell tmux to pass the escape sequences through
        # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}
if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
    alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'
fi
vterm_prompt_end() {
    vterm_printf "51;A$(whoami)@$(hostname):$(pwd)";
}
