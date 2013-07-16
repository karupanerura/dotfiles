#!/bin/sh
#set -x
set -e

echo $1;
if [ [!$1] -o ! -d $1 ]; then
    echo "Usage: $0 dir" &>2
fi

find_large_file () {
    BASEDIR=$1
    METADIR=$(perl -e 'print quotemeta($ARGV[0])' $BASEDIR)
    RESULT=$(du -s $BASEDIR/* | sort -nr | awk "\$2 !~ /^$METADIR\$/ { print \$0 }" | head -n 1)
    if [[ $RESULT ]]; then
        echo $RESULT
        DIR=$(echo $RESULT | awk '{print $2}')
        [ -d $DIR ] && find_large_file $DIR
    fi
}

find_large_file $1;
