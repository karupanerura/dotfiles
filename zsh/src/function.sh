function perlv {
    perl -M$1 -E "say \$$1::VERSION"
}

function runcpp {
    local bin=`tempfile`
    g++ -O2 $1 -o $bin; shift
    $bin $*
    rm -f $bin
}

function rungcc {
    local bin=`tempfile`
    gcc -O2 $1 -o $bin; shift
    $bin $*
    rm -f $bin
}

function plenv-perl-version {
    local dir=$PWD

    [[ -n $PLENV_VERSION ]] && { echo $PLENV_VERSION; return }

    while [[ -n $dir && $dir != "/" && $dir != "." ]]; do
        if [[ -f "$dir/.perl-version" ]]; then
            head -n 1 "$dir/.perl-version"
            return
        fi
        dir=$dir:h
    done

    local plenv_home=$PLENV_HOME
    [[ -z $PLENV_HOME && -n $HOME ]] && plenv_home="$HOME/.plenv"

    if [[ -f "$plenv_home/version" ]]; then
        head -n 1 "$plenv_home/version"
    fi
}

function emacs-server-start {
    if ps x | grep emacs | grep '\--daemon' > /dev/null 2>&1; then
        echo "[INFO] lived 'emacs --daemon'"
    else
        echo "[INFO] start 'emacs --daemon'"
        env emacs --daemon
    fi
}

function emacs-server-stop {
    if ps x | grep emacs | grep '\--daemon' > /dev/null 2>&1; then
        echo "[INFO] stop  'emacs --daemon'"
        emacsclient -e '(server-force-delete)'
        ps x | grep emacs | grep '\--daemon' | awk '{print $1}' | xargs kill
    else
        echo "[INFO] not lived 'emacs --daemon'";
    fi
}

function emacs-server-restart {
    emacs-server-stop;
    emacs-server-start;
}
