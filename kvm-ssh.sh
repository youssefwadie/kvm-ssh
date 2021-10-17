#!/bin/bash

if [[ $# -ne 1 ]]; then
        printf "Expected one domain got $#\n"
	exit 1
else
	AVALIABLE_MACHINES=$(sudo virsh list --all)
	IS_AVALIABLE=$(printf "$AVALIABLE_MACHINES" | awk 'NR>1 {printf $2}' | grep -E "^${1}$")
	
	if [[ -n $IS_AVALIABLE ]]; then
		MACHINE_STATUS=$(printf "$AVALIABLE_MACHINES" | grep "${1}" | awk '{printf $3$4}')	
		[[ ! $MACHINE_STATUS = 'running' ]] && sudo virsh start $1

		IP=$(sudo virsh domifaddr "$1" | awk 'NR==3 {print $4}' | cut -d '/' -f 1)
		
		# now you can connect via ssh
		# ssh "<USER>@$IP"

		# You may want to get the user name as an input
		# read -p 'User name: ' USERNAME	
		# ssh "$USERNAME@$IP"
		# or just hardcode it
		
		# Asumming you're using the same username as the host machine
		ssh "$USER@$IP" 2>/dev/null
		while [[ $? -gt 0 ]]; do
   			sleep 3
   			echo "Trying to connect..."
			ssh "$USER@$IP" 2>/dev/null
		done
	else
		printf "$1 is not avaliable\n"
		printf 'Avaliable domains are:\n'
		printf "$AVALIABLE_MACHINES\n"
	fi
fi

