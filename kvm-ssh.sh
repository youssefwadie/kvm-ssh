#!/bin/bash

if [[ $# -ne 1 ]]; then
        printf "Expected one domain got %d\n", $#
	exit 1
else
	AVALIABLE_MACHINES=$(sudo virsh list --all)
	IS_AVALIABLE=$(printf "%s", "$AVALIABLE_MACHINES" | awk 'NR>2 {printf "%s\n", $2}' | grep -E "^${1}$")
	
	if [[ -n $IS_AVALIABLE ]]; then
		MACHINE_STATUS=$(printf "%s", "$AVALIABLE_MACHINES" | grep "${1}" | awk '{printf $3$4}')	
		[[ $MACHINE_STATUS != 'running' ]] && sudo virsh start "$1"

		IP=$(sudo virsh domifaddr "$1" | awk 'NR==3 {printf $4}' | cut -d '/' -f 1)
		if [[ -z $IP ]]; then
			printf 'Wating for the machine boot.'
		fi
		while [[ -z $IP ]]; do
			sleep 1
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
		if ! ssh "$USER@$IP" 2>/dev/null; then	
   			printf 'Trying to connect.'
		fi

		while ! ssh "$USER@$IP" 2>/dev/null ; do
   			sleep 3
   			printf '.'
		done
		printf '\n'

	else
		printf "%s is not avaliable\n" "$1"
		printf 'Avaliable domains are:\n'
		printf "%s\n", "$AVALIABLE_MACHINES"
	fi
fi

