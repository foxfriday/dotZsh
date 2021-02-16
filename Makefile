SELF_DIR=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

zsh:
	mkdir -p $(HOME)/.zsh.d
	ln -sf $(SELF_DIR)zshenv $(HOME)/.zshenv
	ln -sf $(SELF_DIR)zsh.d/zshrc $(HOME)/.zsh.d/.zshrc
	ln -sf $(SELF_DIR)zsh.d/functions.sh $(HOME)/.zsh.d/functions.sh
	ln -sf $(SELF_DIR)zsh.d/day-night-theme.sh $(HOME)/.zsh.d/day-night-theme.sh
