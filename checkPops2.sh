CONTAINER_ID=$(docker ps --no-trunc | tail -n 1 | awk '{print $1}')
echo $CONTAINER_ID
echo -ne "GET /containers/$CONTAINER_ID/stats HTTP/1.1\r\n\r\n" | sudo nc -U /var/run/docker.sock
