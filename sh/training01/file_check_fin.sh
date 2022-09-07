#!/bin/bash
array=( "sna" "snc" "allinone" )
missing=()

input_check() {
	if [[ $1 == "-h" ]]; then
		how $2
	else
		word_check $1 $2
	fi
}

how() {
	how="usage) $1 <sna|snc|allinone>" # usage print
	echo $how
}

word_check() {
	for value in "${array[@]}"; do
		if [ $1 == $value ]; then
			route_check $1
		fi
	done
		echo "NOT SUPPROTED: '$1'"
		how $2
}

route_check() {
	i=0
	while read line; do
		if ! [ -z $line ]; then
			word=$(echo $line | cut -d '/' -f1) # 첫글자 잘라내기
			if [ $1 == $word ]; then # 만약 첫글자와 사용자 입력값이 같으면
				if [ -e $line ]; then # 그 줄 경로 확인
					echo "$line checked" # 존재하면 checked
				else # 존재 하지 않으면 missing 
					echo "$line missing"
					save_missing $i $line
					((i+=1))
				fi
			fi
		fi
	done < list01.txt
	test_complete
}

save_missing() {
	missing[$1]=$2
}

test_complete() {
	if [ 0 -eq  "${#missing[@]}" ]; then
		echo -e "------------------------------\nAll Success!"
	else
		for value in "${missing[@]}"; do
			echo "ERROR: no such file '$value'"
		done
	fi
	exit 100
}

input_check $1 $0
