PWD = $(shell pwd)
ZSHRC_SRC = $(PWD)/zsh/rc.sh
GITCONFIG_SRC = $(PWD)/git/config
PROVERC_SRC = $(PWD)/prove/rc

.PHONY: all
all: zsh git prove

install: zsh git prove
	[[ -e ~/.zshrc ]] && mv ~/.zshrc ~/.zshrc.bak; true
	mv .zshrc ~/.zshrc
	[[ -e ~/.gitconfig ]] && mv ~/.gitconfig ~/.gitconfig.bak; true
	mv .gitconfig ~/.gitconfig
	[[ -e ~/.proverc ]] && mv ~/.proverc ~/.proverc.bak; true
	mv .proverc ~/.proverc

zsh: .zshrc
.zshrc: $(ZSHRC_SRC)
	echo "source $(ZSHRC_SRC)" > .zshrc

git: .gitconfig
.gitconfig: $(GITCONFIG_SRC)
	ln -fs $(GITCONFIG_SRC) .gitconfig

prove: .proverc
.proverc: $(PROVERC_SRC)
	ln -fs $(PROVERC_SRC) .proverc

clean:
	@rm -rf .zshrc .gitconfig .proverc