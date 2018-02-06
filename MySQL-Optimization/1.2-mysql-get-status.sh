# ========================================================
#  Author: Shaoqun Liu
#    Time: Feb 6, 2018
#  E-mail: liuinstein@163.com | liuinstein@gmail.com
# Website: https://www.shaoqunliu.cn
# license: GPLv3
# ========================================================

#!/bin/sh

# Customize your own options here!
INTERVAL=5s # SUFFIX may be 's' for seconds (the default), 'm' for minutes, 'h' for hours or 'd' for days. Support float number here!
STATUS_DIRECTORY=/home/benchmarks # determines WHERE to save the data
FILE_PREFIX=Test1 # the file name prefix
FILE_SUFFIX=.log # the file name suffix, also determines file extension
MYSQL_USER=root
MYSQL_PASSWORD=mysql
CMD_MYSQL_BASE="mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -e " # WARNING: Using a password on the command line interface can be INSECURE.

# make directories to store output files
mkdir -p $STATUS_DIRECTORY/global
mkdir -p $STATUS_DIRECTORY/engine
mkdir -p $STATUS_DIRECTORY/process

# Write log every $INTERVAL
while true; do
    now_time=$(date +%FT%T)
    load_average="$(uptime)"
    # Global status
    file_global_status=$STATUS_DIRECTORY/global/$FILE_PREFIX-$(date +%F_%H)$FILE_SUFFIX
    echo "$now_time $load_average " >> $file_global_status
    eval $CMD_MYSQL_BASE" 'SHOW GLOBAL STATUS'" >> $file_global_status
    echo "=======================================================================" >> $file_global_status
    # InnoDB storage engine status
    file_engine_status=$STATUS_DIRECTORY/engine/$FILE_PREFIX-$(date +%F_%H)$FILE_SUFFIX
    echo "$now_time $load_average " >> $file_engine_status
    eval $CMD_MYSQL_BASE" 'SHOW ENGINE INNODB STATUS'" >> $file_engine_status
    echo "=======================================================================" >> $file_engine_status
    # Process list
    file_process_status=$STATUS_DIRECTORY/process/$FILE_PREFIX-$(date +%F_%H)$FILE_SUFFIX
    echo "$now_time $load_average " >> $file_process_status
    eval $CMD_MYSQL_BASE" 'SHOW FULL PROCESSLIST'" >> $file_process_status
    echo "=======================================================================" >> $file_process_status
    # --
    echo "Wrote log successfully at "$now_time
    sleep $INTERVAL
done
