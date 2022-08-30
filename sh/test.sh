#!/bin/bash

re='^[0~9]+$'
a=1234

if [[ $a =~ $re ]]; then
	echo "tr"
else
	echo "fa"
fi
