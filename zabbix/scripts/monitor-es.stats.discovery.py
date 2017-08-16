#!/usr/bin/env python
# -*- coding: utf-8 -*-
import getpass
import json
import os
import socket

HOSTNAME = socket.gethostname()

DEFAULT_CONF = {
    HOSTNAME: {
        "nodename": HOSTNAME,
        "host": "127.0.0.1",
        "port": "9200",
    }
}


def get_monitor_es_conf(filename):
    if os.path.exists(filename):
        with open(filename, 'r') as fd:
            monitor_es_conf = json.loads(fd.read().strip())
            fd.close()
            return monitor_es_conf
    else:
        return DEFAULT_CONF

if __name__ == '__main__':
    monitor_es_conf = get_monitor_es_conf("/opt/etc/monitor-es.json")
    data = []
    for node, node_conf in monitor_es_conf.items():
        data.append({"{#NODE}":node_conf['nodename']})
    print json.dumps({"data": data})
