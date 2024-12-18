#!/bin/sh

jail_usage() {
    cat << EOF
Usage:
  sctl jail [OPTIONS] COMMAND

Available Commands:
    create      clone base jail to jail path with zfs and create jail.conf.
    clone       clone base jail to jail path with zfs.
    config      create jail.conf with template.
    template    jail template for creating jail.conf configurations under jail.conf.d.
    service     enable jail and add it to jail_list to make it persistent.
    setup       configure /etc/jail.conf and enable jail.

Available Options:
    -n [name]   REQUIRED.
    -h          help.

Use "sctl -v|--version" for version information.
EOF
    exit 1
}

get_jail_zfs_mountpoint() {
    DS=$(get_jail_zfs_dataset)
    zfs get -Ho value mountpoint $DS
}

get_jail_ipv6_rand() {
    echo $(get_jail_ipv6_prefix)$(ipv6_rand)
}

jail_clone() {
    # $1 is the jail name
    BASEJAIL=$(get_jail_basejail_name)
    DS=$(get_jail_zfs_dataset)
    SNAPSHOT=$(get_jail_basejail_snapshot)
    zfs send -v $DS/$BASEJAIL@$SNAPSHOT | zfs recv -v $DS/$1
}

jail_conf() {
    JAIL_PATH=$(get_jail_zfs_mountpoint)
    DOMAIN=$(get_jail_domain)
    echo "path = \"${JAIL_PATH}/\${name}\";
host.hostname = \"\${name}.${DOMAIN}\";
host.domainname = \"${DOMAIN}\";
exec.start = \"/bin/sh /etc/rc\";
exec.stop  = \"/bin/sh /etc/rc.shutdown\";
exec.consolelog = \"/var/log/\${name}_console.log\";
exec.clean;
mount.devfs;"
}

jail_config_init() {
    jail_conf > /etc/jail.conf
}

jail_setup()
{
    jail_config_init
    service jail enable
}

jail_template() {
    IP6=$(get_jail_ipv6_rand)
    IF=$(get_jail_interface)
    echo ".include \"/etc/jail.conf\";
$1 {
  devfs_ruleset=4;

  ip6.addr = \"${IP6}\";
  interface = \"${IF}\";
}"
}

jail_config() {
    # $1 is the jail name
    jail_template $1 > /etc/jail.conf.d/$1.conf
}

jail_service() {
    # $1 is the jail name
    sysrc jail_list+=$1
    service jail start $1
}

jail_create() {
    jail_clone $1
    jail_config $1
    jail_service $1
}

harden_ssh_set() {
    sed -i'' "s/^\#Port 22$/Port $(get_ssh_port)/g" $1/etc/ssh/sshd_config
    sed -i'' 's/^\#Banner none$/Banner none/g' $1/etc/ssh/sshd_config
    sed -i'' 's/^\#VersionAddendum .*/VersionAddendum \"\"/g' $1/etc/ssh/sshd_config
    sed -i'' 's/^\#PubkeyAuthentication .*/PubkeyAuthentication yes/g' $1/etc/ssh/sshd_config
    sed -i'' 's/^\#PasswordAuthentication .*/PasswordAuthentication no/g' $1/etc/ssh/sshd_config
    sed -i'' 's/^\#PermitRootLogin .*/PermitRootLogin no/g' $1/etc/ssh/sshd_config
}

jail_install() {
    BASEPATH="/usr/jails/$1"
    pkg -c $BASEPATH install -y doas vim
    echo 'permit nopass :wheel' > $BASEPATH/usr/local/etc/doas.conf
    harden_ssh_set $BASEPATH
}
