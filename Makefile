PWD = $(shell pwd)
ZSHRC_SRC = $(PWD)/zsh/rc.sh
GITCONFIG_SRC = $(PWD)/git/config
PROVERC_SRC = $(PWD)/prove/rc
PERLTIDYRC_SRC = $(PWD)/perltidy/rc

.PHONY: all
all: zsh git prove perltidy

install: zsh git prove perltidy
	[[ -e ~/.zshrc ]] && mv ~/.zshrc ~/.zshrc.bak; true
	mv .zshrc ~/.zshrc
	[[ -e ~/.gitconfig ]] && mv ~/.gitconfig ~/.gitconfig.bak; true
	mv .gitconfig ~/.gitconfig
	[[ -e ~/.proverc ]] && mv ~/.proverc ~/.proverc.bak; true
	mv .proverc ~/.proverc
	[[ -e ~/.perltidyrc ]] && mv ~/.perltidyrc ~/.perltidyrc.bak; true
	mv .perltidyrc ~/.perltidyrc

zsh: .zshrc
.zshrc: $(ZSHRC_SRC)
	echo "source $(ZSHRC_SRC)" > .zshrc

git: .gitconfig
.gitconfig: $(GITCONFIG_SRC)
	ln -fs $(GITCONFIG_SRC) .gitconfig

perl: prove perltidy

prove: .proverc
.proverc: $(PROVERC_SRC)
	ln -fs $(PROVERC_SRC) .proverc

perltidy: .perltidyrc
.perltidyrc: $(PERLTIDYRC_SRC)
	ln -fs $(PERLTIDYRC_SRC) .perltidyrc

clean:
	@rm -rf .zshrc .gitconfig .proverc