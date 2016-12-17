container_name="click"
docker cp $1 $container_name:/root/$(basename $1)
docker exec -d $container_name pkill -9 click
docker exec -d $container_name /click /root/$(basename $1) 2>/dev/null  &
