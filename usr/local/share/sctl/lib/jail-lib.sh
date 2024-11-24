#!/bin/sh

jail_usage()
{
    cat << EOF
Usage:
  sctl jail COMMAND [name]

Available Commands:
    create		clone base jail to jail path with zfs and create jail.conf.
    clone		clone base jail to jail path with zfs.
    config		create jail.conf with template.
    template    jail template for creating jail.conf configurations under jail.conf.d.
    service		enable jail and add it to jail_list to make it persistent.

Use "sctl -v|--version" for version information.
EOF
    exit 1
}

get_jail_zfs_mountpoint()
{
    DS=$(get_jail_zfs_dataset)
    zfs get -Ho value mountpoint $DS
}

get_jail_ipv6_rand()
{
    echo $(get_jail_ipv6_prefix)$(ipv6_rand)
}

jail_clone()
{
    # $1 is the jail name
    BASEJAIL=$(get_jail_basejail_name)
    DS=$(get_jail_zfs_dataset)
    SNAPSHOT=$(get_jail_basejail_snapshot)
    zfs clone $DS/$BASEJAIL@$SNAPSHOT $DS/$1
}

jail_template()
{
    JAIL_PATH=$(get_jail_zfs_mountpoint)
    DOMAIN=$(get_jail_domain)
    IP6=$(get_jail_ipv6_rand)
    IF=$(get_jail_interface)
    echo "
$1 {
  path = \"${JAIL_PATH}/\${name}\";
  exec.clean;
  host.hostname = \"\${name}.${DOMAIN}\";
  host.domainname = \"${DOMAIN}\";

  mount.devfs;
  devfs_ruleset=4;

  ip6.addr = \"${IP6}\";
  interface = \"${IF}\";
}
"
}

jail_config()
{
    # $1 is the jail name
    jail_template $1 > /etc/jail.conf.d/$1.conf
}

jail_service()
{
    # $1 is the jail name
    sysrc jail_list+=$1
    service jail start $1
}

jail_create()
{
    jail_clone $1
    jail_config $1
    jail_service $1
}