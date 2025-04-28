#!/bin/sh

. /usr/local/share/sctl/common.sh

if [ $# -ne 1 ]; then
    host_usage
    exit 2
fi

if [ "$1" = "ssh" ]
then
	ssh_host_get
else
	host_usage
fi
