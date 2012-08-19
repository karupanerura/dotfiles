PWD            = $(shell pwd)
ZSHRC_SRC      = $(PWD)/zsh/rc.sh
GITCONFIG_SRC  = $(PWD)/git/config
PROVERC_SRC    = $(PWD)/prove/rc
PERLTIDYRC_SRC = $(PWD)/perltidy/rc
TMUXCONF_SRC   = $(PWD)/tmux/conf
SCREENRC_SRC   = $(PWD)/screen/rc
VIMRC_SRC      = $(PWD)/vim/rc
EMACSD_SRC     = $(PWD)/emacs

.PHONY: all
all: zsh git prove perltidy screenrc tmuxconf vimrc emacs

install: zsh git prove perltidy screenrc tmuxconf vimrc emacs
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
	[[ -e ~/.vimrc ]] && mv ~/.vimrc ~/.vimrc.bak; true
	[[ -e ~/.vim/tmp/swap   ]] || mkdir -p ~/.vim/tmp/swap;   true
	[[ -e ~/.vim/tmp/backup ]] || mkdir -p ~/.vim/tmp/backup; true
	[[ -e ~/.vim/tmp/undo   ]] || mkdir -p ~/.vim/tmp/undo;   true
	mv .vimrc ~/.vimrc
	[[ -e ~/.emacs.d ]] && mv ~/.emacs.d ~/.emacs.d.bak; true
	mv .emacs.d ~/.emacs.d

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

vimrc: .vimrc
.vimrc: $(VIMRC_SRC)
	ln -fs $(VIMRC_SRC) .vimrc

emacs: .emacs.d
.emacs.d: $(EMACSD_SRC)
	ln -fs $(EMACSD_SRC) .emacs.d

clean:
	@rm -rf .zshrc .gitconfig .proverc