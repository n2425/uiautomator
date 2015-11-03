#!/bin/bash
ADB="${HOME}/Android/Sdk/platform-tools/adb"
AP_LIST=("rk3288" "allwinner_a80t" "amlogic_s805" "msm8974" "exynos5420")
AP_LIST_DEVICE_NAME=("A0Y9GJTJE1" "20080411" "HKC11122F37DFFC5" "1" "0123456789ABCDEF")
CONNECTED_AP_INDEX=();
DATE="`date +%F`_`date +%T`"
OUTPUT_DIR="result/[$DATE]"
OUTPUT_FILE_NAME="${OUTPUT_DIR}/${DATE}_test_result.csv"
#AP_LIST_DEVICE_NAME=("A0Y9GJTJE1" "20080411" "HKC11122F37DFFC5" "1" "android")

#start adb server
sudo ${ADB} kill-server
sudo ${ADB} start-server

function send_email()
{
	if [ $# -ne 3 ];then
		echo "send_email() from to file";
	fi

	echo "send email callling!!!!!!"

	local from=$1;
	local to=$2;
	local attached_file=$3;

	echo "test complete" | mutt -s "[SQA] host performance test compelte - `date +%F` - `date +%T`" -a ${attached_file} -e "my_hdr FROM:${from}" -- ${to}
}

#make log dir
if [ ! -d  result ];then
	mkdir result;
fi

mkdir -p $OUTPUT_DIR

#check out which devices are connected
i=0
while [ $i -lt ${#AP_LIST_DEVICE_NAME[@]} ]
do
	sudo ${ADB} devices | grep -w ${AP_LIST_DEVICE_NAME[${i}]};
	if [ $? -eq 0 ];then 
		CONNECTED_AP_INDEX+=("${i}");
	fi
	((i++));
done

if [ -z $CONNECTED_AP_INDEX ];then
	echo "[ERROR] no device connected, check adb connection again"
	exit 1;
fi

echo "[DEBUG] conneted AP index : ${CONNECTED_AP_INDEX[@]}"

#in case of msm8974 root mode is needed
for index in "${CONNECTED_AP_INDEX[@]}"
do
	if [ "${AP_LIST[${index}]}" = "msm8974" ];then
		sudo ${ADB} -s 1 root;
	fi
done

#start each automation
for index in "${CONNECTED_AP_INDEX[@]}"
do
	./run_androbench_test.sh ${AP_LIST[${index}]} &
done

#wait all subprocess finished
for job in `jobs -p`
do
	wait ${job};
done

echo "NONONOONO"

echo "[INFO] all automation has finished"

mv result/*.db ${OUTPUT_DIR};

#parse result
for index in "${CONNECTED_AP_INDEX[@]}"
do
	./parsing_result.sh ${AP_LIST[${index}]} ${OUTPUT_DIR}/${AP_LIST[${index}]}_result.db ${OUTPUT_FILE_NAME}
done

#send result to user via email
send_email "hm.kim@the-aio.com" "hm.kim@the-aio.com" ${OUTPUT_FILE_NAME}; #from,to,attached_file



