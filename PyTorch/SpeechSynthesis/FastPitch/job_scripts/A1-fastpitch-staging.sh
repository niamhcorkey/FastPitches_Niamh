#!/bin/sh
#$ -q staging
#$ -N fastpitch_staging
#$ -l h_rt=01:00:00
#$ -o /exports/chss/eddie/ppls/groups/lel_hcrc_cstr_students/s1936986_Niamh_Corkey/job_logs/$JOB_NAME_$JOB_ID.stdout
#$ -e /exports/chss/eddie/ppls/groups/lel_hcrc_cstr_students/s1936986_Niamh_Corkey/job_logs/$JOB_NAME_$JOB_ID.stderr
#$ -M s1936986@ed.ac.uk
#$ -m beas

source /etc/profile.d/modules.sh

module load anaconda
source activate fastpitchnew

# can only set these after conda setup
set -euo pipefail

UUN=s1936986
YOUR_NAME=Niamh_Corkey

DS_HOME=/exports/chss/eddie/ppls/groups/lel_hcrc_cstr_students/${UUN}_${YOUR_NAME}
FP=$DS_HOME/FastPitches_Niamh/PyTorch/SpeechSynthesis/FastPitch

cd $FP
bash scripts/download_dataset.sh
