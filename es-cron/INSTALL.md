# 安装方法

## 1. crontab方式部署到/etc/cron.d/

    ln -s ./es-forcemerge.sh /etc/cron.d
    ln -s ./es-indexdelete.sh /etc/cron.d

## 2. 创建日志目录
    mkdir -p /data/logs/

## 3. 参考sample，创建配置文件es-forcemerge.conf、es-indexdelete.conf
