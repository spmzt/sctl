#!/bin/sh

host_usage() {
    cat << EOF
Usage:
  sctl host [OPTIONS] COMMAND

Available Commands:
    ssh      configure your /etc/ssh/sshd_config.
    -h          help.

Use "sctl -v|--version" for version information.
EOF
    exit 1
}

ssh_host_get() {
	harden_ssh_set	
}
