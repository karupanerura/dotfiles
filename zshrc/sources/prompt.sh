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
function git_prompt {
    # ブランチ名が取れなければ何もしないよ
    GIT_CURRENT_BRANCH=$( git branch &> /dev/null | grep '^\*' | cut -b 3- )
    if [ ${GIT_CURRENT_BRANCH} ]
    then
        GIT_BRANCH="$( git_prompt_color )$PROMPT_PAREN[1]branch:${GIT_CURRENT_BRANCH}$PROMPT_PAREN[2]%{${reset_color}%}"
        echo "[${GIT_BRANCH}]$( git_status )"
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
function git_status {
    GIT_INDEX=$(git status --porcelain 2> /dev/null)
    GIT_STATUS=''
    if $(echo "$GIT_INDEX" | grep '^?? ' &> /dev/null); then
        GIT_STATUS="$GIT_PROMPT_UNTRACKED$GIT_STATUS"
    fi
    if $(echo "$GIT_INDEX" | grep '^A ' &> /dev/null); then
        GIT_STATUS="$GIT_PROMPT_ADDED$GIT_STATUS"
    elif $(echo "$GIT_INDEX" | grep '^M ' &> /dev/null); then
        GIT_STATUS="$GIT_PROMPT_ADDED$GIT_STATUS"
    fi
    if $(echo "$GIT_INDEX" | grep '^ M ' &> /dev/null); then
        GIT_STATUS="$GIT_PROMPT_MODIFIED$GIT_STATUS"
    elif $(echo "$GIT_INDEX" | grep '^AM ' &> /dev/null); then
        GIT_STATUS="$GIT_PROMPT_MODIFIED$GIT_STATUS"
    elif $(echo "$GIT_INDEX" | grep '^ T ' &> /dev/null); then
        GIT_STATUS="$GIT_PROMPT_MODIFIED$GIT_STATUS"
    fi
    if $(echo "$GIT_INDEX" | grep '^R ' &> /dev/null); then
        GIT_STATUS="$GIT_PROMPT_RENAMED$GIT_STATUS"
    fi
    if $(echo "$GIT_INDEX" | grep '^ D ' &> /dev/null); then
        GIT_STATUS="$GIT_PROMPT_DELETED$GIT_STATUS"
    elif $(echo "$GIT_INDEX" | grep '^AD ' &> /dev/null); then
        GIT_STATUS="$GIT_PROMPT_DELETED$GIT_STATUS"
    fi
    if $(echo "$GIT_INDEX" | grep '^UU ' &> /dev/null); then
        GIT_STATUS="$GIT_PROMPT_UNMERGED$GIT_STATUS"
    fi
    echo "%{$fg[yellow]%}${GIT_STATUS}%{${reset_color}%}"
}

# レポジトリが綺麗ならグリーン、汚ければレッドに色づけするよ
GIT_PROMPT_COLOR_DIRTY="%{$fg[red]%}"
GIT_PROMPT_COLOR_CLEAN="%{$fg[green]%}"
function git_prompt_color {
    if [[ -n $(git status -s --ignore-submodules=dirty 2> /dev/null) ]]; then
        echo "${GIT_PROMPT_COLOR_DIRTY}"
    else
        echo "${GIT_PROMPT_COLOR_CLEAN}"
    fi
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

