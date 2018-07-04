---
title: MySQL 資料庫備份與還原
lang: zh-tw
date: 2018-07-04 12:06:09
tags:
  - MySQL
  - Database
categories: 技術分享
---

由與手上維護幾個公司內部系統，其用到的 MySQL 資料量大約每個 Table 不超過 1GB，因此設計一個 Bash Script 用來排程自動備份整個資料庫，以利發生災難時，還有機會把資料庫還原回來。

<!--more-->

# 備份 DB

備份匯出 MySQL 最常見的是使用 mysqldump 指令，使用這個指令基本上是單一個 Proccess，如果資料表過大，匯出與會入可能會花一些時間。因此推薦改良一下備份方式，使用 mysqldump 匯出時，分開匯出 `結構` 與 `資料`，以利未來還原的時候可以開多個 Proccess 同步執行。

## 備份資料庫

```sh
#!/bin/bash

DB_HOST=127.0.0.1  # replace with db host or ip
DB_USER=root  # replace with db username
DB_PASSWD=my-db-secret # replace with your password
BACKUP_DIR=/storage/backup/mysql/`date '+%d-%m-%Y-%H-%M')`  # replace with your directory

COMMIT_COUNT=0
COMMIT_LIMIT=10

mkdir -p $BACKUP_DIR
mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWD -A --skip-column-names -e"SELECT CONCAT(table_schema,'.',table_name) FROM information_schema.tables WHERE table_schema NOT IN ('information_schema','mysql')" > $BACKUP_DIR/ListOfTables.txt

for DBTB in `cat $BACKUP_DIR/ListOfTables.txt`; do
    DB=`echo ${DBTB} | sed 's/\./ /g' | awk '{print $1}'`
    TB=`echo ${DBTB} | sed 's/\./ /g' | awk '{print $2}'`
    mysqldump -h $DB_HOST -u $DB_USER -p$DB_PASSWD --hex-blob --triggers --no-data ${DB} ${TB} > $BACKUP_DIR/${DB}_${TB}.schema.sql
    mysqldump -h $DB_HOST -u $DB_USER -p$DB_PASSWD --hex-blob --triggers --no-create-info ${DB} ${TB} > $BACKUP_DIR/${DB}_${TB}.data.sql &
    (( COMMIT_COUNT++ ))
    if [ ${COMMIT_COUNT} -eq ${COMMIT_LIMIT} ]; then
        COMMIT_COUNT=0
        wait
    fi
done
if [ ${COMMIT_COUNT} -gt 0 ]; then
    wait
fi

```

## 還原 DB

當我們要還原資料庫時，基本只需要先還原 `結構`，再還原 `資料`。

{% note info %}
待續
{% endnote %}

# 參考資料

* [How can I speed up a MySQL restore from a dump file?](https://serverfault.com/questions/146525/how-can-i-speed-up-a-mysql-restore-from-a-dump-file)
