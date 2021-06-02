ZDOTDIR=$HOME/.config/zsh

case "$OSTYPE" in
    linux*)
	PLUGINS=/usr/share/zsh/plugins
	FZFPATH=/usr/share/fzf
        ;;
    darwin*)
	PLUGINS=/usr/local/share
	FZFPATH=/usr/local/opt/fzf/shell
        ;;
esac
