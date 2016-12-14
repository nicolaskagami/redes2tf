#!/bin/bash
#1st ARG: Duration
docker cp Measurement/meas.sh iperfClient:/
docker exec iperfClient /meas.sh $1
