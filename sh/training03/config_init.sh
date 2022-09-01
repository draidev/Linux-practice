#!/bin/bash

FILE_NUM_1=1
FILE_NUM_2=2
FILE_NUM_3=3
FILE_NUM_4=4
FILE_NUM_5=5

KEY_1=".hdfs.port"
KEY_2=".global.logger_path"
KEY_3=".analyzer_nodes[].ip"
KEY_4=".threads.num_workers"
KEY_5=".adapter.adapter_type"

INT_RE='^[0-9]+$'
IP_RE='^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$'


# input value and call modify function
function input_port() {
	port_value=""
	while [[ -z $port_value ]]; do
		echo "1. hardoop과 연동할 포트를 입력해 주세요:"
		read port_value
		if [[ $port_value =~ $INT_RE ]] && [[ $port_value -gt 1025 ]] && [[ $port_value -lt 60000 ]]; then
			modify_int $FILE_NUM_1 $KEY_1 $port_value
		else
			port_value=""
			echo "다시 입력해 주세요."
		fi
	done
} 



function input_logger_path() {
	logger_path_value=""
	while [[ -z $logger_path_value ]]; do
		echo "2. 이 장치의 로그를 저장할 위치를 입력해 주세요:"
		read logger_path_value
		if [[ -d $logger_path_value ]]; then
			modify_str $FILE_NUM_2 $KEY_2 $logger_path_value
		else
			logger_path_value=""
			echo "다시 입력해 주세요."
		fi	
	done
}



function input_ip() {
	ip_value=""
	while [[ -z $ip_value ]]; do
		echo "3. 이 장치의 ip 주소를 입력해 주세요:"
		read ip_value
		if [[ $ip_value =~ $IP_RE ]]; then
			modify_str $FILE_NUM_3 $KEY_3 $ip_value
		else
			ip_value=""
			echo "올바르지 않은 형식의 ip 주소 입니다. 다시 입력해 주세요:"
		fi
	done
}



function input_workers() {
	workers=""
	while [[ -z $workers ]]; do
		echo "4. 이 장치에서 사용할 thread 갯수를 입력해 주세요:"
		read workers
		if [[ $workers =~ $INT_RE ]]; then
			modify_int $FILE_NUM_4 $KEY_4 $workers
			append_workers $FILE_NUM_4 $workers
		else
			workers=""
			echo "다시 입력해 주세요."
		fi
	done
}



function input_adapter_type() {
	adapter_type_num=""
	adapter_type_value=""
	while [[ -z $adapter_type_num ]]; do
		echo "adapter type을 선택 해 주세요."
		echo "1) napatech 2) dpdk"
		read adapter_type_num
		if [[ adapter_type_num -eq 1 ]]; then
			adapter_type_value="napatech"
			modify_str $FILE_NUM_5 $KEY_5 $adapter_type_value
			del_dpdk $FILE_NUM_5
		elif [[ adapter_type_num -eq 2 ]]; then
			adapter_type_value="dpdk"
			modify_str $FILE_NUM_5 $KEY_5 $adapter_type_value
			append_dpdk $FILE_NUM_5
		else
			adapter_type_value=""
			echo "다시 입력해 주세요." 
		fi
	done
}



# modify file and save 
function modify_int() {		
	jq ${2}=${3} ${1}.conf > tmp && mv tmp ${1}.conf
}

function modify_str() {
	jq ${2}='"'${3}'"' ${1}.conf > tmp && mv tmp ${1}.conf
}


# append new json dictionary for workers
function append_workers() {
	worker_i=1
	cpu_i=2
	jq '.threads={"workers":[]}' ${1}.conf > tmp && mv tmp ${1}.conf
	while [[ $worker_i -le ${2} ]]; do
		jq '.threads.workers += [{"name":"worker'$worker_i'", "cpu":'$cpu_i'}]' ${1}.conf > tmp && mv tmp ${1}.conf
		((worker_i+=1))
		((cpu_i+=1))
	done
}


# dpdk function
function append_dpdk() {
	jq '.adapter += {"dpdk_device":["eth2"], "dpdk_mode":"sw-rss", "dpdk_failsafe":"off"}' ${1}.conf > tmp && mv tmp ${1}.conf
}

function del_dpdk(){
	jq 'del(.adapter.dpdk_device, .adapter.dpdk_mode, .adapter.dpdk_failsafe)' ${1}.conf > tmp && mv tmp ${1}.conf
}


# main
input_port
input_logger_path
input_ip
input_workers
input_adapter_type
