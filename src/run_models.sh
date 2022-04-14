#!/bin/bash

EPOCH=$1

if [ -z "$EPOCH" ]
then 
    echo "Please provide a number for epoch like: ./run_models.sh 50"
    exit 1
fi

re='^[0-9]+$'
if ! [[ $EPOCH =~ $re ]]; then
    echo "Error: epoch should be an integer"
    exit 1
fi

# LR
python LR.py

# ECC
python ECC.py

#---------------------

# RETAIN
python Retain.py --epoch=$EPOCH

# LEAP
python Leap.py --epoch=$EPOCH

# DMNC
python DMNC.py

# GAMENet
python GAMENet.py --epoch=$EPOCH

#---------------------

# SafeDrug
python SafeDrug.py --epoch=$EPOCH
