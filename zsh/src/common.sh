# 文字コードの設定
export LANG=ja_JP.UTF-8
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
typeset -U path
path=(
    $HOME/bin
    $HOME/local/bin
    $DOTFILES_EXTLIB/bin
    $HOME/Library/Application\ Support/JetBrains/Toolbox/scripts
    $path
)

# OS X
if type brew &>/dev/null; then
    path=(
        $path
        $(brew --prefix)/share/git-core/contrib/diff-highlight
        $(brew --prefix)/share/git-core/contrib/git-jump
        $(brew --prefix)/share/git-core/contrib/stats
        $(brew --prefix)/share/git-core/contrib/subtree
    )
fi

# 履歴ファイルに時刻を記録
setopt extended_history

## jobsでプロセスIDも出力する。
setopt long_list_jobs

## 全てのユーザのログイン・ログアウトを監視する。
watch="all"

## ^Dでログアウトしないようにする。
setopt ignore_eof

## ログイン時にはすぐに表示する。
if eval 'builtin log' > /dev/null 2>&1; then
    builtin log
fi

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

## コマンド履歴の絞り込み
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^P'   history-beginning-search-backward-end
bindkey '\e[A' history-beginning-search-backward-end
bindkey '^N'   history-beginning-search-forward-end
bindkey '\e[B' history-beginning-search-forward-end

## 操作を確認する
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# ls系alias
case $( $DOTFILES_EXTLIB/bin/ostype ) in
    FreeBSD*|Darwin*)
        alias ls="ls -G"
        alias la="ls -Ga"
        alias ll="ls -GlA"
        ;;
    *)
        alias ls="ls -hbF --color=auto"
        alias la="ls -hbaF --color=auto"
        alias ll="ls -hblaF --color=auto"
        ;;
esac

## GNU grepがあったら優先して使う。
if type ggrep > /dev/null 2>&1; then
    alias grep=ggrep
fi

## emacsを使う。(emacs)
export EDITOR="emacs"
export VISUAL="emacs"
## emacsがなくてもemacsでvimを起動する。
if ! type emacs > /dev/null 2>&1; then
    alias emacs="vim"
fi

if type colordiff > /dev/null 2>&1; then
    ## colordiffを優先する。
    alias diff="colordiff"
fi

# less
if type less > /dev/null 2>&1; then
    export LESSCHARSET=utf-8
fi

# cpanm
if type cpanm > /dev/null 2>&1; then
    export PERL_CPANM_OPT="--prompt --cascade-search --mirror http://ftp.ring.gr.jp/pub/lang/perl/CPAN/ --mirror http://cpan.metacpan.org/"
fi

# minicpan
if type minicpan > /dev/null 2>&1; then
    export PERL_CPANM_OPT="--mirror file://$HOME/.minicpan $PERL_CPANM_OPT"
fi

# golang
if type go > /dev/null 2>&1; then
    export GOROOT=`go env GOROOT`
    export GOPATH=$HOME/.go
    path=(
        $path
        $GOROOT/bin
        $GOPATH/bin
    )
fi
