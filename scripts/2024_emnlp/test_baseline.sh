#!/bin/bash

set -e

DATA_DIR=$1
DATASET=$2
MODEL=$3
ADD_ARGS=$4

langs="ar bg de el es fr hi ru th tr vi zh"
additional_langs="cs lv af ca da fa fi he hu it ja ko lt no pl pt ro sk sl sv ta uk"

mkdir -p $DATA_DIR

CACHE_DIR=$DATA_DIR/cache/datasets
TRANSLATION_DIR=$DATA_DIR/translation
FASTALIGN_DIR=$DATA_DIR/fastalign
DICOALIGN_DIR=$DATA_DIR/dico-align
AWESOME_DIR=$DATA_DIR/awesome-align
RESULT_DIR=$DATA_DIR/raw_results

mkdir -p $CACHE_DIR
mkdir -p $TRANSLATION_DIR
mkdir -p $FASTALIGN_DIR
mkdir -p $DICOALIGN_DIR
mkdir -p $AWESOME_DIR
mkdir -p $RESULT_DIR

export DATA_DIR=$DATA_DIR
export TRANSLATION_DIR=$TRANSLATION_DIR
export FASTALIGN_DIR=$FASTALIGN_DIR
export DICOALIGN_DIR=$DICOALIGN_DIR
export AWESOME_DIR=$AWESOME_DIR


################
# BASELINES
################

echo ""
echo "Testing controlled_realignment.py staged-realignment..."
echo ""
/root/miniconda3/envs/align_freeze/bin/python scripts/2023_acl/controlled_realignment.py \
    --translation_dir $TRANSLATION_DIR/$DATASET \
    --fastalign_dir $FASTALIGN_DIR/$DATASET \
    --dico_dir $DICOALIGN_DIR/$DATASET \
    --awesome_dir $AWESOME_DIR/$DATASET \
    --strategies baseline \
    --models $MODEL \
    --tasks xnli \
    --cache_dir $CACHE_DIR \
    --n_epochs 2 \
    --right_langs $langs \
    --project_prefix "34langs_" \
    --output_file $RESULT_DIR/${MODEL}__xnli__${DATASET}__test_baseline.csv $ADD_ARGS \
    --additional_realignment_langs $additional_langs

