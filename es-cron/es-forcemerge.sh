#!/bin/sh

VER="0.0.1"
ES_API="${ES_HOST:-localhost}:${ES_PORT:-9200}"
LOG_FILE=`date "+/data/logs/es-forcemerge-detail-%Y%m.log"`

BASE_DIR=`readlink -f $0`
BASE_DIR=`dirname $BASE_DIR`

echo `date '+%F %X'` forcemerge START

CONF="${BASE_DIR}/es-forcemerge.conf"
[ -f $CONF ] && . $CONF

for index in ${daily_forcemerge_index_max_segments2[@]};do
    index=`date -d '1 day ago' "+$index"`
    echo `date '+%F %X'` curl -s -X POST "http://$ES_API/$index/_forcemerge?max_num_segments=2" START >> $LOG_FILE 2>&1
    curl -s -X POST "http://$ES_API/$index/_forcemerge?max_num_segments=2" >> $LOG_FILE 2>&1
    echo -e "\n" `date '+%F %X'` curl -s -X POST "http://$ES_API/$index/_forcemerge?max_num_segments=2" END >> $LOG_FILE 2>&1
done

for index in ${daily_forcemerge_index_max_segments5[@]};do
    index=`date -d '1 day ago' "+$index"`
    echo `date '+%F %X'` curl -s -X POST "http://$ES_API/$index/_forcemerge?max_num_segments=5" START >> $LOG_FILE 2>&1
    curl -s -X POST "http://$ES_API/$index/_forcemerge?max_num_segments=5" >> $LOG_FILE 2>&1
    echo -e "\n" `date '+%F %X'` curl -s -X POST "http://$ES_API/$index/_forcemerge?max_num_segments=5" END >> $LOG_FILE 2>&1
done

for index in ${monthly_forcemerge_index_max_segments2[@]};do
    index=`date -d '1 month ago' "+$index"`
    echo `date '+%F %X'` curl -s -X POST "http://$ES_API/$index/_forcemerge?max_num_segments=2" START >> $LOG_FILE 2>&1
    curl -s -X POST "http://$ES_API/$index/_forcemerge?max_num_segments=2" >> $LOG_FILE 2>&1
    echo -e "\n" `date '+%F %X'` curl -s -X POST "http://$ES_API/$index/_forcemerge?max_num_segments=2" END >> $LOG_FILE 2>&1
done

echo `date '+%F %X'` forcemerge END

