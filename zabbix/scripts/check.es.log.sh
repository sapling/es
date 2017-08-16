#!/usr/bin/env bash
min10="`date +"%m-%d %H:%M" | cut -c1-10`"
logfile_list="`find /data/logs/elasticsearch*/ -name '*.log'|grep -v index_`"
Critical_list="master_left|ERROR|WARN"
tailn=1000
appear_count=0
all_data=""
for filename in $logfile_list;do
    ret=`tail -n $tailn $filename | grep "$min10" | /bin/grep -E "$Critical_list" | tail -n 1 `
    nret=`tail -n $tailn $filename | grep "$min10" | /bin/grep -E "$Critical_list" | wc -l`
    if [ $nret -gt $appear_count ];then
        all_data="$ret"
        break
    fi
done
if [ -z "$all_data" ];then
    all_data="OK"
fi
echo "$all_data"
