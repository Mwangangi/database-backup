#!/bin/bash

# MYSQL SERVER DETAILS
MYSQL_HOST="localhost"
MYSQL_PORT="3306"
MYSQL_USER="your_db_user"
MYSQL_PASS='your_password'

# THE LOCAL BACKUP DIRECTORY
LOCAL_BACKUP_DIR="/backup/mysql"

# DATABASE NAME TO BACKUP
DB_NAME="mydata"

# TO ALLOW REMOTE BACKUP VIA FTP, 1 = enable, 0 = disable
FTP_ENABLE=1
FTP_SERVER="ftp_server_ip/location"
FTP_USERNAME="ftp_user"
FTP_PASSWORD="ftp_password"
FTP_UPLOAD_DIR="path/to/upload"

# LOCATION OF mysqldump executable
MYSQLDUMP="/usr/bin/mysqldump"

TIME_FORMAT='%d%m%Y-%H%M'
cTime=$(date +"${TIME_FORMAT}")

db_backup(){
        
        mkdir -p ${LOCAL_BACKUP_DIR}/${cTime}

        FILE_NAME="${DB_NAME}.${cTime}.sql"
        FILE_PATH="${LOCAL_BACKUP_DIR}/${cTime}/"
        FILENAMEPATH="$FILE_PATH$FILE_NAME"
        ${MYSQLDUMP} -u ${MYSQL_USER} -p${MYSQL_PASS} -h ${MYSQL_HOST} -P $MYSQL_PORT $DB_NAME> $FILENAMEPATH

        [ $FTP_ENABLE -eq 1 ] && ftp_backup        
}

ftp_backup(){

ftp -n $FTP_SERVER << EndFTP
quote USER $FTP_USERNAME
quote PASS $FTP_PASSWORD
cd $FTP_UPLOAD_DIR
lcd $FILE_PATH
put "$FILE_NAME"
bye
EndFTP
}

# let's do this!!
db_backup
