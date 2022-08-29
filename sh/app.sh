#!/bin/bash

declare -a miss_arr
miss_arr=()
HELP=-h
SH=$0
FILE=$1

#./app_check -h : print usage and exit
function usage(){
	if [[ "$1" == "$2" ]]; then
		echo "usage) $SH <list_file>"
		exit 0
	fi
}
# ./app_check [FILE_NAME] : display process checked or missing
#function check_ps (){
#	if [[ -f "$1" ]]; then
#		i=0
#		while read line; do
#			ps_check=`ps aux --sort=-pmem | head -n 100 | grep $line`
#			if [[ "$ps_check" =~ "$line" ]]; then
#				echo "$line	checked"
#			else
#				echo "$line	missing"
#				$2[i]=$line
#				((i+=1))
#			fi
#		done < $1
#	elif [[ -f "$1" ]]; then
#	else
#		echo "ERROR: no such file '$1'"
#		echo "usage) $SH <list_file>"	
#		exit 404
#	fi
#}


# -h : printf usage and exit
#if [[ " $HELP " == " $CMD " ]]
#then
#	usage
#	exit 0  
#fi

usage $FILE $HELP
#check_ps $FILE "${miss_arr[@]}"
if [[ -f "$FILE"  ]]
then
	i=0
	while read line; do
	ps_check=`ps aux --sort=-pmem | head -n 100 | grep $line`
		if [[ "$ps_check" =~ "$line" ]]; then
			echo "$line	checked"
		else
			echo "$line	missing"
			miss_arr[i]=$line
			((i+=1))			
		fi			
	done < $FILE
else
	echo "ERROR: no such file '$1'"
	usage
	exit 404
fi

for miss in ${miss_arr[@]}
do	
	echo "ERROR: '$miss' not found"
done

if [ ${#miss_arr[@]} -eq 0 ]; then
	echo "-------------------------------------------"
	echo "All Success!"
fi
