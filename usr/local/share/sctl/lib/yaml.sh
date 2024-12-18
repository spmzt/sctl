#!/bin/sh

parse_yaml()
{
	python3 -m shyaml $@ < $SCTL_CONF
}

get_jail_basejail_name()
{
	parse_yaml get-value jail.basejail.name
}

get_jail_basejail_snapshot()
{
	parse_yaml get-value jail.basejail.snapshot
}

get_jail_zfs_dataset()
{
	parse_yaml get-value jail.zfs_dataset
}

get_jail_ipv6_prefix()
{
	parse_yaml get-value jail.ipv6.prefix
}

get_jail_domain()
{
	parse_yaml get-value jail.domain
}

get_jail_interface()
{
	parse_yaml get-value jail.interface
}

get_ssh_port()
{
	parse_yaml get-value ssh.port
}