#!/bin/sh

find_config_file()
{
	export SCTL_CONF;
	if [ -f $HOME/.config/sctl/sctl.yaml ]
	then
		SCTL_CONF="$(realpath $HOME/.config/sctl/sctl.yaml)"
	elif [ -f /usr/local/etc/sctl/sctl.yaml ]
	then
		SCTL_CONF="$(realpath /usr/local/etc/sctl/sctl.yaml)"
	elif [ -f /etc/sctl/sctl.yaml ]
	then
		SCTL_CONF="$(realpath /etc/sctl/sctl.yaml)"
	else
		echo "sctl [config] -> Error: Can't find configuration file."
		exit 1
	fi

	#set -x
	# File Validation
	#$SHYAML -q keys < $SCTL_FILE | grep config || (echo "sctl -> Error: Invalid configuration." && exit 1)
}

load_config_file()
{
    # Variables
    find_config_file
}
