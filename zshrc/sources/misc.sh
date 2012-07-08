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
