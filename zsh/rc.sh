if [ -e $0 ]; then
    SELF_PATH=$0
else
    SELF_PATH=$(stat -f '%Y' $0);
fi
DOTFILES_BASEDIR=$(dirname $SELF_PATH);
DOTFILES_EXTLIB=$(dirname $DOTFILES_BASEDIR)/extlib

source $DOTFILES_BASEDIR/src/common.sh
source $DOTFILES_BASEDIR/src/completion.sh
source $DOTFILES_BASEDIR/src/prompt.sh
source $DOTFILES_BASEDIR/src/alias.sh
source $DOTFILES_BASEDIR/src/misc.sh

if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi