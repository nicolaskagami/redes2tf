#!/bin/bash
#Setup Isolation: SELinux or APParmor
ISOLATION_FILE=.isolation_file
DURATION=30
ISOLATION_NUM=4
VIRTECH_NUM=1
VNF_NUM=3
ANOMALY_NUM=5
INTERFACE_NUM=4
ITERATIONS=1
if [ -f $ISOLATION_FILE ]
then
    ISOLATION=$(cat $ISOLATION_FILE)
else
    ISOLATION=0
fi
while [ $ISOLATION -lt $ISOLATION_NUM ]
do
    ./SetupIsolation.sh  $ISOLATION
    VIRTECH=0
    while [ $VIRTECH -lt $VIRTECH_NUM ]
    do
        VNF=0
        while [ $VNF -lt $VNF_NUM ]
        do
            ./SetupContainers.sh $ISOLATION $VIRTECH $VNF
            INTERFACE=0
            while [ $INTERFACE -lt $INTERFACE_NUM ]
            do
                ./SetupClientConnection.sh $VNF $INTERFACE
                ANOMALY=0
                while [ $ANOMALY -lt $ANOMALY_NUM ]
                do
                    i=0
                    while [ $i -lt $ITERATIONS ]
                    do
                        ./Measurement.sh $DURATION
                        sleep 1
                        ./Anomaly.sh $ANOMALY
                        let i=i+1
                    done
                    let ANOMALY=ANOMALY+1
                done
                let INTERFACE=INTERFACE+1 
            done
            let VNF=VNF+1
        done
        let VIRTECH=VIRTECH+1
    done
    let ISOLATION=ISOLATION+1
done
