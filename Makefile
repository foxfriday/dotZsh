SELF_DIR=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))
CONF_DIR=$(HOME)/.config/zsh/
CONF_PLG=$(HOME)/.config/zsh/plugs/

all:
	mkdir -p $(CONF_DIR)
	mkdir -p $(CONF_PLG)
	ln -sf $(SELF_DIR)zshenv $(HOME)/.zshenv
	ln -sf $(SELF_DIR)zsh/zshrc.sh $(CONF_DIR).zshrc
	ln -sf $(SELF_DIR)zsh/dircolors.sh $(CONF_DIR)dircolors
	ln -sf $(SELF_DIR)zsh/alias.sh $(CONF_DIR)alias.sh
	ln -sf $(SELF_DIR)forgit/forgit.plugin.zsh $(CONF_PLG)forgit.plugin.zsh
