#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "[ERROR] This script must be run with sudo or as root."
    echo "Usage: sudo $0 <username> <primary-group>"
    exit 1
fi

echo "===================================="
echo "	   USER ACCOUNT SETUP"
echo "===================================="


if [ "$#" -ne 2 ]; then
    echo
	echo "Usage: $0 <username> <primary-group>"
	exit 1
fi

username="$1"
group="$2"

if [[ ! "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
	echo "[ERROR] Invalid username: $username"
	exit 1
fi

if [[ ! "$group" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
    echo "[ERROR] Invalid group name: $group"
    exit 1
fi

echo
echo "[ Account Setup ]"
echo "Username      : $username"
echo "Primary Group : $group"

if getent group "$group" >/dev/null 2>&1; then
	echo "Group already exists."
else
	sudo groupadd "$group"

	if [ "$?" -eq 0 ]; then 
		echo "Group created successfully."
	else
		echo "[ERROR] Failed to create group."
		exit 1
	fi
fi

sudo useradd -m -g "$group" -s /bin/bash "$username"

if [ "$?" -eq 0 ]; then
	echo "User created Successfully."
else
	echo "Failed to Create User."
	exit 1
fi

echo
echo "[ Security Configuration ]"

sudo chage -m 1 -M 90 -W 14 -I 30 "$username"

if [ "$?" -eq 0 ]; then
    echo "Password aging configured successfully."
else
    echo "[ERROR] Failed to configure password aging."
    exit 1
fi

echo
echo "[ Verification ]" 

id "$username"

echo
echo "HOME DIRECTORY:"
ls -ld "/home/$username"

echo
echo "Account Record:"
getent passwd "$username"



