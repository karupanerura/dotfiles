# プロンプトの設定
#PROMPT='[%n@%M %~]$ '
paren="[]"
PROMPT="%{%}$paren[1]%n@%m %~$paren[2]%(!.#.$)%{%} "

_update_rprompt () {
    RPROMPT="$( git_prompt )";
}

_set_env_git_current_branch() {
  GIT_CURRENT_BRANCH=$( git branch &> /dev/null | grep '^\*' | cut -b 3- )
}

autoload -U colors; colors;

# ここの部分を作る
# [branch:master](modified)(untracked)
GIT_PROMPT_COLOR_DIRTY="%{$fg[red]%}"
GIT_PROMPT_COLOR_CLEAN="%{$fg[green]%}"
function git_prompt {
    # ブランチ名が取れなければ何もしないよ
    GIT_CURRENT_BRANCH=$( git branch &> /dev/null | grep '^\*' | cut -b 3- )
    if [ ${GIT_CURRENT_BRANCH} ]; then
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
    GIT_STATUS=''
    for ST in $(git status --porcelain 2> /dev/null | cut -b -2 | sed -e 's/\s/S/' | sort | uniq); do
        case $ST in
            ??)
                GIT_STATUS="$GIT_PROMPT_UNTRACKED$GIT_STATUS"
                ;;
            AS|MS)
                GIT_STATUS="$GIT_PROMPT_ADDED$GIT_STATUS"
                ;;
            AM|SM|ST)
                GIT_STATUS="$GIT_PROMPT_MODIFIED$GIT_STATUS"
                ;;
            SR)
                GIT_STATUS="$GIT_PROMPT_RENAMED$GIT_STATUS"
                ;;
            AD|SD)
                GIT_STATUS="$GIT_PROMPT_DELETED$GIT_STATUS"
                ;;
            UU)
                GIT_STATUS="$GIT_PROMPT_UNMERGED$GIT_STATUS"
                ;;
            *)
                GIT_STATUS="$GIT_PROMPT_UNKNOWN$GIT_STATUS"
                ;;
        esac
    done
    echo $GIT_STATUS
}

precmd()
{
  _set_env_git_current_branch
  _update_rprompt
}

chpwd()
{
  _set_env_git_current_branch
  _update_rprompt
  ls
}

