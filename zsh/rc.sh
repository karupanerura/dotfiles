if [ -e $0 ]; then
    SELF_PATH=$0
else
    SELF_PATH=$(stat -f '%Y' $0);
fi
ZSHRC_BASEDIR=$(dirname $SELF_PATH);
DOTFILES_BASEDIR=$(dirname $ZSHRC_BASEDIR);
DOTFILES_EXTLIB=$DOTFILES_BASEDIR/extlib;

source $ZSHRC_BASEDIR/src/common.sh
source $ZSHRC_BASEDIR/src/completion.sh
source $ZSHRC_BASEDIR/src/prompt.sh
source $ZSHRC_BASEDIR/src/misc.sh
source $ZSHRC_BASEDIR/src/alias.sh
source $ZSHRC_BASEDIR/src/function.sh

if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi
