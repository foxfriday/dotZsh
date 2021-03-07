SELF_DIR=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

all:
	mkdir -p $(HOME)/.config/zsh
	ln -sf $(SELF_DIR)zshenv $(HOME)/.zshenv
	ln -sf $(SELF_DIR)zsh/zshrc $(HOME)/.config/zsh/.zshrc
	ln -sf $(SELF_DIR)zsh/dircolors $(HOME)/.config/zsh/dircolors
	ln -sf $(SELF_DIR)zsh/functions.sh $(HOME)/.config/zsh/functions.sh
	ln -sf $(SELF_DIR)zsh/day-night-theme.sh $(HOME)/.config/zsh/day-night-theme.sh
