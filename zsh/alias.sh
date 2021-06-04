## --------------------------------------------------------------
## Aliases
## --------------------------------------------------------------
alias cp='cp -i'      # Confirm before overwriting something
alias mv='mv -i'      # Confirm bevore overwriting something
alias df='df -h'      # Human-readable sizes
alias du='du -h'      # Human-readable sizes
alias free='free -m'  # Show sizes in MB
alias dict='sdcv'     # Look up words
alias pvpn='sudo ~/.pyenv/versions/protonvpn/bin/protonvpn'
alias vim='nvim'

## --------------------------------------------------------------
## System Dependent Aliases and Functions
## --------------------------------------------------------------
case "$OSTYPE" in
    linux*)
        export BROWSER="firefox"
        alias open='xdg-open'
        alias pbcopy='xclip -selection clipboard'
        alias pbpaste='xclip -selection clipboard -o'
        # modify LS_COLORS if you want different colors with ls
	## You can get the base file with dircolors --print-database > dircolors
	eval $(dircolors --b $ZDOTDIR/dircolors)
        alias ls="ls --color"
        ;;
    darwin*)
        export BROWSER="/usr/bin/open -a /Applications/Firefox.app"
        alias xdg-open="open -a"
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
