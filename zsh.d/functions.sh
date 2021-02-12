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
## FZF
## --------------------------------------------------------------
# Passwords
fpass () {
    [[ -z "${PASSWORD_STORE_DIR}" ]] && pdir=~/.password-store || pdir="${PASSWORD_STORE_DIR}"
    name=$(find "$pdir" -type f -iname \*.gpg \
                -exec realpath --relative-to "$pdir" {} \; |
               fzf -i -e +s \
                   --reverse \
                   --ansi \
                   --no-multi \
                   --height 20%)
    name=${name%.gpg}
    if [ ! -z "$name" -a "$name" != " " ]; then
        pass "$@" "$name"
    fi
}

# Notes
alias pnotes='PASSWORD_STORE_DIR=~/.password-notes pass'
alias fnotes='PASSWORD_STORE_DIR=~/.password-notes fpass'

# Search pdf, etc documents with preview
frga () {
    rga --files-with-matches "." |
        fzf -i -e +s \
            --reverse \
            --ansi \
            --phony \
            --preview="rga --pretty --context 4 {q} {}" \
            --preview-window="75%:wrap" \
            --header "enter: view, C-c: copy" \
            --bind="change:reload([[ ! -z {} ]] && rga --files-with-matches {q})" \
            --bind="ctrl-c:execute-silent(echo {} | pbcopy)+accept" \
            --bind="enter:execute(open {})+accept"
}

## --------------------------------------------------------------
## Git
## --------------------------------------------------------------
fgit () {
    _gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
    _viewGitShow="xargs -I % sh -c 'git show --color=always % |
                  diff-so-fancy'"
    _viewGitLogLine="$_gitLogLineToHash | $_viewGitShow"
    _viewGitLogLineUnfancy="$_gitLogLineToHash | xargs -I % sh -c 'git show %'"
    git hist "$@" |
        fzf -i -e +s \
            --reverse \
            --tiebreak=index \
            --no-multi \
            --ansi \
            --preview="echo {} |
                       grep -o '[a-f0-9]\{7\}' |
                       head -1 |
                       $_viewGitShow" \
             --header="enter: view, C-c: copy hash" \
             --bind="enter:execute:$_viewGitLogLine | less -R" \
             --bind="ctrl-c:execute-silent:$_gitLogLineToHash |
                     pbcopy"
}

fadd() {
    git ls-files -m -o --exclude-standard "$@" |
        fzf -i -e +s \
            --reverse \
            --no-multi \
            --ansi \
            --header "enter: view, C-c: add" \
            --preview="git --no-pager diff --color=always {} | diff-so-fancy" \
            --bind="enter:execute(git diff {})" \
            --bind "ctrl-c:execute-silent(git add {})"
}

## --------------------------------------------------------------
## Todoman
## --------------------------------------------------------------
ftodo() {
    _todoId="echo {} | grep -o '^[0-9]\+'"
    todo list "$@" |
        fzf -i -e +s \
            --reverse \
            --no-multi \
            --ansi \
            --phony \
            --preview="$_todoId | xargs todo show " \
            --header "C-a: cancel, C-d: done, enter: copy id" \
            --bind="change:reload:([[ ! -z {} ]] && todo list --grep {q})" \
            --bind="ctrl-a:execute($_todoId | xargs todo cancel)+accept" \
            --bind="ctrl-d:execute($_todoId | xargs todo done)+accept" \
            --bind="enter:execute($_todoId | pbcopy)+accept"
}
