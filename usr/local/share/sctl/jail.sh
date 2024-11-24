#!/bin/sh

. /usr/local/share/sctl/common.sh

#number of arguments
NA=$(echo $* | wc -w)

case "$NA" in
    2)
        JAIL_NAME=$2
        ;;
    *)
        jail_usage
        exit 1
        ;;
esac

case "$1" in
help|-h|--help)
    jail_usage
    ;;
esac

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
else
    jail_usage
fi