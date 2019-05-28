#!/bin/sh

SSHDIR="/etc/ansible/.ssh"

mkdir -p "$SSHDIR"
chown root:root "$SSHDIR"
chmod 0700 "$SSHDIR"

case "$1" in
	ssh-keygen)
		shift

		ssh-keygen -f ~/.ssh/id_rsa "$@"

		sed -i 's/@.*$/@docker-based-ansible-control-node/' ~/.ssh/id_rsa.pub

		cat <<EOT

The following content must be pasted into file ~/.ssh/authorized_keys on
every remote system to be controlled via ansible. MAKE SURE IT'S PASTED AS A
SINGLE LINE!

EOT
		cat ~/.ssh/id_rsa.pub
		;;

	edit-hosts)
		nano /etc/ansible/hosts
		;;

	shell)
		shift

		exec /bin/sh "$@"
		;;

	ansible-config|ansible-console|ansible-doc|ansible-galaxy|ansible-inventory|ansible-playbook|ansible-pull|ansible-vault)
		name="${1}"
		shift

		if [ -f ~/.ssh/id_rsa ]; then
			args=
			for arg in "$@"; do
				args="$args '$arg'"
			done

			exec ssh-agent /bin/sh -c "ssh-add ~/.ssh/id_rsa && /usr/bin/$name $args"
		else
			exec /usr/bin/${name} $args
		fi
		;;

	*)
		if [ -f ~/.ssh/id_rsa ]; then
			args=
			for arg in "$@"; do
				args="$args '$arg'"
			done

			exec ssh-agent /bin/sh -c "ssh-add ~/.ssh/id_rsa && /usr/bin/ansible $args"
		else
			exec /usr/bin/ansible "$@"
		fi
		;;
esac
