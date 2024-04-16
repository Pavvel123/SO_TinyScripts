#!/bin/bash
#cat cdlinux.ftp.log | grep "OK" |cut -d '"' -f 2,4 | sort | uniq | cut -d '"' -f 2 | sed "s#.*/##" | sort | uniq -c | sort -rn
cat cdlinux.www.log | grep " 200 " | grep "GET" | cut -d '"' -f 1,2 | cut -d ':' -f 2,3,4,5 | sed "s/]/[/g" | cut -d '[' -f 1,3 | sort | uniq | cut -d '[' -f 2 | cut -d ' ' -f 3 | sed "s#.*/##" | sort | uniq -c | sort -rn