#!/usr/bin/env bash

set -e

: ${DATA_DIR:=/disk/scratch1/s1936986/sgile/downsampled}
: ${ARGS="--extract-mels"}

python prepare_dataset.py \
    --wav-text-filelists /disk/scratch1/s1936986/sgile/downsampled/wav_text.txt \
    --n-workers 16 \
    --batch-size 1 \
    --dataset-path $DATA_DIR \
    --extract-pitch \
    --f0-method pyin \
    $ARGS
