#!/bin/sh
#
# Import libraries
# Base library should be first to call
. /usr/local/share/sctl/lib/base-lib.sh

# Load the configuration file
. /usr/local/share/sctl/lib/config-file.sh
load_config_file

. /usr/local/share/sctl/lib/yaml.sh
. /usr/local/share/sctl/lib/ipv6-lib.sh
. /usr/local/share/sctl/lib/jail-lib.sh
