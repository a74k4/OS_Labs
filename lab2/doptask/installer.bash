#!/bin/bash

if [ $# -ne 3 ]; then
  echo "Not enough arguments"
  exit 1
fi

if [ ! -f "$1" ]; then 
  echo "$1 is wrong"
  exit 1
fi

if [ "$2" != "console" ]; then
	:>$2
	exec > $2
fi

echo "Start installing"

program_file_name=$1
log_source=$2
log_level=$3
new_program="${program_file_name%.txt}.sh"

if [ -f "$new_program" ]; then
	installed_version=$(grep -E "^#Version: " "$new_program" | awk '{print $3}')
	new_version=$(grep -E "^#Version: " "$program_file_name" | awk '{print $3}')

	if [[ "$new_version" > "$installed_version" ]]; then
		echo "Warning: newer version available"
	else
		echo "Already installed"
		exit 0
	fi
fi

sed '/#TEMPLATE/d' "$1" > "$new_program"

echo "Complete"
