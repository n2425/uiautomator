#!/bin/sh

#check adb connection
adb devices | wc -l

loop each devices

adb connect 
adb gethostname 
adb install 

send jar

#install androbench in all the boards

#send jar file each in all the boards

#launch automation

#adb pull db file 
#parsing db result
#summarize all the result
