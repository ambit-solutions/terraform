#!/bin/bash
nohup busybox httpd -f -h /home/ubuntu -p 8080 > nohup.out 2> nohup.err &
netstat -an | grep 8080
ps -ef | grep http
