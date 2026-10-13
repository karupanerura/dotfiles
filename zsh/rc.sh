if [[ -e $0 ]]; then
    SELF_PATH=$0
else
    SELF_PATH=$(stat -f '%Y' $0);
fi
ZSHRC_BASEDIR=$(dirname $SELF_PATH);
DOTFILES_BASEDIR=$(dirname $ZSHRC_BASEDIR);
DOTFILES_EXTLIB=$DOTFILES_BASEDIR/extlib;

# コーディングエージェントがコマンドを実行しているシェルか。各ツールが
# エージェントの実行するコマンドにだけ設定する環境変数で判定する
#   CLAUDECODE                                Claude Code, Claude Desktop (Code, Cowork)
#   CODEX_THREAD_ID, CODEX_CI, CODEX_SANDBOX  Codex CLI, ChatGPT (Codex) アプリ
#   CURSOR_AGENT                              Cursor
#   ANTIGRAVITY_AGENT                         Antigravity
if [[ -n "${CLAUDECODE:-}${CODEX_THREAD_ID:-}${CODEX_CI:-}${CODEX_SANDBOX:-}${CURSOR_AGENT:-}${ANTIGRAVITY_AGENT:-}" ]]; then
    DOTFILES_AGENT=1
else
    DOTFILES_AGENT=
fi

# 人が対話的に使っているシェルか。エージェントのシェルでは、確認付き alias や
# cd 時の自動表示、プロンプトといった対話向けの機能を無効にする。
# Cursor や Antigravity のエージェント用ターミナルは対話シェルとして .zshrc を
# 読むため、-o interactive だけでは区別できない
if [[ -o interactive && -z $DOTFILES_AGENT ]]; then
    DOTFILES_INTERACTIVE=1
else
    DOTFILES_INTERACTIVE=
fi

source $ZSHRC_BASEDIR/src/common.sh
source $ZSHRC_BASEDIR/src/completion.sh
source $ZSHRC_BASEDIR/src/function.sh
if [[ -n $DOTFILES_INTERACTIVE ]]; then
    source $ZSHRC_BASEDIR/src/prompt.sh
fi

if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi

source $ZSHRC_BASEDIR/src/alias.sh
source $ZSHRC_BASEDIR/src/finalize.sh
