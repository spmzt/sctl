#!/bin/sh

kernel_usage() {
    cat << EOF
Usage:
  sctl kernel [OPTIONS] COMMAND

Available Commands:
    build      build your kernel from /usr/src.
    install    install your kernel to /tmp/kernel.
    mkfs       make filesystem from /tmp/kernel to /tmp/kernfs and kernfs.raw.
    mkmg       make image from /tmp/kernfs.
    dev        build kernel, make fs and img from kernel.
    vmconf     display vm configuration for booting from our specified kernel.
    -h         help.

Use "sctl -v|--version" for version information.
EOF
    exit 1
}

vmconf_kernel_get() {
    echo 'echo autoboot_delay=0 > /boot/loader.conf.load' 
    echo 'echo kernel="disk0p1:/boot/kernel" >> /boot/loader.conf.load' 
    echo 'echo nullfs_load="YES" >> /boot/loader.conf.load' 
    echo 'echo kern.bootfile=/boot/kernel/kernel >> /etc/sysctl.conf' 
    echo 'echo kern.module_path=/boot/kernel >> /etc/sysctl.conf' 
    echo 'echo /dev/gpt/kern /mnt ufs ro 0 0 >> /etc/fstab' 
    echo 'echo /mnt/boot/kernel /boot/kernel nullfs ro 0 0 >> /etc/fstab' 
	echo 'echo net.inet.tcp.tso=0 >> /etc/sysctl.conf'
	echo 'echo net.inet6.ip6.accept_rtadv=1 >> /etc/sysctl.conf'
	echo 'echo net.inet6.ip6.forwarding=1 >> /etc/sysctl.conf'
}

netgraph_kernel_get() {
    echo 'ngctl mkpeer vtnet0: netflow lower iface0
    ngctl name vtnet0:lower netflow                                                      
    ngctl connect vtnet0: netflow: upper out0 
    ngctl mkpeer netflow: ksocket export9 inet6/dgram/udp6
    ngctl name netflow:export9 ngk
    ngctl msg ngk: connect inet6/2a01:e140::1:4444
    ngctl list
    ngctl show ngk:'
}

mkfs_kernel_get() {
    cd /tmp/kernel
    rm -f /tmp/kernfs
    makefs -B little -S 512 -Z -o version=2 /tmp/kernfs METALOG
}

mkimg_kernel_get() {
    rm -f /tmp/kernfs.raw
    mkimg -s gpt -f raw -S 512 -p freebsd-ufs/kern:=/tmp/kernfs -o /tmp/kernfs.raw
}

build_kernel_get() {
    [ "$(id -u)" = 0 ] || exit
    cd /usr/src
    make -j26 buildkernel
}

install_kernel_get() {
    [ "$(id -u)" = 0 ] || exit
    cd /usr/src
    rm -r /tmp/kernel
    make installkernel -DNO_ROOT DESTDIR=/tmp/kernel
}

dev_kernel_get() {
    install_kernel_get
    mkfs_kernel_get
    mkimg_kernel_get
}
