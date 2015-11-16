#!/bin/bash
source ${PWD}/lib/common.sh
source ${PWD}/lib/optparse.bash

optparse.define short=i long=iteration desc="iteration count" variable=LOOP_COUNT default=3
optparse.define short=r long=receiver desc="email addr for receiving result" variable=RECEIVER default="hm.kim@the-aio.com"

source $( optparse.build )

CONNECTED_AP_INDEX=();
DATE="`date +%F`_`date +%T`"
OUTPUT_DIR="result/[$DATE]"
OUTPUT_FILE_NAME="${OUTPUT_DIR}/${DATE}_test_result.csv"

function usage()
{
	print_err "$0 -i 3 -r hm.kim@the-aio.com"
}

if [ -z $LOOP_COUNT ] || [ $LOOP_COUNT -gt 10 ]|| [ -z $RECEIVER ]; then
	usage;
	exit 1;
fi

reset_adb_server

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
	print_err "no device connected, check adb connection again"
	exit 1;
fi

print_info "conneted AP index : ${CONNECTED_AP_INDEX[@]}"

#in case of msm8974 root mode is needed
for index in "${CONNECTED_AP_INDEX[@]}"
do
	if [ "${AP_LIST[${index}]}" = "msm8974" ];then
		sudo ${ADB} -s ${AP_LIST_DEVICE_NAME[${index}]} root;
	fi
done

#start each automation
for index in "${CONNECTED_AP_INDEX[@]}"
do
	echo "./run_androbench_test.sh -a ${AP_LIST[${index}]} -i ${LOOP_COUNT}"
	./run_androbench_test.sh -a ${AP_LIST[${index}]} -i ${LOOP_COUNT} &
done

#wait all subprocess finished
for job in `jobs -p`
do
	wait ${job};
done

print_info "all automation has finished"

mv result/*.db ${OUTPUT_DIR};

#parse result
for index in "${CONNECTED_AP_INDEX[@]}"
do
	./parsing_result.sh ${AP_LIST[${index}]} ${OUTPUT_DIR}/${AP_LIST[${index}]}_result.db ${OUTPUT_FILE_NAME}
done

#send result to user via email
#from,to,attached_file
send_email "hm.kim@the-aio.com" "hm.kim@the-aio.com" "test complete" ${OUTPUT_FILE_NAME}; 



