function perlv {
    perl -M$1 -E "say \$$1::VERSION"
}

function emacs_server_start {
    ## create emacs env file
    env | awk -F'=' '$1 ~ /^(PATH|PERL5LIB)$/ { print "(setenv \"" $1 "\" \"" $2 "\")" }' > ~/.emacs.d/shellenv.el

    if ps x | grep emacs | grep '\--daemon' > /dev/null 2>&1; then
        echo "[INFO] lived 'emacs --daemon'"
        emacsclient -e '(load-shellenv)'
    else
        echo "[INFO] start 'emacs --daemon'"
        env emacs --daemon
    fi
}

function emacs_server_stop {
    if ps x | grep emacs | grep '\--daemon' > /dev/null 2>&1; then
        echo "[INFO] stop  'emacs --daemon'"
        emacsclient -e '(server-force-delete)'
        ps x | grep emacs | grep '\--daemon' | awk '{print $1}' | xargs kill
    else
        echo "[INFO] not lived 'emacs --daemon'";
    fi
}

function emacs_server_restart {
    emacs_server_stop;
    emacs_server_start;
}
