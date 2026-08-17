#!/bin/bash

print_section(){
	echo
	echo "[ $1 ]"
}

show_header(){
	echo "==========================================="
	echo "	  LABEX SYSTEM INFORMATION"
	echo "==========================================="
}

show_system() {
	#system info will go here
	local host 
	local os
	local kernel
	local arch 
	local uptime

	host=$(hostname)
	os=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d '"' -f2)
	kernel=$(uname -r)
	arch=$(uname -m)
	uptime=$(uptime -p) 

	
	print_section "SYSTEM"

	echo "Hostname          : $host"
	echo "Operating System  : $os"
	echo "Kernel            : $kernel"
	echo "Architecture      : $arch"
	echo "Uptime            : $uptime"
}


show_hardware(){
	local cpu
	local cores
	local memory
	local disk
	
	cpu=$(lscpu | grep '^Model name:' | cut -d ':' -f2 | xargs)
	cores=$(nproc)
	memory=$(free -h | awk '/^Mem:/ {print $3 " used / " $2 " total"}')
	disk=$(df -h / | awk 'NR==2 {print $3 " used / " $2 " total (" $5 " used)"}') 

	
	print_section "HARDWARE"
	
	echo "CPU 	: $cpu"
	echo "CPU Cores	: $cores"
	echo "Memory	: $memory"
	echo "Disk	: $disk"
}

show_users(){
	local user
	local user_count
		
	users=$(who)
	user_count=$(who | wc -l)


	print_section  "USERS"
	echo "Logged-in Users	: $user_count"

	if [ "$user_count" -gt 0 ]; then
		echo
		echo "$users"
	else
		echo "No users currently logged in."
	fi
}

show_network(){
	local interfaces
	
	interfaces=$(ip -br addr)

	
	print_section "NETWORK"

	echo "Interfaces and IP Addresses:"
	echo
	echo "$interfaces"
}

show_services(){
	local services
	
	services=$(systemctl list-units --type=service --state=running --no-pager)


	print_section "SERVICES"
	echo "Running Services:"
	echo
	echo "$services"
}



show_header
show_system
show_hardware
show_users
show_network
show_services





























