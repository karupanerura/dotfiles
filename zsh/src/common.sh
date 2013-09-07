# 文字コードの設定
export LANG=ja_JP.UTF-8
export JLESSCHARSET=japanese
export LC_CTYPE="ja_JP.UTF-8"
export LC_NUMERIC="ja_JP.UTF-8"
export LC_TIME="ja_JP.UTF-8"
export LC_COLLATE="ja_JP.UTF-8"
export LC_MONETARY="ja_JP.UTF-8"
export LC_MESSAGES="ja_JP.UTF-8"
export LC_PAPER="ja_JP.UTF-8"
export LC_NAME="ja_JP.UTF-8"
export LC_ADDRESS="ja_JP.UTF-8"
export LC_TELEPHONE="ja_JP.UTF-8"
export LC_MEASUREMENT="ja_JP.UTF-8"
export LC_IDENTIFICATION="ja_JP.UTF-8"

# ヒストリの設定
export HISTFILE=~/.histfile
export HISTSIZE=10000
export SAVEHIST=10000

# bin&extlib/binをPATHに追加
export PATH="$HOME/bin:$DOTFILES_EXTLIB/bin:$PATH"

# 履歴ファイルに時刻を記録
setopt extended_history

## jobsでプロセスIDも出力する。
setopt long_list_jobs

## 全てのユーザのログイン・ログアウトを監視する。
watch="all"

## ^Dでログアウトしないようにする。
setopt ignore_eof

## ログイン時にはすぐに表示する。
log

## ^Dでログアウトしないようにする。
setopt ignore_eof

## 「/」も単語区切りとみなす。
WORDCHARS=${WORDCHARS:s,/,,}

## 辞書順ではなく数字順に並べる。
setopt numeric_glob_sort

# コマンド訂正
setopt correct

# 複数の zsh を同時に使う時など history ファイルに上書きせず追加
setopt append_history

## ヒストリを保存するファイル
export HISTFILE=~/.zsh_history

## メモリ上のヒストリ数。
## 大きな数を指定してすべてのヒストリを保存するようにしている。
export HISTSIZE=10000000

## 保存するヒストリ数
export SAVEHIST=$HISTSIZE

## zshプロセス間でヒストリを共有する。
setopt share_history

## C-sでのヒストリ検索が潰されてしまうため、出力停止・開始用にC-s/C-qを使わない。
setopt no_flow_control

# 直前と同じコマンドラインはヒストリに追加しない
setopt hist_ignore_dups

# ヒストリにhistoryコマンドを記録しない
setopt hist_no_store

## スペースで始まるコマンドラインはヒストリに追加しない。
setopt hist_ignore_space

## すぐにヒストリファイルに追記する。
setopt inc_append_history

## Emacsキーバインドを使う。
bindkey -e

## ディレクトリが変わったらディレクトリスタックを表示。
chpwd_functions=($chpwd_functions dirs)

## cdで移動してもpushdと同じようにディレクトリスタックに追加する。
setopt auto_pushd

if type lv > /dev/null 2>&1; then
    ## lvを優先する。
    export PAGER="lv"
else
    ## lvがなかったらlessを使う。
    export PAGER="less"
fi
if [ "$PAGER" = "lv" ]; then
    ## -c: ANSIエスケープシーケンスの色付けなどを有効にする。
    ## -l: 1行が長くと折り返されていても1行として扱う。
    ##     （コピーしたときに余計な改行を入れない。）
    export LV="-c -l"
else
    ## lvがなくてもlvでページャーを起動する。
    alias lv="$PAGER"
fi

## GNU grepがあったら優先して使う。
if type ggrep > /dev/null 2>&1; then
    alias grep=ggrep
fi

## emacsを使う。(emacsclient)
export EDITOR="emacsclient -nw"
export VISUAL="emacsclient -nw"
## emacsがなくてもemacsでvimを起動する。
if ! type emacs > /dev/null 2>&1; then
    alias emacs="vim"
fi
