# プロンプトの設定
autoload -U colors; colors;

#PROMPT='[%n@%M %~]$ '
PROMPT_BASE="%{$fg[blue]%}|%D{%Y-%m-%d %H:%M:%S}|%{${reset_color}%} %{$fg[green]%}[%~]%{${reset_color}%} %{$fg[red]%}%(!.#.%%)%{%}%{${reset_color}%} "

PROMPT_BG_DANGER="${bg[red]}"
function _update_prompt {
    if [ `whoami` = 'root' ]; then
        PROMPT="$PROMPT_BG_DANGER$PROMPT_BASE"
    else
        PROMPT=$PROMPT_BASE
    fi
}

function _update_rprompt {
    RPROMPT="%{$fg[blue]%}%{%}%n@%m%{${reset_color}%} [%{$fg[green]%}perl:$( plenv-perl-version )%{${reset_color}%}] $( git_prompt )";
}

function _set_env_git_current_branch {
    GIT_CURRENT_BRANCH=$([[ -d .git ]] && cat .git/HEAD | cut -d/ -f 3-);
}

# ここの部分を作る
# [branch:master](modified)(untracked)
GIT_PROMPT_COLOR_DIRTY="%{$fg[red]%}"
GIT_PROMPT_COLOR_CLEAN="%{$fg[green]%}"
function git_prompt {
    # ブランチ名が取れなければ何もしないよ
    if [ $GIT_CURRENT_BRANCH ]; then
        # ステータスの取得
        GIT_CURRENT_STATUS=$( git_status );

        # レポジトリが綺麗ならグリーン、汚ければレッドに色づけするよ
        GIT_PROMPT_COLOR='';
        if [ $GIT_CURRENT_STATUS ]; then
            GIT_PROMPT_COLOR=$GIT_PROMPT_COLOR_DIRTY;
        else
            GIT_PROMPT_COLOR=$GIT_PROMPT_COLOR_CLEAN;
        fi

        # 色付けと出力
        GIT_BRANCH="${GIT_PROMPT_COLOR}$PROMPT_PAREN[1]branch:${GIT_CURRENT_BRANCH}$PROMPT_PAREN[2]%{${reset_color}%}"
        GIT_CURRENT_STATUS="%{$fg[yellow]%}${GIT_CURRENT_STATUS}%{${reset_color}%}"
        echo "[${GIT_BRANCH}]${GIT_CURRENT_STATUS}"
    fi
}

# レポジトリの状態によって右プロンプトの表示が長くなってくる君。
# "(modified)(untracked)" の部分を作ってくれる。
GIT_PROMPT_ADDED="(added)"
GIT_PROMPT_MODIFIED="(modified)"
GIT_PROMPT_DELETED="(deleted)"
GIT_PROMPT_RENAMED="(renamed)"
GIT_PROMPT_UNMERGED="(unmerged)"
GIT_PROMPT_UNTRACKED="(untracked)"
GIT_PROMPT_UNKNOWN="(unknown)"
function git_status {
    GIT_STATUS_ADDED=0
    GIT_STATUS_MODIFIED=0
    GIT_STATUS_DELETED=0
    GIT_STATUS_RENAMED=0
    GIT_STATUS_UNMERGED=0
    GIT_STATUS_UNTRACKED=0
    GIT_STATUS_UNKNOWN=0
    for ST in $(git status --porcelain 2> /dev/null | cut -b -2 | sed -e 's/\s/S/' | sort | uniq); do
        case $ST in
            '??')
                GIT_STATUS_UNTRACKED=1                
                ;;
            AS|MS)
                GIT_STATUS_ADDED=1
                ;;
            AM|SM|ST|MM)
                GIT_STATUS_MODIFIED=1
                ;;
            SR)
                GIT_STATUS_RENAMED=1
                ;;
            AD|SD)
                GIT_STATUS_DELETED=1        
                ;;
            UU)
                GIT_STATUS_UNMERGED=1
                ;;
            *)
                GIT_STATUS_UNKNOWN=1
                ;;
        esac
    done

    GIT_STATUS=''
    if [ $GIT_STATUS_UNTRACKED = 1 ]; then
        GIT_STATUS="$GIT_PROMPT_UNTRACKED$GIT_STATUS"
    fi
    if [ $GIT_STATUS_ADDED = 1 ]; then
        GIT_STATUS="$GIT_PROMPT_ADDED$GIT_STATUS"
    fi
    if [ $GIT_STATUS_MODIFIED = 1 ]; then
        GIT_STATUS="$GIT_PROMPT_MODIFIED$GIT_STATUS"
    fi
    if [ $GIT_STATUS_RENAMED = 1 ]; then
        GIT_STATUS="$GIT_PROMPT_RENAMED$GIT_STATUS"
    fi
    if [ $GIT_STATUS_DELETED = 1 ]; then
        GIT_STATUS="$GIT_PROMPT_DELETED$GIT_STATUS"
    fi
    if [ $GIT_STATUS_UNMERGED = 1 ]; then
        GIT_STATUS="$GIT_PROMPT_UNMERGED$GIT_STATUS"
    fi
    if [ $GIT_STATUS_UNKNOWN = 1 ]; then
        GIT_STATUS="$GIT_PROMPT_UNKNOWN$GIT_STATUS"
    fi

    echo $GIT_STATUS
}

precmd () {
    _set_env_git_current_branch
    _update_rprompt
}

chpwd () {
    _set_env_git_current_branch
    _update_rprompt
    ls
}

_set_env_git_current_branch
_update_prompt
_update_rprompt
