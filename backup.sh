#!/bin/bash
###################################################################
## Crypto Wallet Backup Script                                   ##
## sanchaz                                                       ##
##                                                               ##
## Donations                                                     ##
## BTC: 188Jw9v7K4S8k33EsQWb1D7xdt4JDqhNY1                       ##
## LTC: LNKrdfM5ABzjZPusbLgLDzhLZF1JMrfZdz                       ##
###################################################################
## Config. change these values to fit your configuration         ##
###################################################################
#Use this script to routinely backup your wallets to different media
#add cronjob (sudo if you leave the logs in /var/log/)
#sudo crontab -e
#add the following in a newline: (make changes where needed)
#0 20 * * * /home/username/.backup.sh >> /var/log/cryptocurrency/cron_job.log
#This will make it run every night at 20:00
#Use full absolute paths
#add values into the array separated by spaces eg. $destination=("/media/disk1" "/media/usbpen/");
#Ensure that these already exist
destination=("/home/username");
walletDir="/home/username/.cryptocurrency/"; #change if needed (.bitcoin for bitcoin, .litecoin for litecoin or anything else)
walletFile="wallet.dat"; #change if needed

logDir="/var/log/cryptocurrency/"; #change if needed
logFileName="backup.log";

#####################################################################
## do not change anything below unless you know what you are doing ##
#####################################################################
date=$(date +%T-%d-%m-%Y);
logFile="$logDir/$date.$logFileName";
currentLogFile="$logDir/$logFileName";
count=0;
#checklog
echo "$logFile";
if ! [ -d "$logDir" ]
then
	mkdir -p "$logDir";
fi

echo "$(date +%T-%d-%m-%Y) Wallet backup started" >> "$logFile";

if [ -d "$walletDir" ]
then
	for i in "${destination[@]}"
	do
		if [ -d $i ]
		then
			mkdir -p "$i/$date";
			cp "$walletDir/$walletFile" "$i/$date/";
			echo "$(date +%T-%d-%m-%Y) Copied $walletFile to $i/$date/" >> "$logFile";
			count=$((count+1));
		else
			echo "$(date +%T-%d-%m-%Y) $i is not available. skipping..." >> "$logFile";
		fi
	done
else
	echo "wallet directory or wallet file name incorrectly set" >> "$logFile";
fi

echo "$(date +%T-%d-%m-%Y) Copied $walletFile to $count of ${#destination[@]} specified destinations" >> "$logFile";

if [ "$count" == "${#destination[@]}" ]
then
	echo "$(date +%T-%d-%m-%Y) Wallet backup completed sucessfuly" >> "$logFile";
elif [ "$count" == 0 ]
then
	echo "$(date +%T-%d-%m-%Y) Wallet backup failed" >> "$logFile";
else
	echo "$(date +%T-%d-%m-%Y) Wallet backup completed with errors" >> "$logFile";
fi

cp "$logFile" "$currentLogFile";
gzip "$logFile";
