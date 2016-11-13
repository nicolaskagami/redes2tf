#!/bin/bash
#iperf -u -c 10.0.0.2 -b 8589934592 > Results/ha
RESULTS=$(iperf -u -c 10.0.0.2 -b 8589934592  -t 10 | grep "Server Report" -A1 | tail -n 1 | sed -n -e 's/^.*Bytes //p') 
BW=$(echo $RESULTS | cut -d ' ' -f1-2)
JITTER=$(echo $RESULTS | cut -d ' ' -f3-4)
PING=$(ping -c 10 10.0.0.2 -q | tail -n 1 | cut -d '=' -f2 | cut -d ' ' -f2)
echo "$BW $JITTER $PING"
