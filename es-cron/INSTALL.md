# 安装方法

## 1. crontab方式部署到/etc/cron.d/

    ln -s ./es-forcemerge.sh /etc/cron.d
    ln -s ./es-indexdelete.sh /etc/cron.d

## 2. 创建日志目录
    mkdir -p /data/logs/

## 3. 参考sample，创建配置文件es-forcemerge.conf、es-indexdelete.conf

## 4. 如果ES所在机器不是本机，需要加入设置环境设置
    export ES_HOST=localhost ES_PORT=9200 && xx.sh
