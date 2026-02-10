#!/bin/bash


# check if rsync is installed
if ! command -v rsync > /dev/null 2>&1
then
    echo "this script requires rsync to be installed."
    echo "please use your distributions package manager to install it and try again"
    exit 1
fi

# using dirname to use the directory where the script currently is
script_dir=$(dirname "$0") 

# env file to store enviroment variables for the script to use
source $script_dir/backup.env

# capture the current date, and store it in the format yyy-mm-dd
current_date=$(date +%Y-%m-%d)

# CREATE DIRECTORY ON PI FIRST
ssh $PI_USER@$PI_HOST "mkdir -p '$PI_PATH/BackUp-files'"

# it deletes files in target directory that no longer exits in source directory and adds the current date
rsync_options="-avb --backup-dir $current_date --delete"

# it removes the source file from the source directory after transfer
rsync_transfer="-av --remove-source-files"


# use the rsync options to send from source directory to target directory under a folder name backup-files and it creates a log. 
# and then the log is store in the HOME directory
$(which rsync) $rsync_options "$1" $PI_USER@$PI_HOST:"$PI_PATH"/BackUp-files >> /$HOME/backup_$current_date.log

# then rsync_transfer transfers that log file to the pi server as well under another file called backup_current_date.log 
$(which rsync) $rsync_transfer /$HOME/backup_$current_date.log $PI_USER@$PI_HOST:"$PI_PATH"/BackUp-files/backup_$current_date.log 


echo "Backup completed successfully on $current_date"
echo "Source directory: $1"
echo "Target: $PI_USER@$PI_HOST:$PI_PATH/BackUp-files"
echo "Log file: backup_$current_date.log"
