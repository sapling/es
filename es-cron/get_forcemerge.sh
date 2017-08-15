ES_API="${ES_HOST:-localhost}:${ES_PORT:-9200}"
curl -s -X GET "http://$ES_API/_tasks?detailed=true&actions=*forcemerge&pretty"
