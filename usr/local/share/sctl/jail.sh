#!/bin/sh

. /usr/local/share/sctl/common.sh

case "$1" in
help|-h|--help)
    jail_usage
    ;;
esac

if [ "$1" = "create" ]
then
    jail_create $2
elif [ "$1" = "template" ]
then
	jail_template $2
elif [ "$1" = "clone" ]
then
	jail_clone $2
elif [ "$1" = "config" ]
then
	jail_config $2
elif [ "$1" = "service" ]
then
	jail_service $2
else
    jail_usage
fi