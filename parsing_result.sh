#!/bin/bash
INPUT_FILE_NAME=
OUTPUT_FILE_NAME=
AP_NAME=
WHOLE_DATA=./data.tmp
SQLITE3="$HOME/Android/Sdk/platform-tools/sqlite3"

function usage()
{
	echo "./parse_result AP_NAME INPUT_FILE_NAME OUTPUT_FILE_NAME"
	exit 1;
}

function parse_result()
{
    for loop_count in `seq 1 ${LOOP_COUNT[@]}`
    do
        result=`${SQLITE3} $INPUT_FILE_NAME 'select * from history' | tail -10 | sed -n ${loop_count}p`;
        result=`echo $result | awk -F'|' '{print $9,$10,$12,$14}'`
        echo -n $result >> ${WHOLE_DATA}
        echo -n " " >> ${WHOLE_DATA}
    done 

    result_seq_read=`cat ${WHOLE_DATA} | awk 'BEGIN {OFS = ","} {print $1,$5,$9,$13,$17,$21,$25,$29,$33,$37}'`;
    result_seq_write=`cat ${WHOLE_DATA} | awk 'BEGIN {OFS = ","} {print $2,$6,$10,$14,$18,$22,$26,$30,$34,$38}'`;
    result_rand_read=`cat ${WHOLE_DATA} | awk 'BEGIN {OFS = ","} {print $3,$7,$11,$15,$19,$23,$27,$31,$35,$39}'`;
    result_rand_write=`cat ${WHOLE_DATA} | awk 'BEGIN {OFS = ","} {print $4,$8,$12,$16,$20,$24,$28,$32,$36,$40}'`;

    echo "-${AP_NAME}-" >> $OUTPUT_FILE_NAME;
    echo $result_seq_read >> $OUTPUT_FILE_NAME;
    echo $result_seq_write >> $OUTPUT_FILE_NAME;
    echo $result_rand_read >> $OUTPUT_FILE_NAME;
    echo $result_rand_write >> $OUTPUT_FILE_NAME;
    echo "" >> $OUTPUT_FILE_NAME;
}

if [ $# -ne 4 ];then
	usage
fi

AP_NAME=$1
INPUT_FILE_NAME=$2
OUTPUT_FILE_NAME=$3
LOOP_COUNT=$4

parse_result;

rm $WHOLE_DATA;




