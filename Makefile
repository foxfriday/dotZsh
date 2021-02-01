SELF_DIR=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

zsh:
	mkdir -p BUILDIR

	ln -s $(SELF_DIR)zshenv $(HOME)/.zshenv
	ln -s $(SELF_DIR)zsh.d/zshrc $(HOME)/.zsh.d/.zshrc
	ln -s $(SELF_DIR)zsh.d/functions.sh $(HOME)/.zsh.d/functions.sh
	ln -s $(SELF_DIR)zsh.d/day-night-theme.sh $(HOME)/.zsh.d/day-night-theme.sh
