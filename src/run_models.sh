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

final_start_time="$(date -u +%s)"

# LR
echo "-------------------------  LR  -------------------------------"
start_time="$(date -u +%s)"
python LR.py
end_time="$(date -u +%s)"
lr_time="$(($end_time-$start_time))"
echo "-----------------------  LR END ------------------------------"

# ECC
echo "-------------------------  ECC  ------------------------------"
start_time="$(date -u +%s)"
python ECC.py
end_time="$(date -u +%s)"
ecc_time="$(($end_time-$start_time))"
echo "-----------------------  ECC END -----------------------------"

#---------------------

# RETAIN
echo "-----------------------  RETAIN ------------------------------"
start_time="$(date -u +%s)"
python Retain.py --epoch=$EPOCH
end_time="$(date -u +%s)"
retain_time="$(($end_time-$start_time))"
echo "---------------------  RETAIN END ----------------------------"

# LEAP
echo "------------------------  LEAP -------------------------------"
start_time="$(date -u +%s)"
python Leap.py --epoch=$EPOCH
end_time="$(date -u +%s)"
leap_time="$(($end_time-$start_time))"
echo "----------------------  LEAP END -----------------------------"

# DMNC
echo "------------------------  DMNC -------------------------------"
start_time="$(date -u +%s)"
python DMNC.py
end_time="$(date -u +%s)"
dmnc_time="$(($end_time-$start_time))"
echo "----------------------  DMNC END -----------------------------"

# GAMENet
echo "----------------------- GAMENet ------------------------------"
start_time="$(date -u +%s)"
python GAMENet.py --epoch=$EPOCH
end_time="$(date -u +%s)"
gamenet_time="$(($end_time-$start_time))"
echo "--------------------- GAMENet END ----------------------------"

#---------------------

# SafeDrug
echo "----------------------  SafeDrug -----------------------------"
start_time="$(date -u +%s)"
python SafeDrug.py --epoch=$EPOCH
end_time="$(date -u +%s)"
safedrug_time="$(($end_time-$start_time))"
echo "--------------------  SafeDrug END ---------------------------"

final_end_time="$(date -u +%s)"

elapsed="$(($final_end_time-$final_start_time))"

convertsecs() {
 ((h=${1}/3600))
 ((m=(${1}%3600)/60))
 ((s=${1}%60))
 printf "%02d:%02d:%02d\n" $h $m $s
}

echo "-----------------------  SUMMARY  ----------------------------"
echo "> LR execution time           :     $lr_time seconds"
echo "> ECC execution time          :     $ecc_time seconds"
echo "> RETAIN execution time       :     $retain_time seconds"
echo "> LEAP execution time         :     $leap_time seconds"
echo "> DMNC execution time         :     $dmnc_time seconds"
echo "> GAMENet execution time      :     $gamenet_time seconds"
echo "> SafeDrug execution time     :     $safedrug_time seconds"
echo "> TOTAL TIME                  :     $elapsed SECONDS"
echo "                                    [$(convertsecs $elapsed)]"
echo "---------------------  SUMMARY END  --------------------------"
