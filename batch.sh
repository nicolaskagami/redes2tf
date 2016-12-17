#!/bin/bash
DURATION=30
ISOLATION_NUM=4
VNF_NUM=3
ANOMALY_NUM=5
INTERFACE_NUM=3
ITERATIONS=5

ISOLATION=0
while [ $ISOLATION -lt $ISOLATION_NUM ]
do
    INTERFACE=0
    while [ $INTERFACE -lt $INTERFACE_NUM ]
    do
        ./SetupContainers.sh $ISOLATION 
        ./SetupClientConnection.sh $INTERFACE
        VNF=0
        while [ $VNF -lt $VNF_NUM ]
        do
            ./SetupVNF.sh $VNF
            ANOMALY=0
            while [ $ANOMALY -lt $ANOMALY_NUM ]
            do
                i=0
                while [ $i -lt $ITERATIONS ]
                do
                    ./Anomaly.sh $ANOMALY $ISOLATION $DURATION
                    RESULT_LINE=$(./Measurement.sh $DURATION)
                    echo $ISOLATION $INTERFACE $VNF $ANOMALY $RESULT_LINE >> Results.txt
                    let i=i+1
                done
                let ANOMALY=ANOMALY+1
            done
            let VNF=VNF+1
        done
        let INTERFACE=INTERFACE+1 
    done
    let ISOLATION=ISOLATION+1
done
