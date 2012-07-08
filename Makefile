PWD = $(shell pwd)
ZSHRC_SRC = $(PWD)/zshrc/src.sh

.PHONY: zshrc
install: zshrc
	[[ -e ~/.zshrc ]] && mv ~/.zshrc ~/.zshrc.bak; true
	mv .zshrc ~/.zshrc

zshrc: $(ZSHRC_SRC)
	ln -fs $(ZSHRC_SRC) .zshrc

clean:
	@rm -rf .zshrc