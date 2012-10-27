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
alias emacs="emacsclient -nw"
alias dist_init='make clean && rm -rf META.yml MYMETA.yml MYMETA.json inc Makefile.old && perl Makefile.PL'
alias scp="scp -C"
alias random_string='perl -MString::Random=random_string -E "say+random_string(q{s} x (\$ARGV[0] || 10))"'
alias webalize='perl -MTest::TCP -E "exec(qq{plackup -o=localhost -p=@{[ empty_port() ]} -MPlack::App::Directory -e \"Plack::App::Directory->new(root => q{.})->to_app\"})"'
alias sync='sync && sync && sync'
alias shutdown='sync && shutdown'
alias reboot='sync && reboot'
alias halt='sync && halt'
alias autocommitd='perl -MFilesys::Notify::Simple -E "my \$w = Filesys::Notify::Simple->new([@ARGV]); \$w->wait(sub { qx/git add \$_->{path}\\n; git commit -m \"edited \$_->{path}\"/ for @_ }) while 1;"'
