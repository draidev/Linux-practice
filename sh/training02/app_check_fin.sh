#!/bin/bash
miss_arr=()
HELP="-h"
SH=$0
FILE=$1


check_input() {
	if [[ $1 == "-h" ]]; then
		display_usage $2
	else
		check_file $1 $2
	fi
}

display_usage(){
		echo "usage) $1 <list_file>"
		exit 0
}

check_file () {
	if [ -f $1 ]; then
		check_ps $1	
	else
		echo "ERROR: no such file '$1'"
		display_usage $2
	fi
}

check_ps() {
	i=0
	 while read line; do
		ps_check=`ps aux | grep "$line" | wc -l`
		if [ $ps_check -le 1 ]; then
			echo -e "$line\t\t\tmissing"
      miss_arr[i]="$line"
			((i+=1))
		else./ ap
			echo -e "$line\t\t\tchecked"
		fi
	done < $1
	print_result
}

print_result() {
	if [ 0 -eq  "${#missing[@]}" ]; then
		echo -e "------------------------------\nAll Success!"
	else
		for value in "${missing[@]}"; do
			echo "ERROR: '$value' not found"
		done
	fi
}

check_input $FILE $SH
