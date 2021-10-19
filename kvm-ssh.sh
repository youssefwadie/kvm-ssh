#!/bin/bash

if [[ $# -ne 1 ]]; then
        printf "Expected one domain got %d\n" $#
	exit 1
else
	VIRSH_OUTPUT=$(sudo virsh list --all)
	IS_AVAILABLE=$(printf "%s" "$VIRSH_OUTPUT" | awk -v domain=$1 'NR>2 && $2 == domain {printf "%s\n", $2}')
	if [[ -n $IS_AVAILABLE ]]; then
		MACHINE_STATUS=$(printf "%s" "$VIRSH_OUTPUT" | awk -v domain=$1 '$2 == domain {printf "%s%s\n", $3, $4}')
		
		[[ $MACHINE_STATUS != 'running' ]] && sudo virsh start "$1"

		IP=$(sudo virsh domifaddr "$1" | awk 'NR==3 {printf $4}' | cut -d '/' -f 1)
		if [[ -z $IP ]]; then
			printf 'Wating for the machine boot.'
		fi
		while [[ -z $IP ]]; do
			sleep 2
			printf '.'
			IP=$(sudo virsh domifaddr "$1" | awk 'NR==3 {printf $4}' | cut -d '/' -f 1)
		done
		printf '\n'

		# now you can connect via ssh
		# ssh "<USER>@$IP"

		# You may want to get the user name as an input
		# read -p 'User name: ' USERNAME	
		# ssh "$USERNAME@$IP"
		# or just hardcode it
		
		
		# Asumming you're using the same username as the host machine
		ssh "$USER@$IP" 2>/dev/null
		CONNECION_STATUS=$?
		if [[ $CONNECION_STATUS -ne 0 ]]; then
   			printf 'Trying to connect.'
		fi
		if [[ $CONNECION_STATUS -ne 0 ]]; then
			while ! ssh "$USER@$IP" 2>/dev/null ; do
   				sleep 3
   				printf '.'
			done
		fi
		printf '\n'

	else
		printf "%s is not available\n" "$1"
		printf 'Available domains are:\n'
		printf "%s\n" "$VIRSH_OUTPUT" | awk 'NR>2{printf "%s\n", $2}'
	fi
fi

