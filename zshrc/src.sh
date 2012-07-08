SELF_PATH=$(stat -f '%Y' $0 || echo $0);
DOTFILES_BASEDIR=$(dirname $SELF_PATH);
DOTFILES_EXTLIB=$(dirname $DOTFILES_BASEDIR)/extlib

source $DOTFILES_BASEDIR/sources/common.sh
source $DOTFILES_BASEDIR/sources/completion.sh
source $DOTFILES_BASEDIR/sources/prompt.sh
source $DOTFILES_BASEDIR/sources/alias.sh
source $DOTFILES_BASEDIR/sources/misc.sh

if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi