#!/bin/bash

port_value=""
logger_path_value=""
ip_value=""
thread_count=""
adapter_type_num=""
adapter_type_value=""

INT_RE='^[0-9]+$'
IP_RE='^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$'

FILE_NUM_1="1.conf"
FILE_NUM_2="2.conf"
FILE_NUM_3="3.conf"
FILE_NUM_4="4.conf"
FILE_NUM_5="5.conf"

KEY_1=".hdfs.port"
KEY_2=".global.logger_path"
KEY_3=".analyzer_nodes[].ip"
KEY_4=".threads.num_workers"
KEY_5=".adapter.adapter_type"

input_port() {
	while [[ -z $port_value ]]; do
		echo "1. hardoop과 연동할 포트를 입력해 주세요:"
		read port_value
		check_port $port_value
	done
}

input_logger_path() {
	while [[ -z $logger_path_value ]]; do
		echo "2. 이 장치의 로그를 저장할 위치를 입력해 주세요:"
		read logger_path_value
		check_logger_path $logger_path_value
	done
}

input_ip() {
	while [[ -z $ip_value ]]; do
		echo "3. 이 장치의 ip 주소를 입력해 주세요:"
		read ip_value
		check_ip $ip_value
	done
}

input_thread() {
	while [[ -z $thread_count ]]; do
		echo "4. 이 장치에서 사용할 thread 갯수를 입력해 주세요:"
		read thread_count
		check_thread $thread_count
	done
}

input_adapter() {
	while [[ -z $adapter_type_num ]]; do
		echo "adapter type을 선택 해 주세요."
		echo "1) napatech 2) dpdk"
		read adapter_type_num
		check_adapter $adapter_type_num 
	done
}

# 유효성 검사
check_port() {
		if ! [[ $1 =~ $INT_RE ]] || ! [[ $1 -gt 0 ]] || ! [[ $1 -lt 65536 ]]; then
			port_value=""
			echo "올바르지 않은 형식의 포트 번호 입니다. 1 ~ 65535 사이의 숫자만 입력해 주세요."
		fi
}

check_logger_path() {
	if ! [ -d $1 ]; then
		logger_path_value=""
		echo "존재하지 않는 디렉토리 입니다. 다시 입력해주세요."
	fi
}

check_ip() {
		if ! [[ $1 =~ $IP_RE ]]; then
			ip_value=""
			echo "올바르지 않은 형식의 ip 주소 입니다. 다시 입력해 주세요:"
		fi
}

check_thread() {
		if ! [[ $1 =~ $INT_RE ]]; then
			thread_count=""
			echo "올바르지 않은 형식의 갯수 입니다. 다시 입력해 주세요:"
		fi
}

check_adapter() {
		if ! [[ $1 =~ $INT_RE ]] || [ $1 -ge 3 ]; then
			adapter_type_num=""
			echo "올바르지 않은 형식의 타입입니다. 1과 2 중 다시 선택해 주세요:"
		fi
}

update_conf_value() {
	jq $KEY_1=$port_value $1 > tmp && mv tmp $1
	jq $KEY_2='"'$logger_path_value'"' $2 > tmp && mv tmp $2
	jq $KEY_3='"'$ip_value'"' $3 > tmp && mv tmp $3
	jq $KEY_4=$thread_count $4 > tmp && mv tmp $4
	append_worker $4 $thread_count
	if [ $adapter_type_num -eq 1 ]; then
		delete_dpdk $5
		adapter_type_value="napatech"
	else
		append_dpdk $5
		adapter_type_value="dpdk"
	fi
	jq $KEY_5='"'$adapter_type_value'"' $5 > tmp && mv tmp $5
}

append_worker() {
	num=1
	jq '.threads += {"workers":[]}' $1 > tmp && mv tmp $1
	while [[ $num -le $2 ]]; do
		worker="worker$num"
		cpu=$((num+1))
		jq '.threads.workers += [{"name":"'$worker'", "cpu":'$cpu'}]' $1 > tmp && mv tmp $1
		((num+=1))
	done
}

append_dpdk() {
	jq '.adapter += {"dpdk_device":["eth2"], "dpdk_mode":"sw-rss", "dpdk_failsafe":"off"}' $1 > tmp && mv tmp $1
}

delete_dpdk() {
	jq 'del(.adapter.dpdk_device, .adapter.dpdk_mode, .adapter.dpdk_failsafe)' $1 > tmp.conf && mv tmp.conf $1
}

input_port
input_logger_path
input_ip
input_thread
input_adapter
update_conf_value $FILE_NUM_1 $FILE_NUM_2 $FILE_NUM_3 $FILE_NUM_4 $FILE_NUM_5
