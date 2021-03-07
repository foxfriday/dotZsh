SELF_DIR=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))
CONF_DIR=$(HOME)/.config/zsh/
CONF_PLG=$(HOME)/.config/zsh/plugs/

all:
	mkdir -p $(CONF_DIR)
	mkdir -p $(CONF_PLG)
	ln -sf $(SELF_DIR)zshenv $(HOME)/.zshenv
	ln -sf $(SELF_DIR)zsh/zshrc $(CONF_DIR).zshrc
	ln -sf $(SELF_DIR)zsh/dircolors $(CONF_DIR)dircolors
	ln -sf $(SELF_DIR)zsh/functions.sh $(CONF_DIR)functions.sh
	ln -sf $(SELF_DIR)zsh/day-night-theme.sh $(CONF_DIR)day-night-theme.sh
	ln -sf $(SELF_DIR)forgit/forgit.plugin.zsh $(CONF_PLG)forgit.plugin.zsh
