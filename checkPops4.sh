#!/bin/bash
THISPID=`ps -eo pid,comm | grep $1 | awk '{print $1}'`
cat /proc/$THISPID/cgroup
