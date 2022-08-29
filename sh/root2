#!/bin/bash

declare -a miss_arr
miss_arr=()
HELP=-h
SH=$0
FILE=$1

#./app_check -h : print usage and exit
function usage(){
		echo "usage) $SH <list_file>"
		exit 0
}

# ./app_check [FILE_NAME] : display process checked or missing
function check_ps (){
	if [[ -f "$1" ]]; then
		i=0
		while read line; do
			ps_check=`ps aux --sort=-pmem | head -n 100 | grep $line`
			if [[ "$ps_check" =~ "$line" ]]; then
				echo "$line	checked"
			else
				echo "$line	missing"
				$2[i]=$line
				((i+=1))
			fi
		done < $1
	# if input empty string
	elif [[ ${#1} -eq 0 ]]; then
		usage 
	# if input empty file
	else
		echo "ERROR: no such file '$1'"
		usage	
		exit 404
	fi
}

function display_miss(){
	for miss in $1
	do
		echo "ERROR: '$miss' not found"
	done
}

function display_success(){
	if [[ $1 -ne 0 ]]&&[[ $2 -eq 0 ]]; then
		echo "-----------------------------------------------------"
		echo "All Success!"
	fi
}

if [[ $FILE == $HELP ]]; then
	usage
else
	check_ps $FILE ${miss_arr[@]}
	display_miss ${miss_arr[@]}
	display_success ${#FILE} ${#miss_arr[@]}
fi
