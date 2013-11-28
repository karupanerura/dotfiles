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

function runjava {
    JAVA_SRC=$1; shift;
    javac $JAVA_SRC
    java `echo $JAVA_SRC | sed -e 's/\.java$//'` $*
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

## tmuxで新しいペインで実行したいとき用
nw(){
    local CMDNAME split_opts spawn_command
    CMDNAME=`basename $0`

    while getopts dhvPp:l:t:b: OPT
    do
        case $OPT in
        "d" | "h" | "v" | "P" )
            split_opts="$split_opts -$OPT";;
        "p" | "l" | "t" )
            split_opts="$split_opts -$OPT $OPTARG";;
        * ) echo "Usage: $CMDNAME [-dhvP]" \
                 "[-p percentage|-l size] [-t target-pane] [command]" 1>&2
            return 1;;
        esac
    done
    shift `expr $OPTIND - 1`

    spawn_command=$@
    [[ -z $spawn_command ]] && spawn_command=$SHELL

    tmux split-window `echo -n $split_opts` "cd $PWD ; $spawn_command"
}

_nw(){
    local args
    args=(
        '-d[do not make the new window become the active one]'
        '-h[split horizontally]'
        '-v[split vertically]'
        '-l[define new pane'\''s size]: :_guard "[0-9]#" "numeric value"'
        '-p[define new pane'\''s size in percent]: :_guard "[0-9]#" "numeric value"'
        '-t[choose target pane]: :_guard "[0-9]#" "numeric value"'
        '*:: :_normal'
    )
    _arguments ${args} && return
}

compdef _nw nw
