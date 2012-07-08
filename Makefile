PWD = $(shell pwd)
ZSHRC_SRC = $(PWD)/zsh/rc.sh

.PHONY: zshrc
install: zshrc
	[[ -e ~/.zshrc ]] && mv ~/.zshrc ~/.zshrc.bak; true
	mv .zshrc ~/.zshrc

zshrc: $(ZSHRC_SRC)
	echo "source $(ZSHRC_SRC)" > .zshrc

clean:
	@rm -rf .zshrc