#!/bin/bash
source ${PWD}/lib/common.sh
source ${PWD}/lib/optparse.bash

optparse.define short=a long=ap desc="ap_name" variable=AP_NAME
optparse.define short=i long=iteration desc="iteration count" variable=LOOP_COUNT default=3
source $( optparse.build )

#macro
AP_LIST_NOT_FOUND=255;

#vars
INDEX=
TEST_RESULT="/data/data/com.andromeda.androbench2/databases/history.db"

function usage()
{
	print_err "(${AP_NAME}) $0 -a AP_name -i loop_count"
	print_err "AP list: rk3288, allwinner_a80t, amlogic_s805, msm8974, exynos5420"
}

#main
if [ -z ${AP_NAME} ] || [ $(check_ap_arg_correct "${AP_NAME}") -eq 1 ] ;then
	usage;
	exit 1;
fi 

INDEX=$(find_index_for_ap ${AP_NAME});

#wait for adb conenction
sleep 2;

ADB_CONNECTION=$(is_adb_connected $AP_NAME);

#sudo ${ADB} devices 
if [ "${ADB_CONNECTION}" = "1" ]; then
	print_err "[${AP_NAME}] no adb connection"
	exit 1;
fi

#in case of msm8974 unlock screen is firstly needed
if [ "${AP_NAME}" = "msm8974" ] || [ "${AP_NAME}" = "exynos5420" ]; then
	print_info "step0 disable_suspend"
	sudo ${ADB} -s ${AP_LIST_DEVICE_NAME[${INDEX}]} push ./disablesuspend.sh /data/local/tmp;
	sudo ${ADB} -s ${AP_LIST_DEVICE_NAME[${INDEX}]} shell /data/local/tmp/disablesuspend.sh;
fi

#unlock
sudo ${ADB} -s ${AP_LIST_DEVICE_NAME[${INDEX}]} shell input keyevent 82

#install androbench
print_info "[${AP_NAME}] step1 install androbench"
sudo ${ADB} -s ${AP_LIST_DEVICE_NAME[${INDEX}]} install ${ANDROBENCH_APK};

sleep 20;

#send jar file
print_info "[${AP_NAME}] step2 push jar to the device"
sudo ${ADB} -s ${AP_LIST_DEVICE_NAME[${INDEX}]} push uiautomator/bin/${AUTOMATION_JAR} /data/local/tmp

sleep 5;
#launch androbench
print_info "[${AP_NAME}] step3 start androbench"
sudo ${ADB} -s ${AP_LIST_DEVICE_NAME[${INDEX}]} shell 'am start -a android.intent.category.LAUNCHER -n com.andromeda.androbench2/.main'

sleep 15;
#start test
print_info "[${AP_NAME}] step4 automation start"
print_info "sudo ${ADB} -s ${AP_LIST_DEVICE_NAME[${INDEX}]} shell uiautomator runtest ${AUTOMATION_JAR} -c Androbench -e loop ${LOOP_COUNT}"
sudo ${ADB} -s ${AP_LIST_DEVICE_NAME[${INDEX}]} shell uiautomator runtest ${AUTOMATION_JAR} -c Androbench -e loop "${LOOP_COUNT}"

#pull result
print_info "[${AP_NAME}] tep5 pull result"
sudo ${ADB} -s ${AP_LIST_DEVICE_NAME[${INDEX}]} pull ${TEST_RESULT} result/${AP_LIST[${INDEX}]}_result.db

print_info "[${AP_NAME}] test has finished";
exit 0;
