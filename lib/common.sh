#!/bin/bash
AP_LIST=("rk3288" "allwinner_a80t" "amlogic_s805" "msm8974" "exynos5420")
AP_LIST_DEVICE_NAME=("A0Y9GJTJE1" "20080411" "HKC11122F37DFFC5" "ff050000" "0123456789ABCDEF")
#MAX_NUM_OF_AP_LIST=${#AP_LIST[@]}

#Essential utilities
ADB="${HOME}/Android/Sdk/platform-tools/adb"
ANDROBENCH_APK="AndroBench-v4.0.1.apk"
AUTOMATION_JAR="uiautomator.jar"

function print_info()
{
	echo -e "\e[32m${1}\e[0m";
}

function print_err()
{
	echo -e "\e[31m${1}\e[0m";
}

function check_ap_arg_correct
{
	if [ $# -ne 1 ];then
		print_err "[ERROR] $FUNCNAME ap_name"
		return 1;
	fi

	local i=0
	while [ $i -lt ${#AP_LIST} ]
	do
		if [ "$1" = "${AP_LIST[${i}]}" ];then
			echo 0; 
			return;
		fi
		((i++));
	done
	echo 1;
}

function reset_adb_server()
{
	sudo ${ADB} kill-server
	sudo ${ADB} start-server
}

function find_index_for_ap()
{
	#check out which devices are connected
	local i=0;
	while [ $i -lt ${#AP_LIST[@]} ]
	do
		if [ "$1" = "${AP_LIST[${i}]}" ];then
			echo $i;
			break;
		fi
		
		((i++));
	done
}

function is_adb_connected()
{		
	local index=$(find_index_for_ap ${1});
	sudo ${ADB} devices | grep -w "${AP_LIST_DEVICE_NAME[${index}]}";

	if [ $? -ne 0 ]; then 
		reset_adb_server;
		sudo ${ADB} devices | grep -w "${AP_LIST_DEVICE_NAME[${index}]}";
		if [ $? -ne 0 ]; then 
			echo 1;
		else
			echo 0;
		fi
	else
		echo 0;
	fi
}

function send_email()
{
	if [ $# -ne 4 ];then
		echo "send_email() from to message file";
	fi

	echo "send email callling!!!!!!"

	local from=$1;
	local to=$2;
	local message=$3;
	local attached_file=$4;

	echo "${message}" | mutt -s "[SQA] host performance test compelte - `date +%F` - `date +%T`" -a ${attached_file} -e "my_hdr FROM:${from}" -- ${to}
}

function get_available_disk_space()
{
	local index=$(find_index_for_ap "$1")

	if [ "$1" = "rk3288" ]; then
		echo `sudo ${ADB} -s ${AP_LIST_DEVICE_NAME[${index}]} shell "busybox df | grep -w /data" | awk '{print $3}' | tail -1`

	elif [ "$1" = "allwinner_a80t" ]; then
		echo `sudo ${ADB} -s ${AP_LIST_DEVICE_NAME[${index}]} shell "busybox df | grep -w /data" | awk '{print $3}'`

	elif [ "$1" = "amlogic_s805" ]; then
		echo `sudo ${ADB} -s ${AP_LIST_DEVICE_NAME[${index}]} shell "busybox df | grep -w /data" | awk '{print $4}'`

	elif [ "$1" = "msm8974" ]; then
		echo `sudo ${ADB} -s ${AP_LIST_DEVICE_NAME[${index}]} shell "busybox df | grep -w /data" | awk '{print $3}'`

	elif [ "$1" = "exynos5420" ]; then
		echo `sudo ${ADB} -s ${AP_LIST_DEVICE_NAME[${index}]} shell "busybox df | grep -w /data" | awk '{print $4}'`
	fi
}