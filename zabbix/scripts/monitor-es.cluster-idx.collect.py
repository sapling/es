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
tmpfile = '/tmp/monitor_es_cluster_idx.tmp.%s' % (getpass.getuser())

DEFAULT_CONF = {
    HOSTNAME: {
        "nodename": HOSTNAME,
        "host": "127.0.0.1",
        "port": "9200",
    }
}

def get_zabbix_server():
    for line in open('/opt/zabbix/etc/zabbix_agentd.conf').readlines():
        if line.startswith('#'): continue
        if line.startswith('Server='): return line.split('=')[1].strip()
    return None

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


def kvreturn(kv, kname, node_conf, f):
    for k, v in kv.items():
        if type(v) is dict:
            if kname == 'cluster':
                k = "%s,%s" % (kname, k)
            else:
                k = "%s-%s" % (kname, k)
            kvreturn(v, k, node_conf, f)
        else:
            line = "%s monitor-es-cluster-idx[%s,%s] %s\n" % (HOSTNAME, kname, k, v)
            f.write(line)


if __name__ == '__main__':

    zabbix_server = get_zabbix_server()
    if not zabbix_server:
        print "could not find zabbix server"
        sys.exit(1)

    monitor_es_conf = get_monitor_es_conf("/opt/etc/monitor-es.json")
    f = open(tmpfile, 'w')
    for node, node_conf in monitor_es_conf.items():
        #get _cluster/stats info
        cluster_stats = get_data(node_conf['host'], node_conf['port'], '_cluster/stats')
        kvreturn(cluster_stats, 'cluster', node_conf, f)

        #get _stats info
        cluster_stats = get_data(node_conf['host'], node_conf['port'], '_stats')
        kvreturn(cluster_stats, 'cluster', node_conf, f)

        #get once
        break
    f.close()

    cmd = "/opt/zabbix/bin/zabbix_sender -z %s -i %s" % (zabbix_server, tmpfile)
    (status, output) = commands.getstatusoutput(cmd)
    print status
    sys.exit(status)
