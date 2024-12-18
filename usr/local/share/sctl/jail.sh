#!/bin/sh

. /usr/local/share/sctl/common.sh

args=`getopt hn: $*`
if	[ $? -ne 0 ]; then
    jail_usage
    exit 2
fi
set -- $args
while :; do
    case "$1" in
    -n)
        JAIL_NAME="$2"
        shift; shift
        ;;
    -h)
        jail_usage
        exit 1
        ;;
    --)
        shift; break
        ;;
    esac
done

if [ -z "$JAIL_NAME" ] && [ "$1" != "setup" ]; then
    jail_usage
    exit 2
fi

if	[ $# -ne 1 ]; then
    jail_usage
    exit 2
fi

if [ "$1" = "create" ]
then
    jail_create $JAIL_NAME
elif [ "$1" = "template" ]
then
    jail_template $JAIL_NAME
elif [ "$1" = "clone" ]
then
    jail_clone $JAIL_NAME
elif [ "$1" = "config" ]
then
    jail_config $JAIL_NAME
elif [ "$1" = "service" ]
then
    jail_service $JAIL_NAME
elif [ "$1" = "install" ]
then
    jail_install $JAIL_NAME
elif [ "$1" = "setup" ]
then
    jail_setup
else
    jail_usage
fi