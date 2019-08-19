#!/bin/bash -v
logfile=/tmp/user_data.out
exec >> $logfile 2>&1
echo "Hello, World" > /tmp/index.html 
nohup busybox httpd -f -h /tmp -p 8080 &
