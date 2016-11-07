killall mn
killall chrome
killall simple
mn -c
bash ~/containernet/bin/clear_crash.sh
docker rm $(docker ps -q -f status=exited)
