#!/bin/sh

VER="0.0.1"
ES_API="${ES_HOST:-localhost}:${ES_PORT:-9200}"
LOG_FILE=`date "+/data/logs/es-indexdelete-detail-%Y%m.log"`

BASE_DIR=`readlink -f $0`
BASE_DIR=`dirname $BASE_DIR`

echo `date '+%F %X'` indexdelete START

CONF="${BASE_DIR}/es-indexdelete.conf"
[ -f $CONF ] && . $CONF

for index_template in ${daily_index_delete[@]};do
    timeshift=`echo "$index_template" | awk -F\: '{print $1}'`
    index=`echo "$index_template" | awk -F\: '{print $2}'`
    index=`date -d "$timeshift day ago" "+$index"`
    curl -s -X HEAD -w %{http_code} "http://$ES_API/$index/" | grep -qw 200 || continue
    echo `date '+%F %X'` curl -s -X DELETE "http://$ES_API/$index/" START >> $LOG_FILE 2>&1
    curl -s -X DELETE "http://$ES_API/$index/" >> $LOG_FILE 2>&1
    echo -e "\n" `date '+%F %X'` curl -s -X DELETE "http://$ES_API/$index/" END >> $LOG_FILE 2>&1
done

for index_template in ${monthly_index_delete[@]};do
    timeshift=`echo "$index_template" | awk -F\: '{print $1}'`
    index=`echo "$index_template" | awk -F\: '{print $2}'`
    index=`date -d "$timeshift month ago" "+$index"`
    curl -s -X HEAD -w %{http_code} "http://$ES_API/$index/" | grep -qw 200 || continue
    echo `date '+%F %X'` curl -s -X DELETE "http://$ES_API/$index/" START >> $LOG_FILE 2>&1
    curl -s -X DELETE "http://$ES_API/$index/" >> $LOG_FILE 2>&1
    echo -e "\n" `date '+%F %X'` curl -s -X DELETE "http://$ES_API/$index/" END >> $LOG_FILE 2>&1
done

echo `date '+%F %X'` indexdelete END

