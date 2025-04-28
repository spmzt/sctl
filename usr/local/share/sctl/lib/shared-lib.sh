#!/bin/sh

harden_ssh_set() {
    sed -i'' "s/^\#Port 22$/Port $(get_ssh_port)/g" $1/etc/ssh/sshd_config
    sed -i'' 's/^\#Banner none$/Banner none/g' $1/etc/ssh/sshd_config
    sed -i'' 's/^\#VersionAddendum .*/VersionAddendum \"\"/g' $1/etc/ssh/sshd_config
    sed -i'' 's/^\#PubkeyAuthentication .*/PubkeyAuthentication yes/g' $1/etc/ssh/sshd_config
    sed -i'' 's/^\#PasswordAuthentication .*/PasswordAuthentication no/g' $1/etc/ssh/sshd_config
    sed -i'' 's/^\#PermitRootLogin .*/PermitRootLogin no/g' $1/etc/ssh/sshd_config
}
