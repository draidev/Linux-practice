#!/bin/bash

function change_value(){
	if [[ ${3} =~ ^[0-9]+$ ]]; then
		echo "number"
		tmp=$(mktemp)
		jq ${2}=${3} ${1}.conf > "$tmp" && mv "$tmp" ${1}.conf
	elif [[ ${3} =~ ^ ]]; then	
		tmp=$(mktemp)
		jq ${2}='"'${3}'"' ${1}.conf > "$tmp" && mv "$tmp" ${1}.conf
	else
		tmp=$(mktemp)
		jq ${2}='"'${3}'"' ${1}.conf > "$tmp" && mv "$tmp" ${1}.conf
	fi
}

echo "1. hardoop과 연동할 포트를 입력해 주세요:"
read port_value
FILE_NUM_1=1
KEY_1=".hdfs.port"
change_value $FILE_NUM_1 $KEY_1 $port_value

echo "2. 이 장치의 로그를 저장할 위치를 입력해 주세요:"
read logger_path_value
FILE_NUM_2=2
KEY_2=".global.logger_path"
change_value $FILE_NUM_2 $KEY_2 $logger_path_value

echo "3. 이 장치의 ip 주소를 입력해 주세요:"
read ip_value
FILE_NUM_3=3
KEY_3=".analyzer_nodes[].ip"
change_value $FILE_NUM_3 $KEY_3 $ip_value


#echo "4. 이 장치에서 사용할 thread 갯수를 입력해 주세요:"
#read thread
#
#echo "5. adapter type을 선택해 주세요."
#echo "1) napatech 2) dpdk"
#read adapter


