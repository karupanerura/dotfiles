## 操作を確認する。
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias crontab="crontab -i"

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
alias autocommitd='perl -MFilesys::Notify::Simple -E "my \$w = Filesys::Notify::Simple->new([@ARGV || "."]); \$w->wait(sub { qx/git add \$_->{path}; git commit -m \"edited \$_->{path}\"/ for grep { \$_->{path} !~ m{\.(?:git|svn)/} } @_ }) while 1;"'
alias rot13='tr a-mn-zA-MN-Z0-45-9 n-za-mA-MN-Z5-90-4'
alias uri_escape="perl -MURI::Escape=uri_escape -E 'say uri_escape \$_ for @ARGV'"
alias uri_unescape="perl -MURI::Escape=uri_unescape -E 'say uri_unescape \$_ for @ARGV'"
alias whitespace_fix="perl -i -pe 's/\s+$/\n/'"
