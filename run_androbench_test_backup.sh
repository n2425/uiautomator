#!/bin/bash

#return value macro
AP_LIST_NOT_FOUND=255;

AP_LIST=("rk3288" "allwinner_a80t" "amlogic_s805" "msm8974" "exynos5420")
AP_LIST_DEVICE_NAME=("A0Y9GJTJE1" "20080411" "HKC11122F37DFFC5" "1" "android")

#vars
DATE=`date`
INDEX=
ADB="${HOME}/Android/Sdk/platform-tools/adb"
ANDROBENCH_APK="AndroBench-v4.0.1.apk"
AUTOMATION_JAR="Automation.jar"
TEST_RESULT="/data/data/com.andromeda.androbench2/databases/history.db"

function usage()
{
	echo "./run_androbench_test AP_name"
	echo "AP list: rk3288, allwinner_a80t, amlogic_s805, msm8994, exynos5420"
}

# $1: ap name  return: ap_list_index
function find_ap_list_index()
{
	local i=0;

	if [ $# -ne 1 ]; then
		echo "not enough argument";
		exit 1;
	fi

	for ap in "${AP_LIST[@]}"
	do
		if [ "$ap" = "$1" ]; then
			echo $i;
			return;
		fi
		((i++));
	done

	echo ${AP_LIST_NOT_FOUND};
}

# $1: ap_list_index
function is_adb_connected()
{	
	#echo "debug : ${AP_LIST_DEVICE_NAME[${1}]}"
	sudo ${ADB} kill-server;
	sudo ${ADB} devices | grep -w "${AP_LIST_DEVICE_NAME[${1}]}";

	if [ $? -ne 0 ]; then 
		echo 1;
	else
		echo 0;
	fi
}

function send_email()
{
	echo "host performance test has finished ." | mutt -s "[SQA] host performance test (Androbench) result complete $DATE" -a ./test -e "my_hdr FROM:peteam@sqa.mail" -- hm.kim@the-aio.com
}

#main

if [ $# -ne 1 ];then
	usage;
	exit 1;
fi 

INDEX=$(find_ap_list_index ${1});

if [ "${INDEX}" = "${AP_LIST_NOT_FOUND}" ];then 
	echo "cannot find ap name , check ap name arguemnt again";
	exit 1;
fi

echo "[debug] index is $INDEX"

ADB_CONNECTION=$(is_adb_connected $INDEX);

if [ "${ADB_CONNECTION}" = "1" ]; then
	echo "this device is not in the adb device list, check adb connection"
	exit 1;
fi

#install androbench
echo "step1 install androbench"
sudo ${ADB} -s ${AP_LIST_DEVICE_NAME[${INDEX}]} install ${ANDROBENCH_APK};

#send jar file
echo "step2 push jar to the device"
sudo ${ADB} -s ${AP_LIST_DEVICE_NAME[${INDEX}]} push uiautomator/bin/${AUTOMATION_JAR} /data/local/tmp

#launch androbench
echo "step3 start androbench"
sudo ${ADB} -s ${AP_LIST_DEVICE_NAME[${INDEX}]} shell 'am start -a android.intent.category.LAUNCHER -n com.andromeda.androbench2/.main'

#start test
echo "step4 automation start"
sudo ${ADB} -s ${AP_LIST_DEVICE_NAME[${INDEX}]} shell uiautomator runtest ${AUTOMATION_JAR}

#pull result
echo "step5 pull result"
sudo ${ADB} -s ${AP_LIST_DEVICE_NAME[${INDEX}]} -d pull ${TEST_RESULT} ./${AP_LIST[${INDEX}]}_result.db

exit 0;

#adb pull db file 
#parsing db result
#summarize all the result
