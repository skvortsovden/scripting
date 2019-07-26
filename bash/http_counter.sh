#!/bin/bash
## Count http request based on nginx access log
## for telegraf as input script 

metric_name="http_req"
log_file="/var/log/nginx/access.log"
LANG=en_us_88591 # for English month in date
date_format="+%d\/%b\/%Y:%H:%M" # Example 25/Jul/2018:04:05
date_now=$(date $date_format)
date_start=$(date $date_format --date='10 minutes ago') # N minutes from now
if [ -s $log_file ]
then
	counter=5
	date_start=$(date $date_format --date="$counter minutes ago")
	while [ $counter -gt 0 ]
	do
		if grep "$date_start" $log_file > /dev/null
		then
			content=$(sed -n -e "/$date_start/,\$ p" $log_file) ## awk '{a="ip="$1; print a}')  Sed from date_start to end of file
			break
		else
			((counter=$counter-1))
			date_start=$(date $date_format --date="$counter minutes ago")
		fi
	done
	s200=$(echo "$content" | cut -d " " -f9 | grep 200 | wc -l)
	s304=$(echo "$content" | cut -d " " -f9 | grep 304 | wc -l)
	s404=$(echo "$content" | cut -d " " -f9 | grep 404 | wc -l)
	s500=$(echo "$content" | cut -d " " -f9 | grep 500 | wc -l)
	echo "$metric_name,tag1=a,tag2=b status_200=${s200},status_304=${s304},status_404=${s404},status_500=${s500}"
else
	echo "Empty log file"
fi

