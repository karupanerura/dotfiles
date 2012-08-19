PWD            = $(shell pwd)
ZSHRC_SRC      = $(PWD)/zsh/rc.sh
GITCONFIG_SRC  = $(PWD)/git/config
PROVERC_SRC    = $(PWD)/prove/rc
PERLTIDYRC_SRC = $(PWD)/perltidy/rc
TMUXCONF_SRC   = $(PWD)/tmux/conf
SCREENRC_SRC   = $(PWD)/screen/rc

.PHONY: all
all: zsh git prove perltidy screenrc tmuxconf

install: zsh git prove perltidy
	[[ -e ~/.zshrc ]] && mv ~/.zshrc ~/.zshrc.bak; true
	mv .zshrc ~/.zshrc
	[[ -e ~/.gitconfig ]] && mv ~/.gitconfig ~/.gitconfig.bak; true
	mv .gitconfig ~/.gitconfig
	[[ -e ~/.proverc ]] && mv ~/.proverc ~/.proverc.bak; true
	mv .proverc ~/.proverc
	[[ -e ~/.perltidyrc ]] && mv ~/.perltidyrc ~/.perltidyrc.bak; true
	mv .perltidyrc ~/.perltidyrc
	[[ -e ~/.tmux.conf ]] && mv ~/.tmux.conf ~/.tmux.conf.bak; true
	mv .tmux.conf ~/.tmux.conf
	[[ -e ~/.screenrc ]] && mv ~/.screenrc ~/.screenrc.bak; true
	mv .screenrc ~/.screenrc

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

tmuxconf: .tmux.conf
.tmux.conf: $(TMUXCONF_SRC)
	ln -fs $(TMUXCONF_SRC) .tmux.conf

screenrc: .screenrc
.screenrc: $(SCREENRC_SRC)
	ln -fs $(SCREENRC_SRC) .screenrc

clean:
	@rm -rf .zshrc .gitconfig .proverc