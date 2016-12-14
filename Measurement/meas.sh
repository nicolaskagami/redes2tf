#!/bin/bash
#1st ARG: Duration
SERVER_IP="172.16.0.1"
TEST_DURATION=$1
LATENCY_TEST_DURATION=$(bc <<< "scale=0;($1/2) - 2")
PING_COUNT=$(bc <<< "scale=0;$LATENCY_TEST_DURATION*5")
BW_TEST_DURATION=$(bc <<< "scale=0;($1/2) ")
echo $(ping -i 0.2 -c $LATENCY_TEST_DURATION $SERVER_IP -q | tail -n 1 | cut -d '=' -f2 | cut -d ' ' -f2) > .ping &
PING_PID=$!
RESULTS=$(iperf3 -u -c $SERVER_IP -t $LATENCY_TEST_DURATION -b 50M -i 0 --format='m'  | grep "Interval" -A1 | tail -n 1 | sed -n -e 's/^.*Bytes //p') 
JITTER=$(echo $RESULTS | cut -d ' ' -f3)
sleep 2 
RESULTS=$(iperf3 -c $SERVER_IP -R -t $BW_TEST_DURATION -i 0 --format='m'  | grep "Interval" -A2 | tail -n 1 | sed -n -e 's/^.*Bytes //p') 
BW=$(echo $RESULTS | cut -d ' ' -f1)
wait $PING_PID
PING=$(cat .ping)
AVG_PING=$(echo $PING | cut -d '/' -f2)
MAX_PING=$(echo $PING | cut -d '/' -f3)
echo "$BW $JITTER $AVG_PING $MAX_PING"
