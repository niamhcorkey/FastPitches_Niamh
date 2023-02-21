#!/usr/bin/env bash

. /etc/profile.d/modules.sh
export CUDA_HOME=/opt/cuda-10.2.89_440_33
source /disk/scratch1/s1936986/miniconda/bin/activate
source activate fastpitch_ellsworth
export CUDA_LAUNCH_BLOCKING=1
export CUDA_VISIBLE_DEVICES=3
set -euo pipefail

DS_HOME=/disk/scratch1/s1936986
FP=${DS_HOME}/FastPitches_Niamh/PyTorch/SpeechSynthesis/FastPitch

MODEL=slopescorrect
CHECKPOINT=FastPitch_checkpoint_900.pt

NAME=continuum

: ${WAVEGLOW:="pretrained_models/waveglow/nvidia_waveglow256pyt_fp16.pt"}
: ${FASTPITCH:="$DS_HOME/trained_models/$MODEL/$CHECKPOINT"}
: ${BATCH_SIZE:=16}
: ${PHRASES:="phrases/slopes_continuum.tsv"}
: ${OUTPUT_DIR:="$DS_HOME/fastpitch_audio/slopescontrollabilitytest/$(basename $NAME .tsv)"}
: ${LOG_FILE:="$OUTPUT_DIR/nvlog_infer.json"}
: ${AMP:=false}
: ${TORCHSCRIPT:=false}
: ${PHONE:=true}
: ${DENOISING:=0.01}
: ${WARMUP:=0}
: ${REPEATS:=1}
: ${CPU:=false}

# Enable energy conditioning
: ${ENERGY:=true}
# Enable pitch conditioning
: ${PITCH:=true}
# Enable coefficient conditioning
: ${COEFFICIENTS:=true}
# Load in coefficient targets
: ${USE_COEF_TARGET:=true}



: ${SPEAKER:=0}
: ${NUM_SPEAKERS:=1}

echo -e "\nAMP=$AMP, batch_size=$BATCH_SIZE\n"

ARGS=""
ARGS+=" -i $PHRASES"
ARGS+=" -o $OUTPUT_DIR"
ARGS+=" --log-file $LOG_FILE"
ARGS+=" --fastpitch $FASTPITCH"
ARGS+=" --waveglow $WAVEGLOW"
ARGS+=" --wn-channels 256"
ARGS+=" --batch-size $BATCH_SIZE"
ARGS+=" --denoising-strength $DENOISING"
ARGS+=" --repeats $REPEATS"
ARGS+=" --warmup-steps $WARMUP"
ARGS+=" --speaker $SPEAKER"
ARGS+=" --n-speakers $NUM_SPEAKERS"

[ "$CPU" = false ]          && ARGS+=" --cuda"
[ "$CPU" = false ]          && ARGS+=" --cudnn-benchmark"
[ "$AMP" = true ]           && ARGS+=" --amp"
[ "$PHONE" = "true" ]       && ARGS+=" --p-arpabet 1.0"
[ "$PITCH" = "true" ]       && ARGS+=" --pitch-conditioning"
[ "$ENERGY" = "true" ]      && ARGS+=" --energy-conditioning"
[ "$COEFFICIENTS" = "true" ]       && ARGS+=" --coefficient-utt-conditioning"
[ "$TORCHSCRIPT" = "true" ] && ARGS+=" --torchscript"
[ "$USE_COEF_TARGET" = "true" ]  && ARGS+=" --use-coef-tgt"

mkdir -p "$OUTPUT_DIR"

python inference.py $ARGS "$@"
