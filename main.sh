#!/bin/sh
# Shell script to monitor or watch the disk space
# It will send an email to $ADMIN, if the available 
# amount of space used is <= 5G 
ADMIN="bao7@njit.edu"
# set alert level to 5 gb or less left
ALERT=5
df -H | grep -vE '^Filesystem|tmpfs|cdrom|/dev/loop*|udev' | awk '{ print $4 " " $1 }' | while read output;
do
  #echo $output
  avail=$(echo $output | awk '{ print $1}' | cut -d'G' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  
  if [ $avail -le $ALERT ]; then
    echo "Running out of space on \"$partition\" - less than $avail G left - on $(hostname) as of $(TZ=America/New_York date)" | 
     mail -s "WARNING: Storage Alert - Almost out of disk space" $ADMIN -aFrom:DoNotReply@BrianOrozco.com
  fi
done
