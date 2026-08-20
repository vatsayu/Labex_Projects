#!/bin/bash

print_header() {
	echo "=================================="
	echo " 	   LABEX FILE SEARCH"
	echo "=================================="
}

search_files(){
	local search_dir="$1"
	local pattern="$2"
	local results 
	local count 

	if [ ! -d "$search_dir" ]; then
	 echo "[ERROR] Directory does not exist: $search_dir"
	 return 1
	fi

	results=$(find "$search_dir" -type f -name "$pattern")
	count=$(printf '%s\n' "$results" |  grep -c . )

	echo
	echo "[ SEARCH RESULTS]"
	echo "Directory : $search_dir"
	echo "Pattern	: $pattern"
	echo
	
	if [ "$count" -eq 0 ]; then
	   echo "No matching files found."
	   return 0
	fi
	
	echo "$results"
	echo
	echo "Total files found: $count"

}

print_header

if [ "$#" -ne 2 ]; then
   echo "Usage: $0 <directory> <filename-pattern>"
   exit 1
fi


search_files "$1" "$2"

