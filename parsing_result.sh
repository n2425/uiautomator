#!/bin/bash
INPUT_FILE_NAME=
OUTPUT_FILE_NAME=
AP_NAME=
SQLITE3="$HOME/Android/Sdk/platform-tools/sqlite3"

function usage()
{
	echo "./parse_result AP_NAME INPUT_FILE_NAME OUTPUT_FILE_NAME"
	exit 1;
}

function parse_result()
{
	#echo "${SQLITE3} $INPUT_FILE_NAME 'select * from history' | sed -n 3p"
	first_result=`${SQLITE3} $INPUT_FILE_NAME 'select * from history' | sed -n 3p`;
	second_result=`${SQLITE3} $INPUT_FILE_NAME 'select * from history' | sed -n 2p`;
	third_result=`${SQLITE3} $INPUT_FILE_NAME 'select * from history' | sed -n 1p`;
    
    first_result=`echo $first_result | awk -F'|' '{print $9,$10,$12,$14}'`
    second_result=`echo $second_result | awk -F'|' '{print $9,$10,$12,$14}'`
    third_result=`echo $third_result | awk -F'|' '{print $9,$10,$12,$14}'`

    whole_data=`echo $first_result $second_result $third_result`

    result_seq_read=`echo ${whole_data} | awk 'BEGIN {OFS = ","} {print $1,$5,$9}'`;
    result_seq_write=`echo ${whole_data} | awk 'BEGIN {OFS = ","} {print $2,$6,$10}'`;
    result_rand_read=`echo ${whole_data} | awk 'BEGIN {OFS = ","} {print $3,$7,$11}'`;
    result_rand_write=`echo ${whole_data} | awk 'BEGIN {OFS = ","} {print $4,$8,$12}'`;

    echo "-${AP_NAME}-" >> $OUTPUT_FILE_NAME;
    echo $result_seq_read >> $OUTPUT_FILE_NAME;
    echo $result_seq_write >> $OUTPUT_FILE_NAME;
    echo $result_rand_read >> $OUTPUT_FILE_NAME;
    echo $result_rand_write >> $OUTPUT_FILE_NAME;
    echo "" >> $OUTPUT_FILE_NAME;
}

if [ $# -ne 3 ];then
	usage;
fi

AP_NAME=$1;
INPUT_FILE_NAME=$2;
OUTPUT_FILE_NAME=$3;

parse_result;




