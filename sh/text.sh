#!/bin/bash

function test() {
	echo ${1}
	tmp=$(mktemp)
	#jq --arg a "change/dddd" '.global.logger_path=$a' temp.config > "$tmp" && mv "$tmp" temp.config 
	cat ${1}.conf | jq '.global.logger=$"{change}"' > temp.config
	cat temp.config
}

file_num=2
path=".global.logger_path"
change="change/log"

test $file_num $path $change
