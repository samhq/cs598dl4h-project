#!/bin/bash

# RXCUI2atc4.csv
wget https://github.com/ycq091044/SafeDrug/raw/main/data/input/RXCUI2atc4.csv

# drug-atc.csv
wget https://github.com/ycq091044/SafeDrug/raw/main/data/input/drug-atc.csv

# rxnorm2RXCUI.txt
wget https://github.com/ycq091044/SafeDrug/raw/main/data/input/rxnorm2RXCUI.txt

# drugbank_drugs_info.csv
wget https://www.dropbox.com/s/angoirabxurjljh/drugbank_drugs_info.csv?dl=0 -O drugbank_drugs_info.csv

# drug-DDI.csv
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1mnPc0O0ztz0fkv3HF-dpmBb8PLWsEoDz' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1mnPc0O0ztz0fkv3HF-dpmBb8PLWsEoDz" -O drug-DDI.csv && rm -rf /tmp/cookies.txt
