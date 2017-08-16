#!/usr/bin/env python
# -*- coding: utf-8 -*-
import getpass
import requests
import json
import os
import socket
import commands
import sys

HOSTNAME = socket.gethostname()

DEFAULT_CONF = {
    HOSTNAME: {
        "nodename": HOSTNAME,
        "host": "127.0.0.1",
        "port": "9200",
    }
}

def get_monitor_es_conf(filename):
    """
{
  "es0": {"host": "hostname-es0", "nodename": "es0", "port": "9200"},
  "es1": {"host": "hostname-es1", "nodename": "es1", "port": "8200"}
}
    """
    if os.path.exists(filename):
        with open(filename, 'r') as fd:
            monitor_es_conf = json.loads(fd.read().strip())
            fd.close()
            return monitor_es_conf
    else:
        return DEFAULT_CONF

def get_data(host, port, uri):
    try:
        url = "http://%s:%s/%s" % (host,port,uri)
        response = requests.request("GET", url)
        return json.loads(response.text)
    except Exception:
        print '1'
        sys.exit(1)


if __name__ == '__main__':
    monitor_es_conf = get_monitor_es_conf("/opt/etc/monitor-es.json")
    data = [{"{#IDX}":"_all"}]
    for node, node_conf in monitor_es_conf.items():
        #get _stats info
        cluster_stats = get_data(node_conf['host'], node_conf['port'], '_stats')
        for idx in cluster_stats['indices']:
            data.append({"{#IDX}":idx})

        #get once
        break
    print json.dumps({"data": data})
