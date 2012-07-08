PWD = $(shell pwd)
ZSHRC_SRC = $(PWD)/zsh/rc.sh
GITCONFIG_SRC = $(PWD)/git/config

.PHONY: zsh git
install: zsh
	[[ -e ~/.zshrc ]] && mv ~/.zshrc ~/.zshrc.bak; true
	mv .zshrc ~/.zshrc
	[[ -e ~/.gitconfig ]] && mv ~/.gitconfig ~/.gitconfig.bak; true
	mv .gitconfig ~/.gitconfig

zsh: .zshrc
.zshrc: $(ZSHRC_SRC)
	echo "source $(ZSHRC_SRC)" > .zshrc

git: .gitconfig
.gitconfig: $(GITCONFIG_SRC)
	ln -fs $(GITCONFIG_SRC) .gitconfig

clean:
	@rm -rf .zshrc