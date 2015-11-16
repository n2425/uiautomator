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
	first_result=`${SQLITE3} $INPUT_FILE_NAME 'select * from history' | tail -10  | sed -n 1p`;
	second_result=`${SQLITE3} $INPUT_FILE_NAME 'select * from history' | tail -10 | sed -n 2p `;
	third_result=`${SQLITE3} $INPUT_FILE_NAME 'select * from history' | tail -10 | sed -n 3p`;
    forth_result=`${SQLITE3} $INPUT_FILE_NAME 'select * from history' | tail -10 | sed -n 4p`;
    fifth_result=`${SQLITE3} $INPUT_FILE_NAME 'select * from history' | tail -10 | sed -n 5p`;
    sixth_result=`${SQLITE3} $INPUT_FILE_NAME 'select * from history' | tail -10 | sed -n 6p`;
    seventh_result=`${SQLITE3} $INPUT_FILE_NAME 'select * from history' | tail -10 | sed -n 7p`;
    eight_result=`${SQLITE3} $INPUT_FILE_NAME 'select * from history' | tail -10 | sed -n 8p`;
    ninth_result=`${SQLITE3} $INPUT_FILE_NAME 'select * from history' | tail -10 | sed -n 9p`;
    tenth_result=`${SQLITE3} $INPUT_FILE_NAME 'select * from history' | tail -10 | sed -n 10p`;

    
    first_result=`echo $first_result | awk -F'|' '{print $9,$10,$12,$14}'`
    second_result=`echo $second_result | awk -F'|' '{print $9,$10,$12,$14}'`
    third_result=`echo $third_result | awk -F'|' '{print $9,$10,$12,$14}'`
    forth_result=`echo $forth_result | awk -F'|' '{print $9,$10,$12,$14}'`
    fifth_result=`echo $fifth_result | awk -F'|' '{print $9,$10,$12,$14}'`
    sixth_result=`echo $sixth_result | awk -F'|' '{print $9,$10,$12,$14}'`
    seventh_result=`echo $seventh_result | awk -F'|' '{print $9,$10,$12,$14}'`
    eight_result=`echo $eight_result | awk -F'|' '{print $9,$10,$12,$14}'`
    ninth_result=`echo $ninth_result | awk -F'|' '{print $9,$10,$12,$14}'`
    tenth_result=`echo $tenth_result | awk -F'|' '{print $9,$10,$12,$14}'`

    whole_data=`echo $first_result $second_result $third_result $forth_result $fifth_result $sixth_result $seventh_result $eight_result $ninth_result $tenth_result`

    result_seq_read=`echo ${whole_data} | awk 'BEGIN {OFS = ","} {print $1,$5,$9,$13,$17,$21,$25,$29,$33,$37}'`;
    result_seq_write=`echo ${whole_data} | awk 'BEGIN {OFS = ","} {print $2,$6,$10,$14,$18,$22,$26,$30,$34,$38}'`;
    result_rand_read=`echo ${whole_data} | awk 'BEGIN {OFS = ","} {print $3,$7,$11,$15,$19,$23,$27,$31,$35,$39}'`;
    result_rand_write=`echo ${whole_data} | awk 'BEGIN {OFS = ","} {print $4,$8,$12,$16,$20,$24,$28,$32,$36,$40}'`;

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




