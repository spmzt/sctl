#!/bin/sh

. /usr/local/share/sctl/common.sh

if [ $# -ne 1 ]; then
    kernel_usage
    exit 2
fi

if [ "$1" = "build" ]
then
	build_kernel_get
elif [ "$1" = "install" ]
then
	install_kernel_get
elif [ "$1" = "mkfs" ]
then
    mkfs_kernel_get
elif [ "$1" = "mkimg" ]
then
    mkimg_kernel_get
elif [ "$1" = "dev" ]
then
    dev_kernel_get
elif [ "$1" = "vmconf" ]
then
    vmconf_kernel_get
elif [ "$1" = "netgraph" ]
then
    netgraph_kernel_get
else
	kernel_usage
fi
