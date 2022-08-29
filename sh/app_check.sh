#!/bin/bash

declare -a miss_arr
miss_arr=()
HELP=-h
SH=$0
FILE=$1

#./app_check -h : print usage and exit
function display_usage(){
		echo "usage) $SH <list_file>"
		exit 0
}

# ./app_check [FILE_NAME] : display process checked or missing
function check_ps (){
    arr=("$@")
	if [[ -f "$1" ]]; then
		i=1
		while read line; do
			ps_check=`ps aux --sort=-pmem | head -n 100 | grep $line`
			if [[ "$ps_check" =~ "$line" ]]; then
				echo "$line checked"
			else
                echo "$line missing"
                miss_arr[i]="$line"
                #arr[i]="$line"
                #arr[i]="$line"
                #echo "ARRAY ${#arr[@]}"
                #echo "MISS ${#miss_arr[@]}"
                ((i+=1)) 
			fi
		done < $1
	# if input empty string
	elif [[ ${#1} -eq 0 ]]; then
        echo "ERROR: input empty string"
		display_usage

	# if input not exist file
	else
		echo "ERROR: no such file '$1'"
		display_usage	
	fi
}

function display_miss(){
    arr=$1
    for miss in ${arr[*]}
	do
		echo "ERROR: '$miss' not found"
	done
}

function display_success(){
		echo "-----------------------------------------------------"
		echo "All Success!"
}


if [[ $FILE == $HELP ]]; then
	display_usage
else
	check_ps $FILE "${miss_arr[@]}"
	if [[ ${#miss_arr} -gt 0 ]]; then
        display_miss "${miss_arr[*]}"
    fi
    if [[ ${#FILE} -gt 0 ]]&&[[ ${#miss_arr[@]} -eq 0 ]]; then
	    display_success
    fi
fi
