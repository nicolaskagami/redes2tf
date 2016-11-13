#docker exec -d mn.$1 sudo dd if=/dev/zero of=/dev/null &
docker exec -d mn.$1 sudo stress --cpu 1 &
