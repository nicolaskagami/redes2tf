#!/bin/bash
cd Plugo
python simple_web_server.py &
plugoserverPid=$!
#su -c "google-chrome --user-data-dir=/home/ubuntu/redestf/Plugo/$1 --new-window $2/VideoPlayer/video.html?uuid=$1" - ubuntu &
su -c "xvfb-run -a google-chrome --user-data-dir=/home/ubuntu/redestf/Plugo/$1 --new-window $2/VideoPlayer/video.html?uuid=$1" - ubuntu &
chromePid=$!
sleep 60 
pgrep -lf "uuid=$1" | grep 'chrome' | awk '{print $1}' 
pgrep -lf "uuid=$1" | grep 'chrome' | awk '{print $1}' | xargs kill -2
sleep 1
pgrep -lf "uuid=$1" | grep 'chrome' | awk '{print $1}' | xargs kill -2
#pgrep -lf "uuid=$1" | grep 'chrome' | awk '{print $1}' | xargs kill -2
sleep 1
echo $plugoserverPid
kill -9 $plugoserverPid
