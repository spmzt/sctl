OS=				$$(uname -o)
ARCH=			$$(if [ "$$(uname -m)" = "x86_64" ]; then echo amd64; else uname -m; fi;)
DEBUG=			$$(if [ "${OS}" = "FreeBSD" ]; then echo set -xeouv pipefail; else echo set -xeouv; fi)

SCTL_VERSION=	$$(git rev-parse HEAD)
SCTL_CMD=		/usr/local/bin/sctl

.PHONY: all
all:
	@echo "Nothing to be done. Please use make install or make uninstall"

.PHONY: deps
deps:
	@echo "Install applications"
		@if [ -e /etc/debian_version ]; then\
				DEBIAN_FRONTEND=noninteractive apt install -y net-tools git python3-pip;\
		elif [ "${OS}" = "FreeBSD" ]; then\
				pkg install -y git-lite python3 py311-pip;\
		fi
		@echo
		@echo "Install python applications"
		@pip install -r requirements.txt

.PHONY: install
install: deps
		@echo "Installing sctl"
		@echo
		@cp -Rv usr /
		@chmod +x ${SCTL_CMD}
		@echo
		@echo "Installing sctl configuration"
		@if [ ! -s /usr/local/etc/sctl/sctl.yaml ]; then\
				install /usr/local/etc/sctl/sctl.yaml.sample /usr/local/etc/sctl/sctl.yaml;\
		else\
				echo "sctl configuration file is already exists at /usr/local/etc/sctl/sctl.yaml.";\
				echo "If you want the new configuration use the following command below:";\
				echo "\tinstall /usr/local/etc/sctl/sctl.yaml.sample /usr/local/etc/sctl/sctl.yaml";\
		fi

.PHONY: installonly
installonly:
		@echo "Installing sctl"
		@echo
		@cp -Rv usr /
		@echo
		@echo "This method is for testing / development."

.PHONY: debug
debug:
		@echo
		@echo "Enable Debug"
		@if [ "${OS}" = "FreeBSD" ]; then\
				sed -i '' '1s/$$/\n${DEBUG}/' /usr/local/share/sctl/common.sh;\
		else\
				sed -i -e '1s/$$/\n${DEBUG}/' /usr/local/share/sctl/common.sh;\
		fi
		@echo "Updating sctl version to match git revision."
		@echo "SCTL_VERSION: ${SCTL_VERSION}"
		@sed -i.orig "s/SCTL_VERSION=.*/SCTL_VERSION=${SCTL_VERSION}/" ${SCTL_CMD}
		@echo "This method is for testing & development."
		@echo "Please report any issues to https://github.com/spmzt/sctl/issues"

.PHONY: undebug
undebug:
		@echo
		@echo "Disable Debug without reinstall"
		@if [ "${OS}" = "FreeBSD" ]; then\
				sed -i '' '2d' /usr/local/share/sctl/common.sh;\
		else\
				sed -i -e '2d' /usr/local/share/sctl/common.sh;\
		fi
		@echo "Updating sctl version to match git revision."
		@echo "SCTL_VERSION: ${SCTL_VERSION}"
		@sed -i.orig "s/SCTL_VERSION=.*/SCTL_VERSION=${SCTL_VERSION}/" ${SCTL_CMD}
		@echo "This method is for testing & development."
		@echo "Please report any issues to https://github.com/spmzt/sctl/issues"

.PHONY: dev
dev: install debug

.PHONY: uninstall
uninstall:
		@echo "Removing sctl command"
		@rm -vf ${SCTL_CMD}
		@echo
		@echo "Removing sctl sub-commands"
		@rm -rvf /usr/local/share/sctl
		@echo
		@echo "Removing man page"
		@rm -rvf /usr/local/share/man/man8/sctl.8.gz
		@echo
		@echo "removing sample configuration file"
		@rm -rvf /usr/local/etc/sctl/sctl.yaml.sample
		@echo
		@echo "removing startup script"
		@rm -vf /usr/local/etc/rc.d/sctl
		@if [ ! "${OS}" = "FreeBSD" ]; then rm -vf /etc/systemd/system/*/sctl*.service /etc/systemd/system/sctl*.service; fi
		@echo "You may need to manually remove other filers if it is no longer needed."
