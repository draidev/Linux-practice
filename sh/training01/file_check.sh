#!/bin/bash

declare -a CMDS
miss_arr=()
CMDS=(-h snu snc allinone)

function usage(){
	echo "usage) file_check.sh <sna|snc|allinone>"
}

CMD=$1

if [[ " ${CMDS[@]} " =~ " $CMD " ]]
then
	case $CMD in
	-h) 
		usage
		exit 0;;
	snc)	
	i=1
	while read line; do
		if [ -e "$line" ]; then
			echo "$line checked"
		else	
			echo "$line missing"
			miss_arr[i]=$line
			((i+=1))
		fi
	done < list.txt;;
	esac

else
	echo "NOT SURPPORTED:'$CMD'"
	usage
	exit 2
fi

for i in ${miss_arr[@]}
do
	echo "ERROR: no such file '$i'"
done

if [ ${#miss_arr[@]} -eq 0 ]; then
	echo "-----------------------------"
	echo "All Success!"
fi
