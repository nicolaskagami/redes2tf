#!/bin/bash
#$4 is Test Duration
TEST_DURATION=$4
LATENCY_TEST_DURATION=$(bc <<< "scale=0;($4/2) - 2")
BW_TEST_DURATION=$(bc <<< "scale=0;($4/2) ")
#iperf -u -c 10.0.0.2 -b 8589934592 > Results/ha
#RESULTS=$(iperf -c 10.0.0.2 -t 15 | grep "Server Report" -A1 | tail -n 1 | sed -n -e 's/^.*Bytes //p') 
echo $(ping -c $LATENCY_TEST_DURATION 10.0.0.2 -q | tail -n 1 | cut -d '=' -f2 | cut -d ' ' -f2) > .ping &
PING_PID=$!
RESULTS=$(iperf3 -u -c 10.0.0.2 -t $LATENCY_TEST_DURATION -b 50M -i 0 --format='m'  | grep "Interval" -A1 | tail -n 1 | sed -n -e 's/^.*Bytes //p') 
JITTER=$(echo $RESULTS | cut -d ' ' -f3)
sleep 2 
RESULTS=$(iperf3 -c 10.0.0.2 -t $BW_TEST_DURATION -i 0 --format='m'  | grep "Interval" -A2 | tail -n 1 | sed -n -e 's/^.*Bytes //p') 
BW=$(echo $RESULTS | cut -d ' ' -f1)
wait $PING_PID
PING=$(cat .ping)
AVG_PING=$(echo $PING | cut -d '/' -f2)
MAX_PING=$(echo $PING | cut -d '/' -f3)
echo "$1 $2 $3 $BW $JITTER $AVG_PING $MAX_PING"
