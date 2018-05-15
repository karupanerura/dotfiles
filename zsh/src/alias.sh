# minicpan
if type minicpan > /dev/null 2>&1; then
    alias minicpan-update="minicpan -l ~/.minicpan -r http://cpan.metacpan.org/"
fi

# os別alias
case $( $DOTFILES_EXTLIB/bin/ostype ) in
    FreeBSD*|Darwin*)
        alias eject="drutil tray eject"
        ;;
    *)
        ;;
esac

# osバージョン別alias
case $( $DOTFILES_EXTLIB/bin/ostype ) in
    Darwin-1[56]*)
        alias lockscreen="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"
        ;;
    Darwin*)
        alias lockscreen="open /System/Library/CoreServices/ScreenSaverEngine.app"
        ;;
    *)
        ;;
esac

## その他alias
alias tmux="tmux -2 -L karupas_dev"
alias scp="scp -C"
alias gi="git"
alias sudo="sudo -i"
alias random-string='perl -MSession::Token -E '"'"'say+Session::Token->new(length=>$ARGV[0]||10)->get'"'"''
alias sync='sudo sync && sudo sync && sudo sync'
alias shutdown='sudo sync && sudo shutdown'
alias reboot='sudo sync && sudo reboot'
alias halt='sudo sync && sudo halt'
alias rot13='tr a-mn-zA-MN-Z0-45-9 n-za-mN-ZA-M5-90-4'
alias strings='strings -a' # CVE-2014-8485
alias uri-escape="perl -MURI::Escape=uri_escape -pe '\$_ = uri_escape \$_'"
alias uri-unescape="perl -MURI::Escape=uri_unescape -pe '\$_ = uri_unescape \$_'"
alias whitespace-fix="perl -i -pe 's/\s+$/\n/'"
alias perldoc-peco='perldoc `perl-module-list | peco`'
alias cpandoc-peco='cpandoc `cpan-module-list | peco`'
alias cpanm-peco='cpanm `cpan-module-list | peco`'
alias edit-peco='emacs `if [ -d .git ]; then; git ls-files | peco; else; find . -type f | peco; fi`'
alias project-peco='cd ~/project/`\ls ~/project | peco` && edit-peco'
alias gocd='cd $GOPATH/src/`find $GOPATH/src -name .git -type d -maxdepth 4 -exec dirname {} \; | perl -pe "s{^$GOPATH/src/}{}" | peco`'
alias sumup='perl -nE '"'"'$c+=$_}{say$c'"'"''
alias local2jst='perl -MTime::Piece -MPOSIX=tzset -E '"'"'$dt=localtime->strptime(join(" ", @ARGV), "%Y-%m-%d %H:%M:%S");$ENV{TZ}="Asia/Tokyo";tzset();say+localtime($dt->epoch)->strftime("%F %T")'"'"''
alias gmt2jst='perl -MTime::Piece -MPOSIX=tzset -E '"'"'$dt=Time::Piece->strptime(join(" ", @ARGV), "%Y-%m-%d %H:%M:%S");$ENV{TZ}="Asia/Tokyo";tzset();say+localtime($dt->epoch)->strftime("%F %T")'"'"''
alias jst2local='perl -MTime::Piece -MPOSIX=tzset -E '"'"'$ENV{TZ}="Asia/Tokyo";tzset();$dt=localtime->strptime(join(" ", @ARGV), "%Y-%m-%d %H:%M:%S");delete $ENV{TZ};tzset();say+localtime($dt->epoch)->strftime("%F %T")'"'"''
alias jst2gmt='perl -MTime::Piece -MPOSIX=tzset -E '"'"'$ENV{TZ}="Asia/Tokyo";tzset();$dt=localtime->strptime(join(" ", @ARGV), "%Y-%m-%d %H:%M:%S");delete $ENV{TZ};tzset();say+gmtime($dt->epoch)->strftime("%F %T")'"'"''
alias incr-t-index='perl -E '"'"'/^(.*\/)(0*)([0-9]+)(_.*)$/ && rename($_, $3 < 9 ? $1.$2.($3+1).$4 : $1.substr($2, 0, length($2) - 1).($3+1).$4) for @ARGV'"'"''
alias tz-env-peco='env TZ=`find /usr/share/zoneinfo -type f -mindepth 2 | cut -d/ -f 5- | peco`'
alias gcd='ghq look `ghq list | peco`'

# anonymity for pbcopy
alias anonimity-filter="perl -pe 's{\\Q$HOME}{\\\$HOME}g;s{\\Q$USER}{\\\$USER}g'"
alias pbcopy-raw="`which pbcopy`"
alias pbcopy="anonimity-filter | pbcopy"
