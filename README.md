
# .zshrc

Configuration for the Z shell (zsh). It requires three plugins:

 - zsh-autosuggestions
 - zsh-history-substring-search
 - zsh-syntax-highlighting

It adds a minimal prompt, which doesn't do or tell you much, thought it look like the pure prompt. It also has a day and a night theme which can be toggled with `toggletheme`. The themes are based on the base16 tomorrow themes. Bindings try to approach those used in vim with some limited success.

To install use `make all`.

## Set as Default

Make sure that zsh is installed by running `chsh -l`. This will give you a list of available shells. Then you can chang the shell with `chsh -s <full path>`. This path is usually `/usr/bin/zsh`. After doing this you may want to move some of the code from `bashrc` to `zshrc` and from `.bash_profile` to `.zprofile`.
