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

# minicpan
if type minicpan > /dev/null 2>&1; then
    alias minicpan-update="minicpan -l ~/.minicpan -r http://cpan.metacpan.org/"
fi

## その他alias
alias tmux="tmux -2 -L karupas_dev"
alias scp="scp -C"
alias random-string='perl -MString::Random=random_string -E "say+random_string(q{s} x (\$ARGV[0] || 10))"'
alias webalize='perl -MTest::TCP -E "exec(qq{plackup -p=@{[ empty_port() ]} -MPlack::App::Directory -e \"Plack::App::Directory->new(root => q{.})->to_app\"})"'
alias sync='sync && sync && sync'
alias shutdown='sync && shutdown'
alias reboot='sync && reboot'
alias halt='sync && halt'
alias rot13='tr a-mn-zA-MN-Z0-45-9 n-za-mA-MN-Z5-90-4'
alias uri-escape="perl -MURI::Escape=uri_escape -pe '\$_ = uri_escape \$_'"
alias uri-unescape="perl -MURI::Escape=uri_unescape -pe '\$_ = uri_unescape \$_'"
alias whitespace-fix="perl -i -pe 's/\s+$/\n/'"
alias perldoc-peco='perldoc `perl-module-list | peco`'
alias cpandoc-peco='cpandoc `perl-module-list | peco`'
alias cpanm-peco='cpanm `perl-module-list | peco`'
