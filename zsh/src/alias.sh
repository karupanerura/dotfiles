## 操作を確認する。
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias crontab="crontab -i"

# ls系alias
if $DOTFILES_EXTLIB/bin/ostype | grep -E "(FreeBSD|Darwin)" > /dev/null 2>&1 ; then
    alias ls="ls -G"
    alias la="ls -Ga"
    alias ll="ls -GlA"
else
    alias ls="ls -hbF --color=auto"
    alias la="ls -hbaF --color=auto"
    alias ll="ls -hblaF --color=auto"
fi;

## その他alias
alias tmux="tmux -2 -L karupas_dev"
alias sync='sync && sync && sync'
alias dist_init='make clean && rm -rf META.yml MYMETA.yml MYMETA.json inc Makefile.old && perl Makefile.PL'
alias scp="scp -C"
alias git_edit='git status --short | cat -n;printf "number>"; read r; emacs `git status --short | cat -n | awk "/^ +$r/{print \\$3}"`'
