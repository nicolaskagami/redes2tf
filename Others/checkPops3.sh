CONTAINER_ID=$(docker ps --no-trunc | tail -n 1 | awk '{print $1}')
echo $CONTAINER_ID
sudo cgset -r cpu.cfs_quota_us=100 /docker/$CONTAINER_ID
sudo cgset -r cpu.cfs_period_us=50000 /docker/$CONTAINER_ID
