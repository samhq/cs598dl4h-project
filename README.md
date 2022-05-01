# Reproducing `SafeDrug` For CS598: Deep Learning for Healthcare (Spring '22)

## Paper and Group Details

- Paper
  - ID: 208
  - Chaoqi Yang, Cao Xiao, Fenglong Ma, Lucas Glass, and Jimeng Sun. 2021. **SafeDrug: Dual Molecular Graph Encoders for Recommending Effective and Safe Drug Combinations.** In *Proceedings of the Thirtieth International Joint Conference on Artificial Intelligence* (*IJCAI-21*). International Joint Conferences on Artificial Intelligence Organization, 3735-3741. DOI: https://doi.org/10.24963/ijcai.2021/514
  - Original Code Repository: https://github.com/ycq091044/SafeDrug
- Group
  - ID: 24
  - Members:
    - Anushree Dhople (adhople2@illinois.edu)
    - Gazi Muhammad Samiul Hoque (ghoque2@illinois.edu)

## Project Structure
- `data/`
  - `processing.py`: The data preprocessing file.
  - `input/`
    - `PRESCRIPTIONS.csv`: the prescription file from MIMIC-III raw dataset
    - `DIAGNOSES_ICD.csv`: the diagnosis file from MIMIC-III raw dataset
    - `PROCEDURES_ICD.csv`: the procedure file from MIMIC-III raw dataset
    - `RXCUI2atc4.csv`: this is a NDC-RXCUI-ATC4 mapping file, and we only need the RXCUI to ATC4 mapping. This file is obtained from https://github.com/ycq091044/SafeDrug.
    - `drug-atc.csv`: this is a CID-ATC file, which gives the mapping from CID code to detailed ATC code (we will use the prefix of the ATC code latter for aggregation). This file is obtained from https://github.com/ycq091044/SafeDrug.
    - `rxnorm2RXCUI.txt`: rxnorm to RXCUI mapping file. This file is obtained from https://github.com/ycq091044/SafeDrug.
    - `drugbank_drugs_info.csv`: drug information table downloaded from drugbank here https://www.dropbox.com/s/angoirabxurjljh/drugbank_drugs_info.csv?dl=0, which is used to map drug name to drug SMILES string.
    - `drug-DDI.csv`: this a large file, containing the drug DDI information, coded by CID. The file could be downloaded from https://drive.google.com/file/d/1mnPc0O0ztz0fkv3HF-dpmBb8PLWsEoDz/view?usp=sharing
  - `output/`
    - `atc3toSMILES.pkl`: drug ID (we use ATC-3 level code to represent drug ID) to drug SMILES string dict
    - `ddi_A_final.pkl`: ddi adjacency matrix
    - `ddi_matrix_H.pkl`: H mask structure (This file is created by **ddi_mask_H.py**)
    - `ehr_adj_final.pkl`: used in GAMENet baseline (if two drugs appear in one set, then they are connected)
    - `records_final.pkl`: The final diagnosis-procedure-medication EHR records of each patient, used for train/val/test split.
    - `voc_final.pkl`: diag/prod/med index to code dictionary
- `src/`
  - `SafeDrug.py`: our model
  - baseline models:
    - `GAMENet.py`
    - `DMNC.py`
    - `Leap.py`
    - `Retain.py`
    - `ECC.py`
    - `LR.py`
  - setting file
    - `model.py`
    - `util.py`
    - `layer.py`
  - analysis file
    - `Result-Analysis.ipynb`
- `dependency.sh`
- `requirements.txt`
- `README.md`

After the processing have been done, we get the following statistics:

```bash
# patients  6350
# clinical events  15032
# diagnosis  1958
# med  112
# procedure 1430
# avg of diagnoses  10.5089143161256
# avg of medicines  11.647751463544438
# avg of procedures  3.8436668440659925
# avg of vists  2.367244094488189
# max of diagnoses  128
# max of medicines  64
# max of procedures  50
# max of visit  29
```

## Execution

### Step 1: Environment Setup

- First, install the [`rdkit`](https://www.rdkit.org/) (RDKit: Open-Source Cheminformatics Software) conda environment

  ```bash
  conda create -c conda-forge -n SafeDrug rdkit
  conda activate SafeDrug
  ```

- In `SafeDrug` environment, run the following commands to install required python packages (according to your GPU support)

  ```bash
  # if you don't have GPU
  ./dependency.sh

  # if you have GPU
  ./dependency.sh 1
  ```

### Step 2: Obtaining Data and Processing

- Clone this repository in your preferred location. We assume that you clone it in your home directory.
  
  ```bash
  cd ~
  git clone git@github.com:samhq/cs598dl4h-project.git 
  ```

- Go to https://physionet.org/content/mimiciii/1.4/ to download the MIMIC-III dataset (You may need to get the certificate)

  ```bash
  wget -r -N -c -np --user [account] --ask-password https://physionet.org/files/mimiciii/1.4/
  ```

- Go into the folder and unzip required three files and copy them to the `~/cs598dl4h-project/data/input/` folder

  ```bash
  cd ~/physionet.org/files/mimiciii/1.4
  gzip -d PROCEDURES_ICD.csv.gz # procedure information
  gzip -d PRESCRIPTIONS.csv.gz  # prescription information
  gzip -d DIAGNOSES_ICD.csv.gz  # diagnosis information
  cp PROCEDURES_ICD.csv PRESCRIPTIONS.csv DIAGNOSES_ICD.csv ~/cs598dl4h-project/data/input/
  ```

- Download additional files in the `~/cs598dl4h-project/data/input/` folder
  
  ```bash
  cd ~/cs598dl4h-project/data/input/
  ./get_additional_files.sh
  ```

- Processing the data to get a complete `records_final.pkl`

  ```bash
  cd ~/cs598dl4h-project/data
  python processing.py
  ```

### Step 3: Run Model(s)

To run the `SafeDrug` model, run the following:

```bash
cd ~/cs598dl4h-project/src
python SafeDrug.py
```

here is the argument:

    usage: SafeDrug.py [-h] [--Test] [--model_name=MODEL_NAME]
                   [--resume_path=RESUME_PATH] [--lr=LR]
                   [--target_ddi=TARGET_DDI] [--kp=KP] [--dim=DIM]
                   [--epoch=EPOCH]
    
    optional arguments:
      -h, --help                  show this help message and exit
      --Test                      test mode
      --model_name MODEL_NAME     model name
      --resume_path RESUME_PATH   resume path
      --lr LR                     learning rate
      --target_ddi TARGET_DDI     target ddi
      --kp KP                     coefficient of P signal
      --dim DIM                   dimension
      --epoch EPOCH               how many epoch

If you want to run all models consecutively, then run:

```bash
cd ~/cs598dl4h-project/src
./run_models.sh
```

### Step 4: Analysis of the results

Please check the Jupyter Notebook [here](./src/Result-Analysis.ipynb).

## Credits

Our work followed the original codes at https://github.com/ycq091044/SafeDrug.
