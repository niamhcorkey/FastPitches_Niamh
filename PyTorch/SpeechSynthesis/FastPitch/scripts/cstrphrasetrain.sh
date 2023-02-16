#!/usr/bin/env bash

. /etc/profile.d/modules.sh
export CUDA_HOME=/opt/cuda-10.2.89_440_33
source /disk/scratch1/s1936986/miniconda/bin/activate
source activate fastpitch_ellsworth

export CUDA_VISIBLE_DEVICES=2
set -euo pipefail

#JOB_NAME=$1
DS_HOME=/disk/scratch1/s1936986
FP=${DS_HOME}/FastPitches_Niamh/PyTorch/SpeechSynthesis/FastPitch

# metadata for wandb logging
export PROJECT=fastpitches_eddie
export EXPERIMENT_DESC="FastPitches defaults"

export OMP_NUM_THREADS=1

: ${NUM_GPUS:=1}
: ${BATCH_SIZE:=16}
: ${GRAD_ACCUMULATION:=1}
: ${OUTPUT_DIR:=${DS_HOME}/trained_models/slopescorrect}
: ${DATASET_PATH:=${DS_HOME}/LJ_Chopped/wavs}
: ${TRAIN_FILELIST:=${DS_HOME}/LJ_Chopped/3slopes_abs_chopped_train.txt}
: ${VAL_FILELIST:=${DS_HOME}/LJ_Chopped/3slopes_abs_chopped_val.txt}
: ${AMP:=false}
: ${SEED:=""}

: ${LEARNING_RATE:=0.1}

# Adjust these when the amount of data changes
: ${EPOCHS:=1000}
: ${EPOCHS_PER_CHECKPOINT:=50}
: ${WARMUP_STEPS:=1000}
: ${KL_LOSS_WARMUP:=100}

# Train a mixed phoneme/grapheme model
: ${PHONE:=true}
# Enable energy conditioning
: ${ENERGY:=true}
# Enable pitch conditioning
: ${PITCH:=true}
# Enable coefficient conditioning
: ${COEFFICIENTS:=true}


: ${TEXT_CLEANERS:=english_cleaners_v2}
# Add dummy space prefix/suffix is audio is not precisely trimmed
: ${APPEND_SPACES:=false}

: ${LOAD_PITCH_FROM_DISK:=true}
: ${LOAD_MEL_FROM_DISK:=true}

# For multispeaker models, add speaker ID = {0, 1, ...} as the last filelist column
: ${NSPEAKERS:=1}
: ${NCOEFFICIENTS:=3}
: ${SAMPLING_RATE:=22050}

# Adjust env variables to maintain the global batch size: NUM_GPUS x BATCH_SIZE x GRAD_ACCUMULATION = 256.
GBS=$(($NUM_GPUS * $BATCH_SIZE * $GRAD_ACCUMULATION))
[ $GBS -ne 256 ] && echo -e "\nWARNING: Global batch size changed from 256 to ${GBS}."
echo -e "\nAMP=$AMP, ${NUM_GPUS}x${BATCH_SIZE}x${GRAD_ACCUMULATION}" \
        "(global batch size ${GBS})\n"

ARGS=""
ARGS+=" --cuda"
ARGS+=" -o $OUTPUT_DIR"
ARGS+=" --dataset-path $DATASET_PATH"
ARGS+=" --training-files $TRAIN_FILELIST"
ARGS+=" --validation-files $VAL_FILELIST"
ARGS+=" -bs $BATCH_SIZE"
ARGS+=" --grad-accumulation $GRAD_ACCUMULATION"
ARGS+=" --optimizer lamb"
ARGS+=" --epochs $EPOCHS"
ARGS+=" --epochs-per-checkpoint $EPOCHS_PER_CHECKPOINT"
ARGS+=" --resume"
ARGS+=" --warmup-steps $WARMUP_STEPS"
ARGS+=" -lr $LEARNING_RATE"
ARGS+=" --weight-decay 1e-6"
ARGS+=" --grad-clip-thresh 1000.0"
ARGS+=" --dur-predictor-loss-scale 0.1"
ARGS+=" --pitch-predictor-loss-scale 0.1"

# Autoalign & new features
ARGS+=" --kl-loss-start-epoch 0"
ARGS+=" --kl-loss-warmup-epochs $KL_LOSS_WARMUP"
ARGS+=" --text-cleaners $TEXT_CLEANERS"
ARGS+=" --n-speakers $NSPEAKERS"
ARGS+=" --n-coefficients $NCOEFFICIENTS"

[ "$PROJECT" != "" ]               && ARGS+=" --project \"${PROJECT}\""
[ "$EXPERIMENT_DESC" != "" ]       && ARGS+=" --experiment-desc \"${EXPERIMENT_DESC}\""
[ "$AMP" = "true" ]                && ARGS+=" --amp"
[ "$PHONE" = "true" ]              && ARGS+=" --p-arpabet 1.0"
[ "$PITCH" = "true" ]              && ARGS+=" --pitch-conditioning"
[ "$ENERGY" = "true" ]             && ARGS+=" --energy-conditioning"
[ "$COEFFICIENTS" = "true" ]       && ARGS+=" --coefficient-utt-conditioning"
[ "$SEED" != "" ]                  && ARGS+=" --seed $SEED"
[ "$LOAD_MEL_FROM_DISK" = true ]   && ARGS+=" --load-mel-from-disk"
[ "$LOAD_PITCH_FROM_DISK" = true ] && ARGS+=" --load-pitch-from-disk"
#[ "$PITCH_ONLINE_DIR" != "pitch" ]      && ARGS+=" --pitch-online-dir $PITCH_ONLINE_DIR"  # e.g., /dev/shm/pitch
#[ "$PITCH_ONLINE_METHOD" != "" ]   && ARGS+=" --pitch-online-method $PITCH_ONLINE_METHOD"
[ "$APPEND_SPACES" = true ]        && ARGS+=" --prepend-space-to-text"
[ "$APPEND_SPACES" = true ]        && ARGS+=" --append-space-to-text"

if [ "$SAMPLING_RATE" == "44100" ]; then
  ARGS+=" --sampling-rate 44100"
  ARGS+=" --filter-length 2048"
  ARGS+=" --hop-length 512"
  ARGS+=" --win-length 2048"
  ARGS+=" --mel-fmin 0.0"
  ARGS+=" --mel-fmax 22050.0"

elif [ "$SAMPLING_RATE" != "22050" ]; then
  echo "Unknown sampling rate $SAMPLING_RATE"
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

#: ${DISTRIBUTED:="-m torch.distributed.launch --nproc_per_node $NUM_GPUS"}
#python3.8 $DISTRIBUTED train.py $ARGS "$@"
python3.8 train.py $ARGS "$@"