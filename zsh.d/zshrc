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
GPG_TTY=$(tty)
export GPG_TTY
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
## fzf
## --------------------------------------------------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
## --------------------------------------------------------------
## Personal Functions and Aliases
## --------------------------------------------------------------
source $ZDOTDIR/functions.sh
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
