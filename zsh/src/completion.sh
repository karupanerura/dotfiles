# 補完機能ON
fpath=(/usr/local/share/zsh-completions $fpath)
autoload -Uz compinit; compinit

# 補完するかの質問は画面を超える時にのみに行う｡
LISTMAX=0

## 補完方法毎にグループ化する。
### 補完方法の表示方法
###   %B...%b: 「...」を太字にする。
###   %d: 補完方法のラベル
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*' group-name ''

## 補完候補に色を付ける。
### "": 空文字列はデフォルト値を使うという意味。
zstyle ':completion:*:default' list-colors ""

## --prefix=~/localというように「=」の後でも
## 「~」や「=コマンド」などのファイル名展開を行う。
setopt magic_equal_subst

## globでパスを生成したときに、パスがディレクトリだったら最後に「/」をつける。
setopt mark_dirs

## カーソル位置で補完する。
setopt complete_in_word

## 補完時にヒストリを自動的に展開する。
setopt hist_expand

## 補完候補がないときなどにビープ音を鳴らさない。
setopt no_beep

# sudo でも補完の対象
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# 大文字小文字を区別せずに補完する
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# 補完候補が複数ある時に、一覧表示
setopt auto_list

# 補完結果をできるだけ詰める
setopt list_packed

# 補完キー（Tab, Ctrl+I) を連打するだけで順に補完候補を自動で補完
setopt auto_menu

# カッコの対応などを自動的に補完
setopt auto_param_keys

# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash
